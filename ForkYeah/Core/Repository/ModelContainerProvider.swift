import SwiftData

enum ModelContainerProvider {
    static let shared: ModelContainer = {
        do {
            return try ModelContainer(for: Recipe.self, Cuisine.self)
        } catch {
            fatalError("❌ Could not create ModelContainer: \(error)")
        }
    }()
}
