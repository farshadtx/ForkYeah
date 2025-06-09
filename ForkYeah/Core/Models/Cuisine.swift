import Foundation
import SwiftData

@Model
class Cuisine {
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.name = name
    }
}
