import XCTest
import SwiftData
@testable import ForkYeah

@MainActor
final class RecipeRepositoryTests: XCTestCase {
    var context: ModelContext!
    var subject: RecipeRepository!
    
    override func setUp() {
        super.setUp()
        
        context = ModelContext(ModelContainerProvider.makeInMemory())
        subject = RecipeRepository(context: context)
    }
    
    override func tearDown() {
        context = nil
        subject = nil
        
        super.tearDown()
    }
    
    func testGetAllRecipesWithNoCuisineReturnsSortedRecipes() throws {
        let recipe1 = CodableRecipe(uuid: UUID().uuidString, name: "test-name-1", cuisine: "test-cuisine-1")
        let recipe2 = CodableRecipe(uuid: UUID().uuidString, name: "test-name-2", cuisine: "test-cuisine-2")
        try subject.save(recipes: [recipe2, recipe1])
        
        let results = try subject.getAllRecipes(cuisine: nil)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.first?.name, "test-name-1")
        XCTAssertEqual(results.first?.cuisine.name, "test-cuisine-1")
        XCTAssertEqual(results.last?.name, "test-name-2")
        XCTAssertEqual(results.last?.cuisine.name, "test-cuisine-2")
    }
    
    func testGetAllRecipesWithCuisineReturnsSortedRecipesFilteredByCuisine() throws {
        let recipe1 = CodableRecipe(uuid: UUID().uuidString, name: "test-name-1", cuisine: "test-cuisine-1")
        let recipe2 = CodableRecipe(uuid: UUID().uuidString, name: "test-name-2", cuisine: "test-cuisine-2")
        let recipe3 = CodableRecipe(uuid: UUID().uuidString, name: "test-name-3", cuisine: "test-cuisine-2")
        try subject.save(recipes: [recipe1, recipe2, recipe3])
        
        let results = try subject.getAllRecipes(cuisine: .init(name: "test-cuisine-2"))
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.first?.name, "test-name-2")
        XCTAssertEqual(results.first?.cuisine.name, "test-cuisine-2")
        XCTAssertEqual(results.last?.name, "test-name-3")
        XCTAssertEqual(results.last?.cuisine.name, "test-cuisine-2")
    }
    
    func testDuplicateRecipeIsNotSavedTwice() throws {
        let recipe1 = CodableRecipe(uuid: UUID().uuidString, name: "test-name", cuisine: "test-cuisine")
        try subject.save(recipes: [recipe1])
        try subject.save(recipes: [recipe1])
        
        let results = try subject.getAllRecipes(cuisine: nil)
        XCTAssertEqual(results.count, 1)
    }
    
    func testMalformedDataIsIgnored() throws {
        let missingUUID = CodableRecipe(uuid: nil, name: "test-name", cuisine: "test-cuisine")
        let missingName = CodableRecipe(uuid: UUID().uuidString, name: nil, cuisine: "test-cuisine")
        let missingCuisine = CodableRecipe(uuid: UUID().uuidString, name: "test-name", cuisine: nil)
        let badUUID = CodableRecipe(uuid: "bad-uuid", name: "test-name", cuisine: "test-cuisine")
        let recipe1 = CodableRecipe(uuid: UUID().uuidString, name: "test-name", cuisine: "test-cuisine")
        
        try subject.save(recipes: [missingUUID, missingName, missingCuisine, badUUID, recipe1])
        let results = try subject.getAllRecipes(cuisine: nil)
        XCTAssertEqual(results.count, 1)
    }
    
    func testGetAllCuisinesReturnsSortedUniqueCuisines() throws {
        let recipes: [CodableRecipe] = [
            .init(uuid: UUID().uuidString, name: "test-name-1", cuisine: "test-cuisine-1"),
            .init(uuid: UUID().uuidString, name: "test-name-2", cuisine: "test-cuisine-1"),
            .init(uuid: UUID().uuidString, name: "test-name-3", cuisine: "test-cuisine-2")
        ]
        try subject.save(recipes: recipes)
        
        let cuisines = try subject.getAllCuisines()
        XCTAssertEqual(cuisines.count, 2)
        XCTAssertEqual(cuisines.map(\.name), ["test-cuisine-1", "test-cuisine-2"])
    }
    
    func testDeleteAllRemovesAllRecipesAndCuisines() throws {
        let recipes: [CodableRecipe] = [
            .init(uuid: UUID().uuidString, name: "test-name-1", cuisine: "test-cuisine-1"),
            .init(uuid: UUID().uuidString, name: "test-name-2", cuisine: "test-cuisine-2")
        ]
        try subject.save(recipes: recipes)
        
        XCTAssertEqual(try subject.getAllRecipes(cuisine: nil).count, 2)
        XCTAssertEqual(try subject.getAllCuisines().count, 2)
        
        try subject.deleteAll()
        
        XCTAssertEqual(try subject.getAllRecipes(cuisine: nil).count, 0)
        XCTAssertEqual(try subject.getAllCuisines().count, 0)
    }
}
