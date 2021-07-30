//
//  File.swift
//  
//
//  Created by Mike Muszynski on 7/6/21.
//

import Foundation
import AppKit

/// The data contained in the `Listing`
internal struct ListingData: Decodable {
    typealias Element = Thing
    
    /// A token that is used to help prevent CSRF
    var modhash: String
    
    /// The number of items returned, often different than the limit provided
    var dist: Int?
    
    /// The fullname of the `Thing` that is used to provide the next `Listing` page
    var after: String?
    
    /// The fullname of the `Thing` that is used to provide the previous `Listing` page
    var before: String?
    
    /// The `Thing`s which are contained in the `Listing`,
    var children: [AnyThing]
    
    enum CodingKeys: CodingKey {
        case modhash
        case dist
        case after
        case before
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.modhash = try container.decode(.modhash)
        self.dist = try container.decodeIfPresent(.dist)
        self.after = try container.decodeIfPresent(.after)
        self.before = try container.decodeIfPresent(.before)
        
        self.children = try container.decode(.children)
    }
}
