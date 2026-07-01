import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var store: Store
    @FocusState private var topicFocused: Bool
    @State private var showHistory = false
    @State private var showSettings = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                inputCard

                if !model.currentIdeas.isEmpty {
                    ideasSection
                }

                if !store.isPro {
                    usageBanner
                }
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Riff")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showHistory = true
                } label: {
                    Image(systemName: "clock")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showHistory) { HistoryView() }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .scrollDismissesKeyboard(.interactively)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Type a topic. Get instant idea riffs.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("A topic, product, or problem...", text: $model.topic, axis: .vertical)
                .font(.body)
                .lineLimit(1...3)
                .focused($topicFocused)
                .padding(12)
                .background(Color.riffField, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .submitLabel(.go)
                .onSubmit(generate)

            Button {
                generate()
            } label: {
                HStack {
                    if model.isGenerating {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "wand.and.stars")
                    }
                    Text("Generate Riffs")
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .prominentButton()
            .disabled(model.topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || model.isGenerating)
        }
        .riffCard()
    }

    private var ideasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Riffs on \u{201C}\(model.currentIdeas.first != nil ? lastTopic : "")\u{201D}")
                .font(.headline)
                .lineLimit(1)

            ForEach(model.currentIdeas) { idea in
                IdeaRow(idea: idea)
            }
        }
    }

    private var lastTopic: String {
        model.history.first?.topic ?? model.topic
    }

    private var usageBanner: some View {
        HStack {
            Image(systemName: "bolt.fill")
                .foregroundStyle(Color.riffAccent)
            Text("\(model.remainingFreeToday) of \(AppModel.freeDailyLimit) free generations left today")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Unlock Unlimited") {
                model.showPaywall = true
            }
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Color.riffAccent)
        }
        .riffCard(cornerRadius: 16)
    }

    private func generate() {
        topicFocused = false
        model.generate(isPro: store.isPro)
    }
}

struct IdeaRow: View {
    let idea: Idea

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(idea.frameworkTag.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color.riffAccent)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.riffAccent.opacity(0.12), in: Capsule())
                .fixedSize()

            Text(idea.text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.riffCard2, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(AppModel())
        .environmentObject(Store())
}
