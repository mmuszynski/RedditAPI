//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/21/21.
//

import Foundation

extension ThingData {
    struct Award: Codable {
        var giver_coin_reward: Int?
        var subreddit_id: String?
        var is_new: Bool
        var days_of_drip_extension: Int
        var coin_price: Int
        var id: String
        var penny_donate: Int?
        var award_sub_type: String
        var coin_reward: Int
        var icon_url: String
        var days_of_premium: Int
        var tiers_by_required_awardings: [String: AwardTier]?
        var resized_icons: [Award.Icon]
        
        struct Icon: Codable {
            var url: String
            var width: Int
            var height: Int
        }
    }
    
    struct AwardTier: Codable {
        var resized_icons: Array<AwardIcon>
        var awardings_required: Int
        var static_icon: AwardIcon
    }
    
    struct AwardIcon: Codable {
        var url: URL
        var width: Int
        var height: Int
    }
}
