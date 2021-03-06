//
//  Post.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

public struct Thing: Codable {
    public enum ThingType: String, Codable {
        case comment = "t1"
        case account = "t2"
        case link = "t3"
        case message = "t4"
        case subreddit = "t5"
        case award = "t6"
        case unknown = "??"
    }
    
    internal var data: ThingData

    public var kind: String
    public var type: ThingType { ThingType(string: kind) }
    
    public var url: URL? {
        guard let url = self.data.url else { return nil }
        return URL(string: url)
    }
    public var name: String {
        return data.name
    }
    public var author: String {
        return data.author
    }
    public var permalink: URL? {
        let path = data.permalink
        guard path != "" else { return nil }
        return RedditAPI.jsonUrl(fromPermalink: path)
    }
        
    var galleryImageURLs: [URL] {
        guard self.data.is_gallery == true else { return [] }
        return self.data.media_metadata?.values.compactMap ({ (metadata) -> URL? in
            if let urlString = metadata.s?.u?.replacingOccurrences(of: "&amp;", with: "&") {
                return URL(string: urlString)
            } else if let urlString = metadata.s?.mp4?.replacingOccurrences(of: "&amp;", with: "&") {
                return URL(string: urlString)
            } else if let urlString = metadata.s?.gif?.replacingOccurrences(of: "&amp;", with: "&") {
                return URL(string: urlString)
            }
            return nil
        }) ?? []
    }
}
