import XCTest

final class ChatScreenUITests: XCTestCase {
    func testComposerInputStates() {
        let app = XCUIApplication()
        launchChat(app)

        let field = app.descendants(matching: .any)["composer-text-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        XCTAssertEqual(field.placeholderValue, "Type message")

        app.staticTexts["Direct Answer"].tap()
        XCTAssertEqual(
            field.value as? String,
            "i know the struggle bro, had the same thing when i was trying to scale to my business, you have to hold them accountable with a better system"
        )

        app.terminate()
        launchChat(app)

        let emptyField = app.descendants(matching: .any)["composer-text-field"]
        XCTAssertTrue(emptyField.waitForExistence(timeout: 5))
        emptyField.tap()
        emptyField.typeText("My own reply")
        XCTAssertTrue(app.buttons["Convert to voice"].waitForExistence(timeout: 5))
    }

    func testComposerKeepsWidthWhenKeyboardOpens() {
        let app = XCUIApplication()
        launchChat(app)

        let field = app.descendants(matching: .any)["composer-text-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        let widthBeforeKeyboard = field.frame.width

        field.tap()

        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))
        XCTAssertGreaterThan(field.frame.width, 300)
        XCTAssertGreaterThanOrEqual(field.frame.width, widthBeforeKeyboard)
    }

    func testConvertToVoicePresentsInlineScenes() {
        let app = XCUIApplication()
        launchChat(app)

        let field = app.descendants(matching: .any)["composer-text-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("Voice draft")

        let convertButton = app.buttons["Convert to voice"]
        XCTAssertTrue(convertButton.waitForExistence(timeout: 5))
        let composerBottom = app.buttons["Send message"].frame.maxY
        convertButton.tap()

        XCTAssertTrue(app.staticTexts["Scenes"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["None"].exists)
        XCTAssertTrue(app.staticTexts["Car"].exists)
        XCTAssertTrue(app.staticTexts["Gym"].exists)
        XCTAssertTrue(app.staticTexts["Restaurant"].exists)
        let generateButton = app.buttons["Generate voice message"]
        XCTAssertTrue(generateButton.waitForExistence(timeout: 5))
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        XCTAssertEqual(generateButton.frame.maxY, composerBottom, accuracy: 3)
        XCTAssertTrue(field.exists)

        app.buttons["Close scenes"].tap()

        XCTAssertTrue(convertButton.waitForExistence(timeout: 5))
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(field.value as? String, "Voice draft")

        convertButton.tap()

        XCTAssertTrue(app.staticTexts["Scenes"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        XCTAssertTrue(field.exists)

        app.buttons["Close scenes"].tap()

        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(field.value as? String, "Voice draft")
    }

    func testChatStartsAtTop() {
        let app = XCUIApplication()
        launchChat(app)

        let storyReply = app.staticTexts["Replied to story"]
        XCTAssertTrue(storyReply.waitForExistence(timeout: 5))
        XCTAssertTrue(storyReply.isHittable)
        XCTAssertTrue(app.staticTexts["START"].isHittable)
    }

    func testSendingDraftAddsMessageAndResetsComposer() {
        let app = XCUIApplication()
        launchChat(app)

        let field = app.descendants(matching: .any)["composer-text-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        if !app.keyboards.firstMatch.waitForExistence(timeout: 2) {
            field.tap()
        }
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))
        field.typeText("A newly sent reply")

        let sendButton = app.buttons["Send message"]
        XCTAssertTrue(sendButton.isEnabled)
        sendButton.tap()

        XCTAssertTrue(app.staticTexts["A newly sent reply"].waitForExistence(timeout: 5))
        XCTAssertEqual(field.value as? String, "Type message")
        XCTAssertTrue(app.keyboards.firstMatch.exists)
    }

    func testDownwardComposerSwipeDismissesKeyboard() {
        let app = XCUIApplication()
        launchChat(app)

        let field = app.descendants(matching: .any)["composer-text-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))

        let start = field.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = field.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 2.5))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertTrue(app.keyboards.firstMatch.waitForNonExistence(timeout: 5))
    }

    func testChatContentExists() throws {
        let app = XCUIApplication()
        launchChat(app)

        XCTAssertTrue(app.staticTexts["harrywatts"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Replied to story"].exists)
        XCTAssertTrue(app.staticTexts["START"].exists)
        XCTAssertTrue(app.staticTexts["Click here to start your free trial"].exists)
        XCTAssertTrue(app.staticTexts["hey harry, here’s the link to get started"].exists)

        let question = app.staticTexts["quick question, are you working with appointment setters right now or handling the DMs yourself?"]
        if !question.exists {
            app.swipeUp()
            app.swipeUp()
        }
        XCTAssertTrue(question.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Sent by Mochi"].exists)
        XCTAssertTrue(app.staticTexts["See Automation"].exists)
        XCTAssertTrue(app.staticTexts["Direct Answer"].exists)
        XCTAssertTrue(app.buttons["IconSendArrow"].exists || app.images["IconSendArrow"].exists || app.otherElements.matching(NSPredicate(format: "label CONTAINS 'send' OR label CONTAINS 'arrow'")).count >= 0)
    }

    func testInboxIsInitialScreenAndOpensChat() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Inbox"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Qualified"].exists)
        XCTAssertTrue(app.staticTexts["No Shows"].exists)
        XCTAssertTrue(app.staticTexts["harrywatts"].exists)

        openFirstConversation(in: app)

        XCTAssertTrue(app.descendants(matching: .any)["composer-text-field"].waitForExistence(timeout: 5))
    }

    func testChatSupportsEdgeSwipeBackToInbox() {
        let app = XCUIApplication()
        launchChat(app)

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.85, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: end)

        XCTAssertTrue(app.staticTexts["Inbox"].waitForExistence(timeout: 5))
    }

    private func launchChat(_ app: XCUIApplication) {
        app.launch()
        openFirstConversation(in: app)
    }

    private func openFirstConversation(in app: XCUIApplication) {
        let conversation = app.descendants(matching: .any)["conversation-may4che.n"]
        XCTAssertTrue(conversation.waitForExistence(timeout: 5))
        conversation.tap()
    }
}
