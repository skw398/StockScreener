import SwiftUI

@main
struct StockScreenerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SwiftUIView()
                    .tabItem { Text("SwiftUI") }
                
                UIKitView()
                    .tabItem { Text("UIKit") }
            }
        }
    }
}
