//
//  Item.swift
//  ForkYeah
//
//  Created by Farshad Sheykhi on 6/3/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
