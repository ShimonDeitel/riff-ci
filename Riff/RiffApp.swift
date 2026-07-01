import SwiftUI

@main
struct RiffApp: App {
    @StateObject private var model = AppModel()
    @StateObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
                .environmentObject(store)
        }
    }
}
