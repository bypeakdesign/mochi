import Foundation

struct InboxConversation: Identifiable {
    let id: String
    let username: String
    let preview: String
    let timestamp: String
    let avatarAsset: String
    let ring: InboxAvatarRing
    let unread: InboxUnreadState
    let tags: [InboxTag]
}

enum InboxAvatarRing {
    case high
    case standard
    case medium
    case low
}

enum InboxUnreadState {
    case count(Int)
    case dot
    case none
}

struct InboxTag: Identifiable {
    let title: String
    let iconAsset: String
    var trailingPadding: CGFloat = InboxMetric.tagTrailingPadding

    var id: String {
        title
    }
}

enum InboxData {
    static let mayaID = "may4che.n"

    static let storyReply = InboxTag(title: "Story Reply", iconAsset: "IconPlayCircle")
    static let creator = InboxTag(title: "Creator", iconAsset: "IconPlay")
    static let inbound = InboxTag(title: "Inbound", iconAsset: "IconBubble3")
    static let courseCreator = InboxTag(title: "Course Creator", iconAsset: "IconGraduateCap")
    static let agency = InboxTag(title: "Agency", iconAsset: "IconTeam")
    static let callBooked = InboxTag(title: "Call Booked", iconAsset: "IconCall")
    static let slowFollowUp = InboxTag(
        title: "Slow Follow-up",
        iconAsset: "IconEmojiSad",
        trailingPadding: InboxMetric.tagPadding
    )
    static let highDMVolume = InboxTag(
        title: "High DM Volume",
        iconAsset: "IconEmojiSad",
        trailingPadding: InboxMetric.tagPadding
    )
    static let leadQualification = InboxTag(
        title: "Lead Qualification",
        iconAsset: "IconEmojiSad",
        trailingPadding: InboxMetric.tagPadding
    )
    static let inboxManagement = InboxTag(
        title: "Inbox Management",
        iconAsset: "IconEmojiSad",
        trailingPadding: InboxMetric.tagPadding
    )
    static let consistency = InboxTag(
        title: "Consistency",
        iconAsset: "IconEmojiSad",
        trailingPadding: InboxMetric.tagPadding
    )
    static let missedFollowUps = InboxTag(
        title: "Missed Follow-Ups",
        iconAsset: "IconEmojiSad",
        trailingPadding: InboxMetric.tagPadding
    )

    static let qualified = [
        InboxConversation(
            id: "harrywatts",
            username: "harrywatts",
            preview: ChatCopy.leadSentSecond,
            timestamp: "2m",
            avatarAsset: "InboxHarrywttsAvatar",
            ring: .high,
            unread: .count(1),
            tags: [storyReply, creator]
        ),
        InboxConversation(
            id: "sennaverheij",
            username: "sennaverheij",
            preview: "We’d start with six client accounts. If my team can share the inbox, I’m ready to try it.",
            timestamp: "1h",
            avatarAsset: "InboxSennaverheijAvatar",
            ring: .standard,
            unread: .none,
            tags: [inbound, courseCreator, slowFollowUp]
        ),
        InboxConversation(
            id: "sofiabuilds",
            username: "sofiabuilds",
            preview: "i’m launching again next month, so ideally I’d have everything set up before then",
            timestamp: "2h",
            avatarAsset: "InboxSofiabuildsAvatar",
            ring: .standard,
            unread: .none,
            tags: [storyReply, creator, highDMVolume]
        )
    ]

    static let noShows = [
        InboxConversation(
            id: mayaID,
            username: mayaID,
            preview: "yeah, exactly. I need something that can keep up during launches without sounding robotic",
            timestamp: "34m",
            avatarAsset: "InboxMayaAvatar",
            ring: .medium,
            unread: .none,
            tags: [inbound, agency, slowFollowUp]
        ),
        InboxConversation(
            id: "leomartinez",
            username: "leomartinez",
            preview: "You: Yes, it can qualify leads automatically and hand the conversation over when they’re ready.",
            timestamp: "8m",
            avatarAsset: "InboxLeomartinezAvatar",
            ring: .low,
            unread: .dot,
            tags: [storyReply, creator, leadQualification]
        ),
        InboxConversation(
            id: "hannahb.co",
            username: "hannahb.co",
            preview: "You: You can connect multiple Instagram accounts on the Agency plan.",
            timestamp: "21m",
            avatarAsset: "InboxHannahbAvatar",
            ring: .standard,
            unread: .dot,
            tags: [inbound, agency, inboxManagement]
        ),
        InboxConversation(
            id: "marcuscole.fit",
            username: "marcuscole.fit",
            preview: "You: You’re booked for Tuesday at 2. I’ve added your team size and current DM volume to the notes.",
            timestamp: "1d",
            avatarAsset: "InboxMarcuscoleAvatar",
            ring: .standard,
            unread: .none,
            tags: [callBooked, creator, consistency]
        ),
        InboxConversation(
            id: "oliviagrantrealty",
            username: "oliviagrantrealty",
            preview: "You: That’s exactly where automated follow-ups can help. How many new inquiries does your team get each week?",
            timestamp: "1d",
            avatarAsset: "InboxOliviagrantAvatar",
            ring: .standard,
            unread: .none,
            tags: [storyReply, creator, missedFollowUps]
        )
    ]
}
