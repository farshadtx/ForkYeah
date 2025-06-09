import Foundation
@testable import ForkYeah

final class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    
    func fetch<T>(_ type: T.Type, from url: URL) async throws -> T where T : Decodable {
        let data = mockData ?? Data()
        return try JSONDecoder().decode(T.self, from: data)
    }
}
