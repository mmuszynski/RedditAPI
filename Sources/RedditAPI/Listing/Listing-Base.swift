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
public struct Listing: Decodable {
    
    /// A string the represents the kind of data returned by the API.
    ///
    /// - note: For `Listing` objects, this should return "Listing"
    public var kind: String
    
    /// The various data elements returned by the `Listing` JSON
    internal var data: ListingData
    
    public var things: [AnyThing] { self.data.children }
    
    /// The `URL` used to make the request for this `RedditListing`.
    public var url: URL?
    
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
    public func nextURL(after current: URL? = nil) -> URL? {
        let current = current ?? self.url
        guard current != nil, let after = data.after, var components = URLComponents(string: current!.absoluteString) else {
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
