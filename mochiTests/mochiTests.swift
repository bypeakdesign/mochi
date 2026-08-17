import Foundation
import Testing
@testable import mochi

struct mochiTests {
    @Test func designTokensMatchFigma() {
        #expect(ChatMetric.avatarSize == 60)
        #expect(ChatMetric.storyWidth == 157)
        #expect(ChatMetric.storyHeight == 280)
        #expect(ChatMetric.storyCornerRadius == 20)
        #expect(ChatMetric.bubbleCornerRadius == 20)
        #expect(ChatMetric.cardCornerRadius == 14)
        #expect(ChatMetric.outgoingLeadingPadding == 80)
        #expect(ChatMetric.outgoingTrailingPadding == 24)
        #expect(ChatMetric.incomingTrailingPadding == 48)
        #expect(ChatMetric.composerCornerRadius == 24)
        #expect(ChatMetric.composerClosedEdgePaddingScale == 1)
        #expect(ChatMetric.composerOpenEdgePaddingScale == 0.5)
        #expect(ChatMetric.defaultComposerEdgePadding == 16)
        #expect(ChatMetric.horizontalPadding == 16)
        #expect(ChatMetric.composerActionsPadding == 0)
        #expect(ChatMetric.composerActionsGap == 8)
        #expect(ChatMetric.composerActionHitSize == 40)
        #expect(ChatMetric.sendButtonSize == 40)
        #expect(ChatMetric.headerHeight == 84)
        #expect(ChatMetric.messageListTopFadeHeight == 84)
        #expect(ChatMetric.composerOverlayHeight == 104)
        #expect(ChatMetric.chipScrollFadeStart == 0.95)
        #expect(ChatMetric.chipScrollFadeInset == 20)
        #expect(ChatMetric.tailLarge == 12)
        #expect(ChatMetric.tailSmall == 4)
        #expect(ChatMetric.tailWidth == 17)
        #expect(ChatMetric.tailHeight == 13)
        #expect(ChatMetric.tailHorizontalOutset == 5)
        #expect(ChatCopy.leadName == "harrywatts")
        #expect(ChatCopy.storyKeyword == "START")
        #expect(ChatCopy.automationGreeting == "hey harry, here’s the link to get started")
        #expect(ChatCopy.automationCTA == "Click here to start your free trial")
        #expect(ChatCopy.automationQuestion == "quick question, are you working with appointment setters right now or handling the DMs yourself?")
    }

    @Test func bubbleSidesAreDistinct() {
        #expect(BubbleSide.leading != BubbleSide.trailing)
    }

    @Test func leadTokensMatchFigma() {
        #expect(LeadMetric.contentWidth == 440)
        #expect(LeadMetric.horizontalPadding == 32)
        #expect(LeadMetric.headerTopPadding == 32)
        #expect(LeadMetric.avatarSize == 64)
        #expect(LeadMetric.statusIconContainerSize == 24)
        #expect(LeadMetric.detailsVerticalPadding == 16)
        #expect(LeadMetric.cardPadding == 16)
        #expect(LeadMetric.cardCornerRadius == 24)
        #expect(LeadMetric.joinedCornerRadius == 8)
        #expect(LeadMetric.assigneeAvatarSize == 32)
        #expect(LeadCopy.status == "Qualified")
        #expect(LeadCopy.painPoints.count == 3)
        #expect(LeadCopy.desiredOutcomes.count == 1)
        #expect(LeadCopy.keyQuotes.count == 3)
    }

    @Test func inboxMatchesFigma() {
        #expect(InboxMetric.contentWidth == 440)
        #expect(InboxMetric.titleTopPadding == 48)
        #expect(InboxMetric.titleHorizontalPadding == 24)
        #expect(InboxMetric.horizontalPadding == 16)
        #expect(InboxMetric.sectionListVerticalPadding == 24)
        #expect(InboxMetric.sectionGap == 16)
        #expect(InboxMetric.sectionCornerRadius == 24)
        #expect(InboxMetric.avatarSize == 48)
        #expect(InboxMetric.rowPadding == 16)
        #expect(InboxMetric.tagGap == 4)
        #expect(InboxData.qualified.count == 3)
        #expect(InboxData.qualified[0].preview == ChatCopy.leadSentSecond)
        #expect(InboxData.noShows.count == 5)
    }

    @Test func defaultComposerChipsMatchDesign() {
        let chips = [
            ComposerChip(id: "direct-answer", title: "Direct Answer", isSelected: false),
            ComposerChip(id: "value-pivot", title: "Value Pivot", isSelected: false),
            ComposerChip(id: "customer-insight", title: "Customer Insight", isSelected: false)
        ]
        #expect(chips.count == 3)
        #expect(chips.filter(\.isSelected).isEmpty)
        #expect(ChatCopy.suggestedResponse == "i know the struggle bro, had the same thing when i was trying to scale to my business, you have to hold them accountable with a better system")
    }

    @Test func outgoingMessageTrimsDraft() throws {
        let id = UUID()
        let message = try #require(OutgoingMessage(id: id, draft: "  Hello Maya \n"))
        #expect(message.id == id)
        #expect(message.text == "Hello Maya")
    }

    @Test func outgoingMessageRejectsEmptyDrafts() {
        #expect(OutgoingMessage(draft: "") == nil)
        #expect(OutgoingMessage(draft: " \n\t ") == nil)
    }
}
