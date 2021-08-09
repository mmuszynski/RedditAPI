//
//  Post.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

public protocol Thing: Decodable {}

public struct AnyThing: Thing {
    var base: Thing
    init<T: Thing>(_ thing: T) {
        self.base = thing
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let comment = try? container.decode(Comment.self) {
            self = AnyThing(comment)
            return
        } else if let link = try? container.decode(Link.self) {
            self = AnyThing(link)
            return
        }
        fatalError()
    }
}
