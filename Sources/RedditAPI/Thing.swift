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
    
    private var data: ThingData

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

struct ThingData: Codable {
    var url: String?
    var author: String
    var name: String
    var permalink: String
    var subreddit: String?
    var is_gallery: Bool?
    var title: String?
    var subreddit_name_prefixed: String?
    var media_metadata: [String: MediaMetadata]?
}

struct MediaMetadata: Codable {
    var status: String
    var e: String?
    var m: String?
    var o: [ImageMetadata]?
    var p: [ImageMetadata]?
    var s: ImageMetadata?
}

struct ImageMetadata: Codable {
    var y: Int
    var x: Int
    var u: String?
    var gif: String?
    var mp4: String?
}
