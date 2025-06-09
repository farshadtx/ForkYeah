import SwiftData
@testable import ForkYeah

extension ModelContainerProvider {
    static func makeInMemory() -> ModelContainer {
        try! ModelContainer(
            for: Recipe.self, Cuisine.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
}
