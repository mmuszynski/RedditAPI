//
//  Listing.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

public struct Listing: Codable {
    public typealias Element = Thing
        
    public var kind: String
    private var data: ListingData
    
    public var galleryImageURLs: [URL] {
        var urls = [URL]()
        for thing in self {
            urls.append(contentsOf: thing.galleryImageURLs)
        }
        return urls
    }
    
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

extension Listing: RandomAccessCollection {
    public typealias Index = Array<Element>.Index

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

struct ListingData: Codable {
    typealias Element = Thing
    
    var modhash: String
    var dist: Int?
    var after: String?
    var before: String?
    var children: [Element]
}

extension Array where Element == Listing {
    public var galleryImageURLs: [URL] {
        self.reduce([]) { (urls, listing) -> [URL] in
            return urls + listing.galleryImageURLs
        }
    }
}

extension Listing {
    public enum DecodeError: Error {
        case unknown
        case multiple(_ errors: [Error])
    }
    
    /// Decodes a `Listing` from a reddit JSON endpoint
    /// - Parameter data: JSON data representing a Reddit `Listing`
    /// - Throws: `DecodeError` if any issues arise, including `DecodeError.multiple` if more than one decoding error occurs
    /// - Returns: `Array<Listing>`
    ///
    /// Normally, a `Listing` returned from the API consists of a JSON dictionary, but in some cases (such as a gallery link), the data returned is an `Array<Listing>`. To accommodate both of these possibilities, this method returns an `Array`, even if there is only one value expected.
    public static func decode(from data: Data) throws -> Array<Listing> {
        var errors: [Error] = []
        
        //Try to decode a listing and return it in an array
        do {
            return try [JSONDecoder().decode(Listing.self, from: data)]
        } catch {
            errors.append(error)
        }
        
        //Try to decode the array itself
        do {
            return try JSONDecoder().decode(Array<Listing>.self, from: data)
        } catch {
            errors.append(error)
        }
        
        //Throw errors if we get here
        //Can a single error even be thrown? Who knows.
        if errors.isEmpty {
            throw DecodeError.unknown
        } else if errors.count == 1 {
            throw errors.first!
        } else {
            throw DecodeError.multiple(errors)
        }
    }
}
