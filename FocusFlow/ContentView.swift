import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TimerView(viewModel: viewModel)
                    .navigationTitle("Focus")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Timer", systemImage: "timer")
            }
            .tag(0)

            NavigationStack {
                StatsView(viewModel: viewModel)
                    .navigationTitle("Stats")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            .tag(1)

            NavigationStack {
                SettingsView(viewModel: viewModel)
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
