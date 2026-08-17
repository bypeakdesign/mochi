import SwiftUI

enum LeadMetric {
    static let contentWidth: CGFloat = 440
    static let horizontalPadding: CGFloat = 32
    static let headerTopPadding: CGFloat = 32
    static let headerGap: CGFloat = 24
    static let avatarSize: CGFloat = 64
    static let statusIconContainerSize: CGFloat = 24
    static let statusIconSize: CGFloat = 16
    static let statusChevronSize: CGFloat = 20
    static let statusGap: CGFloat = 8
    static let statusLeadingPadding: CGFloat = 10
    static let statusTrailingPadding: CGFloat = 12
    static let statusVerticalPadding: CGFloat = 10
    static let detailsVerticalPadding: CGFloat = 16
    static let detailsGap: CGFloat = 4
    static let cardPadding: CGFloat = 16
    static let cardContentGap: CGFloat = 6
    static let cardCornerRadius: CGFloat = 24
    static let joinedCornerRadius: CGFloat = 8
    static let tagGap: CGFloat = 8
    static let tagPadding: CGFloat = 6
    static let tagIconSize: CGFloat = 16
    static let tagLabelHorizontalPadding: CGFloat = 6
    static let assigneeAvatarSize: CGFloat = 32
    static let assigneeRowHeight: CGFloat = 20
    static let summarySectionGap: CGFloat = 24
    static let summaryItemGap: CGFloat = 8
    static let summaryRowGap: CGFloat = 10
    static let summaryIconSize: CGFloat = 20
}

enum LeadFont {
    static let name = ChatFont.bold(24)
    static let status = ChatFont.semibold(16)
    static let metadata = ChatFont.regular(12)
    static let tag = ChatFont.medium(14.5)
    static let assignee = ChatFont.medium(16)
    static let summaryTitle = ChatFont.semibold(20)
    static let summaryHeading = ChatFont.medium(16)
    static let summaryBody = ChatFont.regular(16)
}

enum LeadCopy {
    static let name = "harrywatts"
    static let status = "Qualified"
    static let setter = "Jordan"
    static let closer = "Alex Romero"

    static let painPoints = [
        "Is frustrated with his current team members",
        "Hates losing money in his inbox",
        "Already tried hiring managers but didn’t see any improvements"
    ]

    static let desiredOutcomes = [
        "Wants to scale his coaching business to $50k/mo"
    ]

    static let keyQuotes = [
        "“i have 2 setters but tbh looking for a better way to manage them”",
        "“they are leaving qualified leads waiting for hours in the inbox, we’re probably losing tons of money”",
        "“Budget is $5k.”"
    ]
}
