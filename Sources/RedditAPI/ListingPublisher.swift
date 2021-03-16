//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import Foundation
import Combine

/// A one-shot `Publisher` that returns a reddit `Listing`.
struct ListingPublisher: Publisher {
    typealias Output = Listing
    typealias Failure = Error
    
    let upstreamPublisher: AnyPublisher<Listing, Error>
    init(url: URL) {
        upstreamPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Listing.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        upstreamPublisher.subscribe(subscriber)
    }
}
