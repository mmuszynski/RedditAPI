//
//  File.swift
//  
//
//  Created by Mike Muszynski on 7/6/21.
//

import Foundation

/// The data contained in the `Listing`
internal struct ListingData: Codable {
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
    var children: [Element]
}
