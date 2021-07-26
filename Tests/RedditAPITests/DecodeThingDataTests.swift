//
//  ListingDecodeTests.swift
//
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest
@testable import RedditAPI

final class DecodeThingDataTests: XCTestCase, JSONBasedTestCase {
    
    func testBasicLinkDataFromt1() throws {
        try withJSON(named: "t1_reply_data") { data in
            let decoder = JSONDecoder()
            XCTAssertNoThrow(try decoder.decode(ThingData.self, from: data))
        }
    }
    
    func testBasicLinkDataFromt1_2() throws {
        try withJSON(named: "t1_reply_data2") { data in
            let decoder = JSONDecoder()
            XCTAssertNoThrow(try decoder.decode(ThingData.self, from: data))
        }
    }
    
    func testBasicLinkDataFromt3() throws {
        try withJSON(named: "t3_link_data") { data in
            let decoder = JSONDecoder()
            XCTAssertNoThrow(try decoder.decode(ThingData.self, from: data))
        }
    }
    
}
