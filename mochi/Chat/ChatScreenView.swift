import SwiftUI
import UIKit

private enum ChatScrollTarget {
    case bottom
}

struct ChatScreenView: View {
    @State private var draft = ""
    @State private var chips: [ComposerChip] = [
        ComposerChip(id: "direct-answer", title: "Direct Answer", isSelected: false),
        ComposerChip(id: "value-pivot", title: "Value Pivot", isSelected: false),
        ComposerChip(id: "customer-insight", title: "Customer Insight", isSelected: false)
    ]
    @State private var draftMode = ComposerDraftMode.empty
    @State private var composerHeight = ChatMetric.composerOverlayHeight
    @State private var stableDeviceInset = ChatMetric.defaultComposerEdgePadding
    @State private var keyboardIsVisible = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var outgoingMessages: [OutgoingMessage] = []
    @State private var outgoingMessagesAfterAddedHistory: [OutgoingMessage] = []
    @State private var generatedVoiceMessages: [VoiceMessage] = []
    @State private var showsAddedMessages = false
    @State private var addedPricingResponse = false
    @State private var pinsToBottom = false

    private var composerEdgePadding: CGFloat {
        let scale = keyboardIsVisible
            ? ChatMetric.composerOpenEdgePaddingScale
            : ChatMetric.composerClosedEdgePaddingScale
        return stableDeviceInset * scale
    }

    private var composerBottomPadding: CGFloat {
        keyboardIsVisible ? composerEdgePadding : 0
    }

    private var customInputHeight: CGFloat {
        keyboardHeight > 0 ? keyboardHeight : ChatMetric.defaultCustomInputHeight
    }

    private var composerOverlayHeight: CGFloat {
        max(composerHeight, ChatMetric.composerOverlayHeight)
    }

    private var bottomFadeHeight: CGFloat {
        max(0, composerOverlayHeight - composerEdgePadding)
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack {
                Color.white.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        StoryReplyView()
                        AutomationMessagesView()
                        IncomingMessagesView(messages: [
                            ChatCopy.leadSentFirst,
                            ChatCopy.leadSentSecond
                        ])
                        if !outgoingMessages.isEmpty {
                            OutgoingMessagesView(messages: outgoingMessages)
                        }
                        if showsAddedMessages {
                            AddedMessagesView(voiceMessages: generatedVoiceMessages)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        if !outgoingMessagesAfterAddedHistory.isEmpty {
                            OutgoingMessagesView(messages: outgoingMessagesAfterAddedHistory)
                        }
                        if !showsAddedMessages && !generatedVoiceMessages.isEmpty {
                            VoiceMessagesView(messages: generatedVoiceMessages)
                        }
                        Color.clear
                            .frame(height: composerOverlayHeight)
                            .id(ChatScrollTarget.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, ChatMetric.headerHeight)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .defaultScrollAnchor(pinsToBottom ? .bottom : .top, for: .sizeChanges)
                .scrollDismissesKeyboard(.interactively)
                .mask {
                    VerticalScrollFadeMask(
                        topFadeHeight: ChatMetric.messageListTopFadeHeight,
                        bottomFadeHeight: bottomFadeHeight
                    )
                }
                .onChange(of: outgoingMessages.count + outgoingMessagesAfterAddedHistory.count) {
                    scrollToBottom(using: scrollProxy)
                }
                .onChange(of: generatedVoiceMessages.count) {
                    scrollToBottom(using: scrollProxy)
                }
                .onChange(of: showsAddedMessages) {
                    guard showsAddedMessages else { return }
                    scrollToBottom(using: scrollProxy)
                }
                .onChange(of: keyboardIsVisible) {
                    guard keyboardIsVisible else { return }
                    pinsToBottom = true
                    scrollToBottom(using: scrollProxy)
                }

                VStack(spacing: 0) {
                    ChatHeaderView()
                        .background(
                            LinearGradient(
                                colors: [.white, .white.opacity(0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Spacer(minLength: 0)

                    ChatComposerView(
                        draft: $draft,
                        chips: $chips,
                        draftMode: $draftMode,
                        edgePadding: composerEdgePadding,
                        bottomPadding: composerBottomPadding,
                        customInputHeight: customInputHeight,
                        onSend: sendMessage,
                        onAdd: addMessages,
                        onConvertToVoice: generateVoiceMessage
                    )
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(key: ComposerHeightKey.self, value: proxy.size.height)
                        }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .task {
            stableDeviceInset = DeviceMetrics.edgePadding
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
            applyKeyboardFrame(notification)
        }
        .onPreferenceChange(ComposerHeightKey.self) { height in
            guard height > 0 else { return }
            composerHeight = height
        }
    }

    private func applyKeyboardFrame(_ notification: Notification) {
        let overlap = DeviceMetrics.keyboardOverlap(from: notification)
        let duration = DeviceMetrics.keyboardAnimationDuration(from: notification)
        let update = {
            keyboardIsVisible = overlap > 1
            if overlap > 1 {
                keyboardHeight = overlap
            }
        }
        if duration > 0 {
            withAnimation(.easeOut(duration: duration), update)
        } else {
            update()
        }
    }

    private func sendMessage() {
        guard let message = OutgoingMessage(draft: draft) else { return }
        withAnimation(.snappy(duration: 0.38)) {
            if showsAddedMessages {
                outgoingMessagesAfterAddedHistory.append(message)
            } else {
                outgoingMessages.append(message)
            }
            resetComposer()
        }
    }

    private func generateVoiceMessage() {
        withAnimation(.snappy(duration: 0.38)) {
            generatedVoiceMessages.append(VoiceMessage(duration: 8))
            resetComposer()
        }
    }

    private func addMessages() {
        if !showsAddedMessages {
            withAnimation(.snappy(duration: 0.38)) {
                showsAddedMessages = true
            }
            return
        }

        guard !addedPricingResponse else { return }
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            draft = ChatCopy.pricingResponse
            draftMode = .typed
            addedPricingResponse = true
            chips = chips.map { chip in
                var updated = chip
                updated.isSelected = false
                return updated
            }
        }
    }

    private func scrollToBottom(using scrollProxy: ScrollViewProxy) {
        withAnimation(.smooth(duration: 0.45)) {
            scrollProxy.scrollTo(ChatScrollTarget.bottom, anchor: .bottom)
        }
    }

    private func resetComposer() {
        draft = ""
        draftMode = .empty
        chips = chips.map { chip in
            var updated = chip
            updated.isSelected = false
            return updated
        }
    }
}

#Preview {
    ChatScreenView()
}
