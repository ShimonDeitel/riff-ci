import SwiftUI

struct RootView: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationStack {
            HomeView()
        }
        .tint(Color.riffAccent)
        .sheet(isPresented: $model.showPaywall) {
            PaywallView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .riffShowPaywall)) { _ in
            model.showPaywall = true
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppModel())
        .environmentObject(Store())
}
