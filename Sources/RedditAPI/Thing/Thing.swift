//
//  Post.swift
//  ImageHasFace
//
//  Created by Mike Muszynski on 7/22/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

public protocol Thing: Decodable {
    associatedtype Kind
}

extension Thing {
    public typealias Kind = Self
}

private class _AnyThingBase<T>: Thing {
    typealias Kind = T
}

private class _AnyThingBox<Concrete: Thing>: _AnyThingBase<Concrete.Kind> {
    let _concrete: Concrete
    init(_ concrete: Concrete) {
        self._concrete = concrete
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

public struct AnyThing: Thing {
    public typealias Kind = Any
    private let _box: _AnyThingBase<Kind>
    
    public init<Concrete: Thing>(_ concrete: Concrete) {
        self._box = _AnyThingBox(concrete)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let comment = try? container.decode(Comment.self) {
            self.init(comment)
        }
        fatalError()
    }
}
