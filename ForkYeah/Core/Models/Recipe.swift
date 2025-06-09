import Foundation
import SwiftData

@Model
class Recipe {
    @Attribute(.unique) var uuid: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var cuisine: Cuisine
    var photo_url_small: URL?
    var photo_url_large: URL?
    var source_url: URL?
    var youtube_url: URL?
    
    init(
        uuid: UUID,
        name: String,
        cuisine: Cuisine,
        photo_url_small: URL? = nil,
        photo_url_large: URL? = nil,
        source_url: URL? = nil,
        youtube_url: URL? = nil
    ) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photo_url_small = photo_url_small
        self.photo_url_large = photo_url_large
        self.source_url = source_url
        self.youtube_url = youtube_url
    }
}

#if DEBUG
extension Recipe {
    static let sampleList: [Recipe] = [
        .init(
            uuid: UUID(),
            name: "Recipe #1",
            cuisine: .init(name: "Cuisine 1"),
            photo_url_small: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg")!,
            photo_url_large: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg")!
        ),
        .init(
            uuid: UUID(),
            name: "Recipe #2",
            cuisine: .init(name: "Cuisine 1"),
            photo_url_small: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")!
        )
    ]
}
#endif
