import Combine
import SwiftUI

@MainActor
final class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @AppStorage(SettingsKeys.selectedEndpoint) private var selectedEndpoint: String = Endpoint.defaultValue.rawValue
    let cacheResetRequested = PassthroughSubject<Void, Never>()
    
    var endpoint: Endpoint {
        get { Endpoint(rawValue: selectedEndpoint) ?? .defaultValue }
        set { selectedEndpoint = newValue.rawValue }
    }
    
    func resetCache() {
        cacheResetRequested.send()
    }
}
