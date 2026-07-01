import Foundation

struct Idea: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var text: String
    var frameworkTag: String
}

struct RiffSession: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var topic: String
    var date: Date
    var ideas: [Idea]
}

/// A single day's free-generation usage counter, keyed by calendar day.
struct DailyUsage: Codable {
    var dayKey: String
    var count: Int
}
