import SwiftUI

struct CachedImageView<Placeholder: View, ImageContent: View>: View {
    let url: URL?
    let placeholder: () -> Placeholder
    let imageContent: (Image) -> ImageContent

    @State private var loadedImage: Image?

    var body: some View {
        Group {
            if let loadedImage {
                imageContent(loadedImage)
            } else {
                placeholder()
                    .task {
                        await loadImage()
                    }
            }
        }
    }

    private func loadImage() async {
        guard let url else { return }

        if let cached = CacheService.shared.image(for: url) {
            loadedImage = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            CacheService.shared.insertImage(data: data, for: url)
            if let newImage = CacheService.shared.image(for: url) {
                loadedImage = newImage
            }
        } catch {
            print("❌ Failed to load image from \(url):", error)
        }
    }
}
