//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import Foundation
import Combine
import os

fileprivate var logger = Logger(subsystem: "com.mmuszynski.redditapi", category: "ListingPublsiher")

/// A one-shot `Publisher` that returns an array of reddit `Listing` objects.
public struct RedditListingPublisher: Publisher {
    public typealias Output = Array<Listing>
    public typealias Failure = Error
    
    let upstreamPublisher: AnyPublisher<Output, Error>
    public init(url: URL, debug: Bool = false) {
        upstreamPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                if debug {
                    logger.trace("Decoding listing for \(url)")
                }
                
                do {
                    let listings = try Listing.decoded(from: data, debug: debug)
                    
                    return listings.map { listing in
                        var listing = listing
                        listing.url = url
                        return listing
                    }
                } catch {
                    if debug {
                        logger.critical("Error in \(url): \(error.localizedDescription)")
                        logger.critical("\(String(bytes: data, encoding: .utf8) ?? "Unknown Data")")
                        try! data.write(to: URL(fileURLWithPath: "/Users/mike/Desktop/errorData.json"))
                    }
                    
                    throw error
                }
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
    public init(forSubreddit subredditName: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all, debug: Bool = false) throws {
        let url = try RedditAPI.jsonURL(forSubreddit: subredditName, batch: batch, mode: mode, modeLimit: modeLimit)
        self.init(url: url, debug: debug)
    }
}

/// User version
extension RedditListingPublisher {
    /// Initializes a `RedditListingPublisher` instance suitable for
    public init(forUser username: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all, debug: Bool = false) throws {
        let url = try RedditAPI.jsonURL(forUser: username, batch: batch, mode: mode, modeLimit: modeLimit)
        self.init(url: url, debug: debug)
    }
}
