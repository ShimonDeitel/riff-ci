import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(store.isPro ? "Riff Pro" : "Free")
                            .foregroundStyle(store.isPro ? Color.riffAccent : .secondary)
                    }
                }

                if !store.isPro {
                    Section {
                        Button("Unlock Riff Pro") {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                NotificationCenter.default.post(name: .riffShowPaywall, object: nil)
                            }
                        }
                        .foregroundStyle(Color.riffAccent)
                    }
                }

                Section {
                    Button("Restore Purchases") {
                        Task { await store.restore() }
                    }
                }

                Section {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/riff-site/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/riff-site/terms.html")!)
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

extension Notification.Name {
    static let riffShowPaywall = Notification.Name("riffShowPaywall")
}

#Preview {
    SettingsView().environmentObject(Store())
}
