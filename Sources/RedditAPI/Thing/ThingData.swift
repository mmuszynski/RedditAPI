//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/16/21.
//

import Foundation

fileprivate extension KeyedDecodingContainer {
    private struct EmptyObject: Decodable {}
    
    func decodeIfPresent<T: Decodable>(_ key: K) throws -> T? {
        return try self.decodeIfPresent(T.self, forKey: key)
    }
    
    func decode<T: Decodable>(_ key: K) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    func decodePossibleEmptyObject<T: Decodable>(_ key: K) throws -> T? {        
        return try? self.decode(T.self, forKey: key)
    }
}

struct ThingData: Codable {

    var all_awardings: [Award]
    var allow_live_comments: Bool?
    var approved_at_utc: Double?
    var approved_by: String?
    var archived: Bool
    var author: String
    var author_flair_background_color: String?
    var author_flair_css_class: String?
    var author_flair_richtext: [RichText]?
    var author_flair_template_id: String?
    var author_flair_text: String?
    var author_flair_text_color: String?
    var author_flair_type: String
    var author_fullname: String
    var author_patreon_flair: Bool
    var author_premium: Bool
    //var awarders: []
    var banned_at_utc: Date?
    var banned_by: String?
    var can_gild: Bool
    var can_mod_post: Bool
    var category: String?
    var clicked: Bool?
    //var content_categories: null
    var contest_mode: Bool?
    var created: Date
    var created_utc: Date
    //var discussion_type: null
    //var distinguished: null
    var domain: String?
    var downs: Int
    var edited: Date?
    var gilded: Int
    var gildings: [String: Int]?
    var hidden: Bool?
    var hide_score: Bool?
    var id: String
    var is_crosspostable: Bool?
    var is_gallery: Bool?
    var is_meta: Bool?
    var is_original_content: Bool?
    var is_reddit_media_domain: Bool?
    var is_robot_indexable: Bool?
    var is_self: Bool?
    var is_video: Bool?
    var likes: Int?
    var link_flair_background_color: String?
    var link_flair_css_class: String?
    var link_flair_richtext: [RichText]?
    var link_flair_text: String?
    var link_flair_text_color: String?
    var link_flair_type: String?
    var locked: Bool
    var media_embed: MediaEmbed?
    var media_metadata: [String: MediaMetadata]?
    var media_only: Bool?
    var mod_note: String?
    //var mod_reason_by: null
    var mod_reason_title: String?
    //var mod_reports: ModReport
    var name: String
    var no_follow: Bool
    var num_comments: Int?
    var num_crossposts: Int?
    var num_duplicates: Int?
    var num_reports: Int?
    var over_18: Bool?
    var parent_whitelist_status: String?
    var permalink: String
    var pinned: Bool?
    var pwls: Int?
    var quarantine: Bool?
    //var removal_reason: null
    //var removed_by: null
    //var removed_by_category: null
    //var report_reasons: null
    var saved: Bool
    var score: Int
    var secure_media: SecureMedia?
    var secure_media_embed: SecureMediaEmbed?
    var selftext: String?
    var selftext_html: String?
    var send_replies: Bool
    var spoiler: Bool?
    var stickied: Bool
    var subreddit: String?
    var subreddit_id: String
    var subreddit_name_prefixed: String
    var subreddit_subscribers: Int?
    var subreddit_type: String
    var suggested_sort: String?
    var thumbnail: String?
    var thumbnail_height: Int?
    var thumbnail_width: Int?
    var title: String?
    var top_awarded_type: String?
    var total_awards_received: Int
    //var treatment_tags: []
    var ups: Int
    var upvote_ratio: Double?
    var url: String?
    //var user_reports: UserReport?
    var view_count: Int?
    var visited: Bool?
    //var whitelist_status: null
    var wls: Int?

    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.allow_live_comments = try container.decodeIfPresent(.allow_live_comments)
        self.approved_at_utc = try container.decode(.approved_at_utc)
        self.approved_by = try container.decode(.approved_by)
        self.archived = try container.decode(.archived)
        self.author = try container.decode(.author)
        self.author_flair_background_color = try container.decode(.author_flair_background_color)
        self.author_flair_css_class = try container.decode(.author_flair_css_class)
        self.author_flair_template_id = try container.decodeIfPresent(.author_flair_template_id)
        self.author_flair_type = try container.decode(.author_flair_type)
        self.author_fullname = try container.decode(.author_fullname)
        self.author_patreon_flair = try container.decode(.author_patreon_flair)
        self.author_premium = try container.decode(.author_premium)
        self.all_awardings = try container.decode(.all_awardings)
        self.banned_at_utc = try container.decodeIfPresent(.banned_at_utc)
        self.can_gild = try container.decode(.can_gild)
        self.can_mod_post = try container.decode(.can_mod_post)
        self.category = try container.decodeIfPresent(.category)
        self.clicked = try container.decodeIfPresent(.clicked)
        self.contest_mode = try container.decodeIfPresent(.contest_mode)
        self.created = try container.decode(.created)
        self.created_utc = try container.decode(.created_utc)
        self.domain = try container.decodeIfPresent(.domain)
        self.downs = try container.decode(.downs)
        self.gilded = try container.decode(.gilded)
        self.gildings = try container.decode(.gildings)
        self.hidden = try container.decodeIfPresent(.hidden)
        self.hide_score = try container.decodeIfPresent(.hide_score)
        self.id = try container.decode(.id)
        self.is_crosspostable = try container.decodeIfPresent(.is_crosspostable)
        self.is_gallery = try container.decodeIfPresent(.is_gallery)
        self.is_meta = try container.decodeIfPresent(.is_meta)
        self.is_original_content = try container.decodeIfPresent(.is_original_content)
        self.is_reddit_media_domain = try container.decodeIfPresent(.is_reddit_media_domain)
        self.is_robot_indexable = try container.decodeIfPresent(.is_robot_indexable)
        self.is_self = try container.decodeIfPresent(.is_self)
        self.is_video = try container.decodeIfPresent(.is_video)
        self.likes = try container.decode(.likes)
        self.link_flair_background_color = try container.decodeIfPresent(.link_flair_background_color)
        self.link_flair_css_class = try container.decodeIfPresent(.link_flair_css_class)
        self.link_flair_richtext = try container.decodeIfPresent(.link_flair_richtext)
        self.link_flair_text = try container.decodeIfPresent(.link_flair_text)
        self.link_flair_text_color = try container.decodeIfPresent(.link_flair_text_color)
        self.link_flair_type = try container.decodeIfPresent(.link_flair_type)
        self.locked = try container.decode(.locked)
        self.media_embed = try container.decodePossibleEmptyObject(.media_embed)
        self.media_metadata = try container.decodeIfPresent(.media_metadata)
        self.media_only = try container.decodeIfPresent(.media_only)
        self.mod_note = try container.decode(.mod_note)
        self.mod_reason_title = try container.decode(.mod_reason_title)
        self.name = try container.decode(.name)
        self.no_follow = try container.decode(.no_follow)
        self.num_comments = try container.decodeIfPresent(.num_comments)
        self.num_crossposts = try container.decodeIfPresent(.num_crossposts)
        self.num_duplicates = try container.decodeIfPresent(.num_duplicates)
        self.over_18 = try container.decodeIfPresent(.over_18)
        self.parent_whitelist_status = try container.decodeIfPresent(.parent_whitelist_status)
        self.permalink = try container.decode(.permalink)
        self.pinned = try container.decodeIfPresent(.pinned)
        self.pwls = try container.decodeIfPresent(.pwls)
        self.quarantine = try container.decodeIfPresent(.quarantine)
        self.saved = try container.decode(.saved)
        self.score = try container.decode(.score)
        self.secure_media = try container.decodeIfPresent(.secure_media)
        self.secure_media_embed = try container.decodePossibleEmptyObject(.secure_media_embed)
        self.selftext = try container.decodeIfPresent(.selftext)
        self.selftext_html = try container.decodeIfPresent(.selftext_html)
        self.send_replies = try container.decode(.send_replies)
        self.spoiler = try container.decodeIfPresent(.spoiler)
        self.stickied = try container.decode(.stickied)
        self.subreddit = try container.decode(.subreddit)
        self.subreddit_id = try container.decode(.subreddit_id)
        self.subreddit_name_prefixed = try container.decode(.subreddit_name_prefixed)
        self.subreddit_subscribers = try container.decodeIfPresent(.subreddit_subscribers)
        self.subreddit_type = try container.decode(.subreddit_type)
        self.suggested_sort = try container.decodeIfPresent(.suggested_sort)
        self.thumbnail = try container.decodeIfPresent(.thumbnail)
        self.thumbnail_height = try container.decodeIfPresent(.thumbnail_height)
        self.thumbnail_width = try container.decodeIfPresent(.thumbnail_width)
        self.title = try container.decodeIfPresent(.title)
        self.top_awarded_type = try container.decode(.top_awarded_type)
        self.total_awards_received = try container.decode(.total_awards_received)
        self.ups = try container.decode(.ups)
        self.upvote_ratio = try container.decodeIfPresent(.upvote_ratio)
        self.url = try container.decodeIfPresent(.url)
        //self.user_reports = try container.decode(.user_reports)
        self.visited = try container.decodeIfPresent(.visited)
        self.wls = try container.decodeIfPresent(.wls)

        //All this work just for this
        //Sometimes this is a bool that says false
        //Other times, it is a number representing a date
        do {
            if let date: Date = try container.decode(.edited) {
                self.edited = date
            }
        } catch {
            self.edited = nil
        }
    }
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

struct RedditVideo: Codable {
    var bitrate_kbps: Int
    var fallback_url: String
    var height: Int
    var width: Int
    var scrubber_media_url: String
    var dash_url: String
    var duration: Int
    var hls_url: String
    var is_gif: Bool
    var transcoding_status: String
}

struct Media: Codable {
    var type: String
    var oembed: MediaEmbed
}

struct MediaEmbed: Codable {
    var provider_url: String
    var version: String
    var title: String
    var type: String
    var thumbnail_width: Int
    var height: Int
    var width: Int
    var html: String
    var author_name: String
    var provider_name: String
    var thumbnail_url: String
    var thumbnail_height: Int
    var author_url: String
}

struct RichText: Codable {
    var e: String
    var t: String
}
