import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 32) {
            ProgressView("Loading...")
                .scaleEffect(2.0)
                .padding()
            
            Text("Fetching the best dishes!")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    LoadingView()
}
