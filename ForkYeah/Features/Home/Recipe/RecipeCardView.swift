import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedImageView(
                url: recipe.photo_url_small,
                placeholder: {
                    Color.gray.opacity(0.3)
                },
                imageContent: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }
            )
            .frame(height: 100)
            .clipped()
            .cornerRadius(8)
            
            Text(recipe.name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Text(recipe.cuisine.name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .frame(height: 180)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    RecipeCardView(recipe: Recipe.sampleList[1])
}
