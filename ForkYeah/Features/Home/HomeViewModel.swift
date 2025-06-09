import SwiftData
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var hasLoaded = false
    @Published var selectedCuisine: Cuisine? = nil
    @Published var recipes: [Recipe] = []
    @Published var cuisines: [Cuisine] = []
    
    var cuisinesWithAll: [Cuisine?] {
        [nil] + cuisines
    }
    
    private let repository: RecipeRepositoryProtocol
    private let apiClient: APIClientProtocol
    private let cacheService: CacheServiceProtocol
    private let settings: AppSettings
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        repository: RecipeRepositoryProtocol,
        apiClient: APIClientProtocol,
        cacheService: CacheServiceProtocol,
        settings: AppSettings
    ) {
        self.repository = repository
        self.apiClient = apiClient
        self.cacheService = cacheService
        self.settings = settings
        
        observeCacheReset()
    }
    
    func refreshEverything() async {
        selectedCuisine = nil
        try? repository.deleteAll()
        await loadRecipes()
    }
    
    func loadRecipes() async {
        do {
            let recipes = try await apiClient.fetchRecipes(from: settings.endpoint)
            try repository.save(recipes: recipes)
            try queryRecipes()
        } catch {
            print("❌ Failed to load recipes:", error)
        }
        hasLoaded = true
    }
    
    func selectCuisine(_ cuisine: Cuisine?) {
        selectedCuisine = cuisine
        try? queryRecipes()
    }
}

extension HomeViewModel {
    private func queryRecipes() throws {
        self.recipes = try repository.getAllRecipes(cuisine: selectedCuisine)
        self.cuisines = try repository.getAllCuisines()
    }
    
    private func observeCacheReset() {
        settings.cacheResetRequested
            .sink {
                CacheService.shared.clear()
            }
            .store(in: &cancellables)
    }
}

@MainActor
extension HomeViewModel {
    static func shared() -> HomeViewModel {
        let context = ModelContext(ModelContainerProvider.shared)
        return HomeViewModel(
            repository: RecipeRepository(context: context),
            apiClient: APIClient.shared,
            cacheService: CacheService.shared,
            settings: .shared
        )
    }
}
