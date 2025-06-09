
import XCTest
import SwiftUI
@testable import ForkYeah

@MainActor
final class CacheServiceTests: XCTestCase {
    var subject: CacheService!
    
    override func setUp() {
        super.setUp()
        subject = CacheService()
    }
    
    override func tearDown() {
        subject.clear()
        subject = nil
        super.tearDown()
    }
    
    func testInsertAndRetrieveImageFromMemoryCache() {
        let url = URL(string: "https://test.com/test_image1.png")!
        let starData = UIImage(systemName: "star")!.pngData()!
        subject.insertImage(data: starData, for: url)
        
        let image = subject.image(for: url)
        XCTAssertNotNil(image, "Image should be retrieved after being inserted into memory cache")
    }
    
    func testClearRemovesImages() {
        let url = URL(string: "https://test.com/test_image2.png")!
        let heartData = UIImage(systemName: "heart")!.pngData()!
        subject.insertImage(data: heartData, for: url)
        subject.clear()
        
        let image = subject.image(for: url)
        XCTAssertNil(image, "Image should be nil after cache is cleared")
    }
    
    func testImagePersistsToDiskCache() {
        let url = URL(string: "https://test.com/test_image3.png")!
        let moonData = UIImage(systemName: "moon")!.pngData()!
        subject.insertImage(data: moonData, for: url)
        
        subject.memoryCache.removeAllObjects()
        
        let image = subject.image(for: url)
        XCTAssertNotNil(image, "Image should load from disk if not in memory")
    }
    
    func testImageExpiration() {
        let url = URL(string: "https://test.com/test_image4.png")!
        let dummyData = UIImage(systemName: "sun.max")!.pngData()!
        let expiredEntry = ImageCacheEntry(image: Image(uiImage: UIImage(data: dummyData)!), timestamp: Date(timeIntervalSinceNow: -7200))
        
        subject.memoryCache.setObject(expiredEntry, forKey: url as NSURL)
        let image = subject.image(for: url)
        XCTAssertNil(image, "Image should be nil if cache entry is expired")
    }
}

