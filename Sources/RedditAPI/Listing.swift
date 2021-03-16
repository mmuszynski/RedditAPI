//
//  Listing.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

/// The basic structure returned by Reddit for pagination and filtering.
///
/// Conforms to `Codable` in order to allow for decoding from JSON values returned by the API.
///
/// According to the [Reddit API Documentation](https://www.reddit.com/dev/api/#listings):
///
/// Many endpoints on reddit use the same protocol for controlling pagination and filtering. These endpoints are called Listings and share five common parameters: after / before, limit, count, and show.
///
/// Listings do not use page numbers because their content changes so frequently. Instead, they allow you to view slices of the underlying data. Listing JSON responses contain after and before fields which are equivalent to the "next" and "prev" buttons on the site and in combination with count can be used to page through the listing.
public struct Listing: Codable {
    
    /// A string the represents the kind of data returned by the API.
    ///
    /// - note: For `Listing` objects, this should return "Listing"
    public var kind: String
    
    /// The various data elements returned by the `Listing` JSON
    private var data: ListingData
    
//    public var galleryImageURLs: [URL] {
//        var urls = [URL]()
//        for thing in self {
//            urls.append(contentsOf: thing.galleryImageURLs)
//        }
//        return urls
//    }
  
    /// A URL to provide the "next" slice of content from the API
    ///
    /// Reddit `Listing`s provide a snapshot of the site at an given time. Becuase content changes rapidly, the next slice is calculated from a given `Thing` and link. A current link is required to provide sorting and filtering information (e.g. hot or controversial posts for a given subreddit), and a suitable "next" page is created from the "after" element in the `ListingData`.
    ///
    /// If there is no suitable link after the current slice, this method will return `nil`.
    ///
    /// - Parameter current: The link used to request this `Listing` slice
    /// - Returns: A `URL` that will return a `Listing` representing the next page or `nil` if no such page exists (such as when a subreddit's current posts have been exhasuted)
    public func nextURL(after current: URL) -> URL? {
        guard let after = data.after, var components = URLComponents(string: current.absoluteString) else {
            return nil
        }
        var items = components.queryItems ?? []
        let item = URLQueryItem(name: "after", value: after)
        items.removeAll(where: { item in item.name == "after" })
        items.append(item)
        components.queryItems = items
        return components.url
    }
}

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

/// The data contained in the `Listing`
private struct ListingData: Codable {
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

//extension Array where Element == Listing {
//    public var galleryImageURLs: [URL] {
//        self.reduce([]) { (urls, listing) -> [URL] in
//            return urls + listing.galleryImageURLs
//        }
//    }
//}

//extension Listing {
//    public enum DecodeError: Error {
//        case unknown
//        case multiple(_ errors: [Error])
//    }
//    
//    /// Decodes a `Listing` from a reddit JSON endpoint
//    /// - Parameter data: JSON data representing a Reddit `Listing`
//    /// - Throws: `DecodeError` if any issues arise, including `DecodeError.multiple` if more than one decoding error occurs
//    /// - Returns: `Array<Listing>`
//    ///
//    /// Normally, a `Listing` returned from the API consists of a JSON dictionary, but in some cases (such as a gallery link), the data returned is an `Array<Listing>`. To accommodate both of these possibilities, this method returns an `Array`, even if there is only one value expected.
//    public static func decode(from data: Data) throws -> Array<Listing> {
//        var errors: [Error] = []
//        
//        //Try to decode a listing and return it in an array
//        do {
//            return try [JSONDecoder().decode(Listing.self, from: data)]
//        } catch {
//            errors.append(error)
//        }
//        
//        //Try to decode the array itself
//        do {
//            return try JSONDecoder().decode(Array<Listing>.self, from: data)
//        } catch {
//            errors.append(error)
//        }
//        
//        //Throw errors if we get here
//        //Can a single error even be thrown? Who knows.
//        if errors.isEmpty {
//            throw DecodeError.unknown
//        } else if errors.count == 1 {
//            throw errors.first!
//        } else {
//            throw DecodeError.multiple(errors)
//        }
//    }
//}
