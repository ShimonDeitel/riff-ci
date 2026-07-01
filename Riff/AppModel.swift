import Foundation
import SwiftUI

@MainActor
final class AppModel: ObservableObject {
    static let freeDailyLimit = 5
    private static let historyKey = "riff.history.v1"
    private static let usageKey = "riff.usage.v1"

    @Published var topic: String = ""
    @Published var currentIdeas: [Idea] = []
    @Published var history: [RiffSession] = []
    @Published var isGenerating: Bool = false
    @Published var showPaywall: Bool = false

    private var usage: DailyUsage

    init() {
        self.usage = Self.loadUsage()
        self.history = Self.loadHistory()
    }

    private static func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    var remainingFreeToday: Int {
        let key = Self.todayKey()
        let count = usage.dayKey == key ? usage.count : 0
        return max(0, Self.freeDailyLimit - count)
    }

    func canGenerate(isPro: Bool) -> Bool {
        isPro || remainingFreeToday > 0
    }

    /// Generates a fresh idea set for the current topic. Returns false (and flips
    /// `showPaywall`) if the free daily limit is exhausted and the user isn't Pro.
    @discardableResult
    func generate(isPro: Bool) -> Bool {
        guard canGenerate(isPro: isPro) else {
            showPaywall = true
            return false
        }
        isGenerating = true
        defer { isGenerating = false }

        let ideas = IdeaGenerator.generate(topic: topic)
        guard !ideas.isEmpty else { return false }

        currentIdeas = ideas
        recordUsage(isPro: isPro)

        let session = RiffSession(topic: topic, date: Date(), ideas: ideas)
        history.insert(session, at: 0)
        if history.count > 100 { history.removeLast(history.count - 100) }
        saveHistory()

        return true
    }

    private func recordUsage(isPro: Bool) {
        guard !isPro else { return }
        let key = Self.todayKey()
        if usage.dayKey == key {
            usage.count += 1
        } else {
            usage = DailyUsage(dayKey: key, count: 1)
        }
        saveUsage()
    }

    func clearHistory() {
        history = []
        saveHistory()
    }

    // MARK: - Persistence

    private static func loadHistory() -> [RiffSession] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let decoded = try? JSONDecoder().decode([RiffSession].self, from: data) else { return [] }
        return decoded
    }

    private func saveHistory() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: Self.historyKey)
    }

    private static func loadUsage() -> DailyUsage {
        guard let data = UserDefaults.standard.data(forKey: usageKey),
              let decoded = try? JSONDecoder().decode(DailyUsage.self, from: data) else {
            return DailyUsage(dayKey: todayKey(), count: 0)
        }
        return decoded
    }

    private func saveUsage() {
        guard let data = try? JSONEncoder().encode(usage) else { return }
        UserDefaults.standard.set(data, forKey: Self.usageKey)
    }
}
