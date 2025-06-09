import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            HomeView()
                .toolbar {                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    NavigationStack {
                        SettingsView()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
