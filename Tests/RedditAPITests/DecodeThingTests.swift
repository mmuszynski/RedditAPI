//
//  ListingDecodeTests.swift
//
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest
@testable import RedditAPI

final class DecodeThingTests: XCTestCase, JSONBasedTestCase {
    
    func testLinkThing() throws {
        try withJSON(named: "t3_link") { data in
            let decoder = JSONDecoder()
            XCTAssertNoThrow(try decoder.decode(Thing.self, from: data))
        }
    }
    
}
