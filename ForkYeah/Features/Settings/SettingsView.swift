import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = AppSettings.shared
    
    var body: some View {
        Form {
            Section(header: Text("API Endpoint")) {
                Picker("Current", selection: $settings.endpoint) {
                    ForEach(Endpoint.allCases) { endpoint in
                        Text(endpoint.title)
                            .tag(endpoint)
                    }
                }
                .pickerStyle(.menu)
            }
            
            HStack {
                Text("Delete Cache")
                
                Spacer()
                
                Button {
                    settings.resetCache()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
