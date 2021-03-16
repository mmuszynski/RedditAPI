//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest
@testable import RedditAPI

final class URLGenerationTests: XCTestCase {
    func testURLGenerator() {
        //subreddits
        XCTAssertEqual(try RedditAPI.jsonURL(forSubreddit: "hockey").absoluteString,
                       "https://www.reddit.com/r/hockey.json")
        XCTAssertEqual(try RedditAPI.jsonURL(forSubreddit: "hockey", mode: .controversial, modeLimit: .day).absoluteString,
                       "https://www.reddit.com/r/hockey/controversial.json?t=day")
        XCTAssertEqual(try RedditAPI.jsonURL(forSubreddit: "hockey", batch: 50, mode: .hot, modeLimit: .day).absoluteString,
                       "https://www.reddit.com/r/hockey.json?limit=50")
        XCTAssertEqual(try RedditAPI.jsonURL(forSubreddit: "hockey", batch: 20, mode: .controversial, modeLimit: .day).absoluteString,
                       "https://www.reddit.com/r/hockey/controversial.json?t=day&limit=20")
        XCTAssertEqual(try RedditAPI.jsonURL(forSubreddit: "hockey", batch: 1000, mode: .hot).absoluteString,
                       "https://www.reddit.com/r/hockey.json?limit=1000")
        
        //usernames
        XCTAssertEqual(try RedditAPI.url(forUser: "bob").jsonURL.absoluteString,
                       "https://www.reddit.com/user/bob.json")
        
    }
}
