import Foundation

protocol APIClientProtocol {
    func fetchRecipes(from endpoint: Endpoint) async throws -> [CodableRecipe]
}

final class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchRecipes(from endpoint: Endpoint) async throws -> [CodableRecipe] {
        let envelope = try await networkService.fetch(RecipesEnvelope.self, from: endpoint.url)
        return envelope.recipes
    }
}
