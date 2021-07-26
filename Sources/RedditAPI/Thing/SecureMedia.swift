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
        var url: String?
        var maxwidth: Int?
        var maxheight: Int?
        var format: String?
        
        var provider_url: String?
        var html: String?
        var author_name: String?
        var height: Int?
        var width: Int?
        var version: String?
        var author_url: String?
        var provider_name: String?
        var cache_age: Int?
        var type: String?
        
        var bitrate_kbps: Int?
        var fallback_url: String?
        var scrubber_media_url: String?
        var dash_url: String?
        var duration: Int?
        var hls_url: String?
        var is_gif: Bool?
        var transcoding_status: String?
    }
    
    struct SecureMediaEmbed: Codable {
        var content: String
        var width: Int
        var scrolling: Bool
        var media_domain_url: String
        var height: Int
    }
}
