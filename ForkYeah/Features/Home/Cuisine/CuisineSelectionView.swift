import SwiftUI

struct CuisineSelectionView: View {
    let cuisines: [Cuisine?]
    let selectedCuisine: Cuisine?
    let onSelect: (Cuisine?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(cuisines, id: \.self) { cuisine in
                    let isSelected = selectedCuisine == cuisine
                    
                    Button(action: {
                        onSelect(cuisine)
                    }) {
                        Text(cuisine?.name ?? "All")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .foregroundColor(isSelected ? .blue : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isSelected ? Color.blue : .clear, lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)
        }
    }
}
