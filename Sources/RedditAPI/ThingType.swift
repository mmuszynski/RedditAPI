//
//  RedditType.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

extension Thing.ThingType {
    init(string: String) {
        let first = string.components(separatedBy: "_")[0]
        if let type = Thing.ThingType(rawValue: first) {
            self = type
        } else {
            self = .unknown
        }
    }
}
