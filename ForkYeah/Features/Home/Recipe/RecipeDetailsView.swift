import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedImageView(
                    url: recipe.photo_url_large,
                    placeholder: {
                        Color.gray.opacity(0.3)
                    },
                    imageContent: { image in
                        image
                            .resizable()
                            .scaledToFill()
                    }
                )
                .frame(height: 250)
                .clipped()
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Cuisine: \(recipe.cuisine.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let source = recipe.source_url {
                        Link("View Source", destination: source)
                            .padding(.top)
                    }
                    
                    if let youtube = recipe.youtube_url {
                        Link("Watch on YouTube", destination: youtube)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RecipeDetailView(recipe: .sampleList[0])
}
