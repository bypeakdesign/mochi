import SwiftUI

struct InboxView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Text("Inbox")
                        .font(ChatFont.bold(InboxMetric.titleSize))
                        .kerning(InboxMetric.titleTracking)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: InboxMetric.titleLineHeight,
                            alignment: .leading
                        )
                        .padding(.top, InboxMetric.titleTopPadding)
                        .padding(.horizontal, InboxMetric.titleHorizontalPadding)

                    VStack(spacing: InboxMetric.sectionGap) {
                        InboxConversationSection(
                            style: .qualified,
                            conversations: InboxData.qualified
                        )
                        InboxConversationSection(
                            style: .noShows,
                            conversations: InboxData.noShows
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, InboxMetric.horizontalPadding)
                    .padding(.vertical, InboxMetric.sectionListVerticalPadding)
                }
                .frame(maxWidth: InboxMetric.contentWidth)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .accessibilityIdentifier("inbox-screen")
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
}
