import XCTest
@testable import Riff

final class IdeaGeneratorTests: XCTestCase {
    func testGeneratesRequestedCount() {
        let ideas = IdeaGenerator.generate(topic: "a coffee shop", count: 7)
        XCTAssertEqual(ideas.count, 7)
    }

    func testIdeasContainTopic() {
        let ideas = IdeaGenerator.generate(topic: "photography", count: 5)
        for idea in ideas {
            XCTAssertTrue(idea.text.contains("photography"))
        }
    }

    func testEmptyTopicReturnsEmpty() {
        let ideas = IdeaGenerator.generate(topic: "   ", count: 5)
        XCTAssertTrue(ideas.isEmpty)
    }

    func testIdeasAreUnique() {
        let ideas = IdeaGenerator.generate(topic: "gardening", count: 8)
        let texts = Set(ideas.map { $0.text })
        XCTAssertEqual(texts.count, ideas.count)
    }
}

final class AppModelTests: XCTestCase {
    @MainActor
    func testFreeLimitEnforced() {
        UserDefaults.standard.removeObject(forKey: "riff.usage.v1")
        UserDefaults.standard.removeObject(forKey: "riff.history.v1")
        let model = AppModel()
        model.topic = "testing"
        for _ in 0..<AppModel.freeDailyLimit {
            XCTAssertTrue(model.generate(isPro: false))
        }
        XCTAssertFalse(model.generate(isPro: false))
        XCTAssertTrue(model.showPaywall)
    }

    @MainActor
    func testProBypassesLimit() {
        UserDefaults.standard.removeObject(forKey: "riff.usage.v1")
        UserDefaults.standard.removeObject(forKey: "riff.history.v1")
        let model = AppModel()
        model.topic = "testing pro"
        for _ in 0..<10 {
            XCTAssertTrue(model.generate(isPro: true))
        }
    }
}
