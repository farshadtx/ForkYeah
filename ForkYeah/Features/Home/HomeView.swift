import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel.shared()
    @ObservedObject private var settings = AppSettings.shared
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                if !viewModel.hasLoaded {
                    LoadingView()
                } else if viewModel.recipes.isEmpty {
                    NoRecipeView()
                } else {
                    CuisineSelectionView(
                        cuisines: viewModel.cuisinesWithAll,
                        selectedCuisine: viewModel.selectedCuisine
                    ) { selected in
                        viewModel.selectCuisine(selected)
                    }
                    
                    ScrollView {
                        Color.clear
                            .frame(height: 8)
                            .id("scrollTop")
                        
                        RecipeGridView(recipes: viewModel.recipes)
                    }
                    .onChange(of: viewModel.recipes) { _, _ in
                        withAnimation {
                            proxy.scrollTo("scrollTop", anchor: .top)
                        }
                    }
                }
            }
        }
        .navigationTitle("Fork Yeah")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    Task {
                        await viewModel.refreshEverything()
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                }
            }
        }
        .onChange(of: settings.endpoint) { _, _ in
            Task { await viewModel.loadRecipes() }
        }
        .task {
            if !viewModel.hasLoaded {
                await viewModel.loadRecipes()
            }
        }
    }
}

#Preview {
    HomeView()
}
