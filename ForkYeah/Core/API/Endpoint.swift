import Foundation

enum Endpoint: String, CaseIterable, Identifiable {
    case allRecipes
    case malformedData
    case emptyData

    var id: String {
        rawValue
    }

    static var defaultValue: Endpoint { .allRecipes }
}

extension Endpoint {
    var title: String {
        switch self {
            case .allRecipes:
                return "All Recipes"
            case .malformedData:
                return "Malformed Data"
            case .emptyData:
                return "Empty Data"
        }
    }

    var url: URL {
        switch self {
            case .allRecipes:
                return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
            case .malformedData:
                return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
            case .emptyData:
                return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        }
    }
}
