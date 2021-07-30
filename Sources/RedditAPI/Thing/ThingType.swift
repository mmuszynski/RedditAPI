//
//  RedditType.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

public enum ThingType: String, Codable {
    case comment = "t1"
    case account = "t2"
    case link = "t3"
    case message = "t4"
    case subreddit = "t5"
    case award = "t6"
    case unknown = "??"
    case more = "more"
}

extension ThingType {
    init(string: String) {
        let first = string.components(separatedBy: "_")[0]
        if let type = ThingType(rawValue: first) {
            self = type
        } else {
            self = .unknown
        }
    }
}
