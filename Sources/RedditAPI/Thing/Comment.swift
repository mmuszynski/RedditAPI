//
//  File.swift
//  File
//
//  Created by Mike Muszynski on 7/26/21.
//

import Foundation

public struct Comment: Thing {
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
    
    public var videoURL: URL? {
        if let urlString = data.secure_media?.oembed.fallback_url { return URL(string: urlString) }
        if let urlString = data.reddit_video?.fallback_url { return URL(string: urlString)}
        return nil
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
