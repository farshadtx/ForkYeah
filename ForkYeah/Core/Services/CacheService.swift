import SwiftUI
import Foundation

@MainActor
protocol CacheServiceProtocol {
    func image(for url: URL) -> Image?
    func insertImage(data: Data, for url: URL)
    func clear()
}

@MainActor
final class CacheService: CacheServiceProtocol {
    static let shared = CacheService()
    
    let memoryCache = NSCache<NSURL, ImageCacheEntry>()
    private let expirationInterval: TimeInterval = 60 * 60
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    
    init() {
        let cachesDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cachesDir.appendingPathComponent("ImageCache")
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    func image(for url: URL) -> Image? {
        if let entry = memoryCache.object(forKey: url as NSURL),
           Date().timeIntervalSince(entry.timestamp) < expirationInterval {
            return entry.image
        }
        
        if let diskImage = loadFromDisk(url: url) {
            memoryCache.setObject(ImageCacheEntry(image: diskImage, timestamp: Date()), forKey: url as NSURL)
            return diskImage
        }
        
        return nil
    }
    
    func insertImage(data: Data, for url: URL) {
        guard let uiImage = UIImage(data: data) else { return }
        let image = Image(uiImage: uiImage)
        
        let entry = ImageCacheEntry(image: image, timestamp: Date())
        memoryCache.setObject(entry, forKey: url as NSURL)
        
        saveToDisk(data: data, for: url)
    }
    
    func clear() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: diskCacheURL)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
}

private extension CacheService {
    func saveToDisk(data: Data, for url: URL) {
        try? data.write(to: fileURL(for: url))
    }
    
    func loadFromDisk(url: URL) -> Image? {
        let fileURL = fileURL(for: url)
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    func fileURL(for url: URL) -> URL {
        let safeFileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? Data(url.absoluteString.utf8).base64EncodedString()
        return diskCacheURL.appendingPathComponent(safeFileName + ".img")
    }
}

final class ImageCacheEntry: NSObject {
    let image: Image
    let timestamp: Date
    
    init(image: Image, timestamp: Date) {
        self.image = image
        self.timestamp = timestamp
    }
}
