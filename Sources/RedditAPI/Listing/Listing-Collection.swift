//
//  File.swift
//  
//
//  Created by Mike Muszynski on 7/6/21.
//

import Foundation

/// Conformance to `RandomAccessCollection`
///
/// Data for the collection is contained in the `ListingData` of the `Listing` object, and these are forwarded to an array that represents the elements of the of the `Collection`.
extension Listing: RandomAccessCollection {
    public typealias Element = Thing
    public typealias Index = Array<Element>.Index

    /// Forwards chiild elements from the `ListingData`
    private var elements: [Element] {
        return self.data.children
    }
    
    public subscript(position: Array<Element>.Index) -> Element {
        return elements[position]
    }
    
    public var startIndex: Array<Element>.Index {
        return elements.startIndex
    }
    
    public var endIndex: Array<Element>.Index {
        return elements.endIndex
    }
}

//extension Array where Element == Listing {
//    public var galleryImageURLs: [URL] {
//        self.reduce([]) { (urls, listing) -> [URL] in
//            return urls + listing.galleryImageURLs
//        }
//    }
//}
