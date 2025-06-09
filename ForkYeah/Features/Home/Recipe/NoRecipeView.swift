import SwiftUI

struct NoRecipeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "carrot.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            Text("No recipes found")
                .font(.largeTitle)
            
            VStack(spacing: 0) {
                Text("Try a different network connection")
                Text("or change the endpoint!")
            }
            .font(.subheadline)
        }
        .padding(.horizontal)
        .foregroundColor(.gray)
    }
}

#Preview {
    NoRecipeView()
}
