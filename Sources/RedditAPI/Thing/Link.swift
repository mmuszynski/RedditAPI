//
//  File.swift
//  File
//
//  Created by Mike Muszynski on 8/4/21.
//

import Foundation

struct Link: Thing {
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
}
