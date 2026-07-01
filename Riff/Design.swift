import SwiftUI
import UIKit

// MARK: - Minimalist, Apple-native color system
// Flat surfaces, system semantic colors (light & dark both correct),
// a single Apple-blue accent. No gradients, no emojis — SF Symbols only.

extension Color {
    static let riffAccent = Color(hex: "#007AFF")
    static let riffCard = Color(uiColor: .secondarySystemBackground)
    static let riffCard2 = Color(uiColor: .tertiarySystemBackground)
    static let riffField = Color(uiColor: .tertiarySystemFill)
    static let riffHair = Color(uiColor: .separator)
}

extension View {
    func riffCard(cornerRadius: CGFloat = 20) -> some View {
        self.padding(16)
            .background(Color.riffCard, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    func riffPill() -> some View {
        self.padding(.horizontal, 14).padding(.vertical, 8)
            .background(Color.riffCard, in: Capsule())
    }

    func prominentButton() -> some View { self.buttonStyle(FilledAccentButtonStyle()) }
    func softButton() -> some View { self.buttonStyle(SoftButtonStyle()) }
}

struct FilledAccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 13)
            .padding(.horizontal, 22)
            .background(Color.riffAccent, in: Capsule())
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SoftButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.medium))
            .foregroundStyle(Color.riffAccent)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(Color.riffCard, in: Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
