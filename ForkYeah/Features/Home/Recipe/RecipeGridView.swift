import SwiftUI

struct RecipeGridView: View {
    let recipes: [Recipe]
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeCardView(recipe: recipe)
                        .id(recipe.id)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    RecipeGridView(
        recipes: Recipe.sampleList
    )
}
