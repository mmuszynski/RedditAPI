//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/19/21.
//

import Foundation

extension ThingData {
    struct SecureMedia: Codable {
        var type: String
        var oembed: SecureMediaOembed
    }
    
    struct SecureMediaOembed: Codable {
        var provider_url: String
        var url: String?
        var html: String
        var author_name: String?
        var height: Int?
        var width: Int?
        var version: String
        var author_url: String?
        var provider_name: String
        var cache_age: Int?
        var type: String
    }
    
    struct SecureMediaEmbed: Codable {
        var content: String
        var width: Int
        var scrolling: Bool
        var media_domain_url: String
        var height: Int
    }
}
