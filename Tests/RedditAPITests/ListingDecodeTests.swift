//
//  ListingDecodeTests.swift
//
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest
@testable import RedditAPI

final class ListingDecodeTests: XCTestCase, JSONBasedTestCase {
    
    /// Tests the decoding of a Listing
    /// Uses the subreddit hockey from March 16, 2021
    func testListingDecode() {
        do {
            let dataURL = urlForJSONResource(named: "2021-03-16_hockey")!
            let data = try Data(contentsOf: dataURL)
            XCTAssertNoThrow(try JSONDecoder().decode(Listing.self, from: data))
        } catch {
            XCTFail("unexpected error: \(error)")
        }
    }
}
