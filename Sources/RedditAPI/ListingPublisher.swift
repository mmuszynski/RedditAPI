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
    typealias Output = Array<Listing>
    typealias Failure = Error
    
    let upstreamPublisher: AnyPublisher<Output, Error>
    init(url: URL) {
        upstreamPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                try Listing.decoded(from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        upstreamPublisher.subscribe(subscriber)
    }
}

/// Subreddit version
extension ListingPublisher {
    /// Initializes a `ListingPublisher` instance suitable for
    init(forSubreddit subredditName: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws {
        let url = try RedditAPI.jsonURL(forSubreddit: subredditName, batch: batch, mode: mode, modeLimit: modeLimit)
        self.init(url: url)
    }
}

/// User version
extension ListingPublisher {
    /// Initializes a `ListingPublisher` instance suitable for
    init(forUser username: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws {
        let url = try RedditAPI.jsonURL(forUser: username, batch: batch, mode: mode, modeLimit: modeLimit)
        self.init(url: url)
    }
}
