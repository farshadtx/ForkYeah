struct RecipesEnvelope: Codable {
    let recipes: [CodableRecipe]
}

struct CodableRecipe: Codable {
    let uuid: String?
    let name: String?
    let cuisine: String?
    let photo_url_small: String?
    let photo_url_large: String?
    let source_url: String?
    let youtube_url: String?

    init(
        uuid: String?,
        name: String?,
        cuisine: String?,
        photo_url_small: String? = nil,
        photo_url_large: String? = nil,
        source_url: String? = nil,
        youtube_url: String? = nil
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
