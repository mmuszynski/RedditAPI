//
//  ListingDecodeTests.swift
//
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest
import Combine
@testable import RedditAPI

final class ListingPublisherTests: AsynchronousTestCase {
    
    /// Uses the `ListingPublisher` to load data from a Subreddit
    func testSubredditPublisher() {
        testAsynchronously(timeout: 10) { hold in
            do {
                try ListingPublisher(forSubreddit: "hockey")
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            XCTFail("Unexpected error: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { (array) in
                        XCTAssertEqual(array.count, 1)
                        hold.fulfill()
                    })
                    .store(in: &cancellables)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    /// Uses the `ListingPublisher` to load data from a User
    func testUserPublisher() {
        testAsynchronously(timeout: 10) { hold in
            do {
                try ListingPublisher(forUser: "mmuszynski-ios")
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            XCTFail("Unexpected error: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { (array) in
                        XCTAssertEqual(array.count, 1)
                        hold.fulfill()
                    })
                    .store(in: &cancellables)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    
    /// Uses the `ListingPublisher` to load data from a User post
    /// This returns the first post from a the subreddit for user mmuszynski-ios
    /// The post consists of the actual post and the comments, which results in an array of two Listings
    ///
    /// Test flow:
    /// Get posts for user mmuszynski-ios
    /// Flat map to the first child of the listing
    func testPermalinkPublisher() {
        testAsynchronously(timeout: 10) { hold in
            do {
                try ListingPublisher(forUser: "mmuszynski-ios")
                    .flatMap({ (array) -> ListingPublisher in
                        let url = array.first![0].permalink!
                        return ListingPublisher(url: url)
                    })
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            XCTFail("Unexpected error: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { (array) in
                        XCTAssertEqual(array.count, 2)
                        hold.fulfill()
                    })
                    .store(in: &cancellables)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
}
