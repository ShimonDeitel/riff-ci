import Foundation

/// On-device ideation engine. Combines the user's topic with a large, curated bank of
/// ideation frameworks (SCAMPER-style substitute/combine/adapt/modify/put-to-other-use/
/// eliminate/reverse, plus angle/twist templates used by professional brainstorm facilitators).
/// Each call randomizes framework selection and phrasing variant so repeated runs on the
/// same topic feel fresh rather than mechanically identical.
enum IdeaGenerator {

    private struct Template {
        let tag: String
        let variants: [String]
    }

    private static let templates: [Template] = [
        Template(tag: "Substitute", variants: [
            "Swap the core ingredient of %@ for something unexpected — what changes?",
            "Replace the main tool people use for %@ with a cheaper, simpler one.",
            "What if %@ used a completely different material or medium?"
        ]),
        Template(tag: "Combine", variants: [
            "Combine %@ with an unrelated hobby — what hybrid emerges?",
            "Merge %@ with a subscription model — what would people pay monthly for?",
            "Pair %@ with a community or social layer — who would you do it with?"
        ]),
        Template(tag: "Adapt", variants: [
            "Adapt %@ for total beginners — what would a first-day version look like?",
            "Borrow a technique from a totally different field and apply it to %@.",
            "What would %@ look like if it were designed for kids?"
        ]),
        Template(tag: "Magnify", variants: [
            "Make %@ 10x bigger, longer, or more ambitious — what does that look like?",
            "What's the extreme, over-the-top version of %@?",
            "Scale %@ up to serve a thousand people at once — what breaks, what changes?"
        ]),
        Template(tag: "Minify", variants: [
            "Make %@ 10x simpler — strip it down to one single step.",
            "What's the 5-minute version of %@?",
            "Remove every non-essential part of %@ — what's left?"
        ]),
        Template(tag: "Repurpose", variants: [
            "Put %@ to a completely different use than its original purpose.",
            "Who else — outside the obvious audience — could benefit from %@?",
            "What's an unexpected industry where %@ would be valuable?"
        ]),
        Template(tag: "Eliminate", variants: [
            "Remove the most annoying step in %@ entirely — how?",
            "What part of %@ could you cut completely and lose nothing important?",
            "Eliminate the cost from %@ — what's the free version?"
        ]),
        Template(tag: "Reverse", variants: [
            "Invert %@ — what if you did the exact opposite?",
            "Flip the usual order of %@ — start where it normally ends.",
            "What if the person usually served by %@ became the one providing it?"
        ]),
        Template(tag: "Gamify", variants: [
            "Turn %@ into a game with streaks, levels, or a leaderboard.",
            "Add a daily challenge or competition on top of %@.",
            "What would a playful, scorekeeping version of %@ look like?"
        ]),
        Template(tag: "Automate", variants: [
            "Automate the most repetitive part of %@.",
            "What would a 'set it and forget it' version of %@ look like?",
            "Use a simple recurring routine to make %@ effortless."
        ]),
        Template(tag: "Niche Down", variants: [
            "Narrow %@ to serve one very specific type of person extremely well.",
            "What's a hyper-specific version of %@ for a single use case?",
            "Focus %@ on the 1 audience segment everyone else ignores."
        ]),
        Template(tag: "Collaborate", variants: [
            "Turn %@ into something two people do together, not alone.",
            "What if %@ required a partner or a small group?",
            "Add a mentor/mentee angle to %@."
        ])
    ]

    /// Generates a fresh, randomized set of idea riffs for the given topic.
    static func generate(topic: String, count: Int = 7) -> [Idea] {
        let cleaned = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return [] }

        var pool = templates.shuffled()
        var results: [Idea] = []
        var used = Set<String>()

        while results.count < count && !pool.isEmpty {
            let template = pool.removeFirst()
            guard let phrase = template.variants.randomElement() else { continue }
            let text = String(format: phrase, cleaned)
            guard !used.contains(text) else { continue }
            used.insert(text)
            results.append(Idea(text: text, frameworkTag: template.tag))
        }

        // If count exceeds the number of distinct frameworks, refill by reshuffling
        // the framework list and drawing a different phrasing variant each pass.
        if results.count < count {
            var extraPool = templates.shuffled()
            while results.count < count {
                if extraPool.isEmpty { extraPool = templates.shuffled() }
                let template = extraPool.removeFirst()
                guard let phrase = template.variants.randomElement() else { continue }
                let text = String(format: phrase, cleaned)
                guard !used.contains(text) else { continue }
                used.insert(text)
                results.append(Idea(text: text, frameworkTag: template.tag))
            }
        }

        return results
    }
}
