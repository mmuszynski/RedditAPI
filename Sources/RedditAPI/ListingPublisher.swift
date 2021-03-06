//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import Foundation
import Combine

/// A one-shot `Publisher` that returns a reddit `Listing`.
public struct RedditListingPublisher: Publisher {
    public typealias Output = Array<Listing>
    public typealias Failure = Error
    
    let upstreamPublisher: AnyPublisher<Output, Error>
    public init(url: URL) {
        upstreamPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                try Listing.decoded(from: data)
            }
            .eraseToAnyPublisher()
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        upstreamPublisher.subscribe(subscriber)
    }
}

/// Subreddit version
extension RedditListingPublisher {
    /// Initializes a `RedditListingPublisher` instance suitable for
    public init(forSubreddit subredditName: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws {
        let url = try RedditAPI.jsonURL(forSubreddit: subredditName, batch: batch, mode: mode, modeLimit: modeLimit)
        self.init(url: url)
    }
}

/// User version
extension RedditListingPublisher {
    /// Initializes a `RedditListingPublisher` instance suitable for
    public init(forUser username: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws {
        let url = try RedditAPI.jsonURL(forUser: username, batch: batch, mode: mode, modeLimit: modeLimit)
        self.init(url: url)
    }
}
