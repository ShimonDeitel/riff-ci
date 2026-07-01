import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "wand.and.stars")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.riffAccent)

                VStack(spacing: 8) {
                    Text("Riff Pro")
                        .font(.title.bold())
                    Text("Unlimited idea riffs, every day.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 14) {
                    FeatureRow(icon: "infinity", text: "Unlimited generations, no daily cap")
                    FeatureRow(icon: "clock.arrow.circlepath", text: "Full history saved on-device")
                    FeatureRow(icon: "bolt.fill", text: "One-time purchase — pay once, own forever")
                }
                .padding(.horizontal, 8)

                Spacer()

                VStack(spacing: 10) {
                    Button {
                        Task {
                            let success = await store.purchase()
                            if success { dismiss() }
                        }
                    } label: {
                        HStack {
                            if store.purchaseInFlight {
                                ProgressView().tint(.white)
                            }
                            Text("Unlock Pro — \(store.displayPrice)")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .prominentButton()
                    .disabled(store.purchaseInFlight)

                    Button("Restore Purchases") {
                        Task { await store.restore() }
                    }
                    .softButton()
                }

                Button("Not Now") { dismiss() }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.riffAccent)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

#Preview {
    PaywallView().environmentObject(Store())
}
