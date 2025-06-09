import Foundation
import SwiftData

@MainActor
protocol RecipeRepositoryProtocol {
    func save(recipes: [CodableRecipe]) throws
    func getAllRecipes(cuisine: Cuisine?) throws -> [Recipe]
    func getAllCuisines() throws -> [Cuisine]
    func deleteAll() throws
}

@MainActor
final class RecipeRepository: RecipeRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(recipes: [CodableRecipe]) throws {
        for recipe in recipes {
            try add(recipe: recipe)
        }
        try context.save()
    }
    
    func getAllRecipes(cuisine: Cuisine?) throws -> [Recipe] {
        if let cuisineName = cuisine?.name {
            let descriptor = FetchDescriptor<Recipe>(
                predicate: #Predicate { $0.cuisine.name == cuisineName },
                sortBy: [SortDescriptor(\.name)]
            )
            return try context.fetch(descriptor)
        } else {
            let descriptor = FetchDescriptor<Recipe>(
                sortBy: [SortDescriptor(\.name)]
            )
            return try context.fetch(descriptor)
        }
    }
    
    func getAllCuisines() throws -> [Cuisine] {
        let descriptor = FetchDescriptor<Cuisine>(sortBy: [SortDescriptor(\.name)])
        return try context.fetch(descriptor)
    }
    
    func deleteAll() throws {
        let allRecipes = try context.fetch(FetchDescriptor<Recipe>())
        for recipe in allRecipes {
            context.delete(recipe)
        }
        try context.save()
        
        let allCuisines = try context.fetch(FetchDescriptor<Cuisine>())
        for cuisine in allCuisines {
            context.delete(cuisine)
        }
        try context.save()
    }
}

extension RecipeRepository {
    static var shared: Self {
        .init(context: .init(ModelContainerProvider.shared))
    }
}

extension RecipeRepository {
    private func add(recipe: CodableRecipe) throws {
        guard let valid_uuid = recipe.uuid else {
            print("⚠️ Malformed data - missing uuid")
            return
        }
        
        guard let valid_name = recipe.name else {
            print("⚠️ Malformed data \(valid_uuid) - missing name")
            return
        }
        
        guard let valid_cuisine = recipe.cuisine else {
            print("⚠️ Malformed data \(valid_uuid) - missing cuisine")
            return
        }
        
        guard let uuid = UUID(uuidString: valid_uuid) else {
            print("⚠️ Malformed data \(valid_uuid) - bad uuid")
            return
        }
        
        if try context.fetchCount(
            FetchDescriptor<Recipe>(predicate: #Predicate { $0.uuid == uuid })
        ) > 0 {
            return
        }
        
        let cuisine = try getOrCreateCuisine(named: valid_cuisine)
        
        let recipe = Recipe(
            uuid: uuid,
            name: valid_name,
            cuisine: cuisine,
            photo_url_small: recipe.photo_url_small.map(URL.init(string:)) ?? nil,
            photo_url_large: recipe.photo_url_large.map(URL.init(string:)) ?? nil,
            source_url: recipe.source_url.map(URL.init(string:)) ?? nil,
            youtube_url: recipe.youtube_url.map(URL.init(string:)) ?? nil
        )
        context.insert(recipe)
    }
    
    private func getOrCreateCuisine(named name: String) throws -> Cuisine {
        try context.fetch(
            FetchDescriptor<Cuisine>(predicate: #Predicate { $0.name == name })
        ).first ?? Cuisine(name: name)
    }
}
