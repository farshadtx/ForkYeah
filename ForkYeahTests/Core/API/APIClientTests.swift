import XCTest
import SwiftData
@testable import ForkYeah

@MainActor
final class APIClientTests: XCTestCase {
    private var mockNetworkService: MockNetworkService!
    private var subject: APIClient!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        subject = APIClient(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        subject = nil
        
        super.tearDown()
    }
    
    func testFetchRecipesReturnsCorrectData() async throws {
        let sampleJSON = """
        {
            "recipes": [
                {
                    "uuid": "\(UUID())",
                    "name": "test-name",
                    "cuisine": "test-cuisine",
                    "photo_url_small": null
                }
            ]
        }
        """.data(using: .utf8)!
        mockNetworkService.mockData = sampleJSON
        
        let recipes = try await subject.fetchRecipes(from: .allRecipes)
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "test-name")
    }
    
    func testFetchRecipesThrowsOnFailure() async {
        let badJSON = """
        [
            {
                "name": "test-name",
                "cuisine": "test-cuisine",
                "photo_url_small": null
            }
        ]
        """.data(using: .utf8)!
        mockNetworkService.mockData = badJSON
        
        await XCTAssertThrowsErrorAsync(_ = try await subject.fetchRecipes(from: .allRecipes)) { error in
            XCTAssertNotNil(error)
        }
    }
}
