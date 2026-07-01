import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var model: AppModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if model.history.isEmpty {
                    ContentUnavailableView(
                        "No Riffs Yet",
                        systemImage: "clock",
                        description: Text("Your past generations will show up here.")
                    )
                } else {
                    List {
                        ForEach(model.history) { session in
                            Section {
                                ForEach(session.ideas) { idea in
                                    Text(idea.text)
                                        .font(.subheadline)
                                }
                            } header: {
                                HStack {
                                    Text(session.topic)
                                    Spacer()
                                    Text(session.date, style: .date)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !model.history.isEmpty {
                        Button("Clear", role: .destructive) { model.clearHistory() }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HistoryView().environmentObject(AppModel())
}
