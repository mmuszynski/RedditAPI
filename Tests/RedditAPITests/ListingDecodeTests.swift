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
    func testSubredditDecode() {
        do {
            let dataURL = urlForJSONResource(named: "hockey_new")!
            let data = try Data(contentsOf: dataURL)
            
            do {
                let listing = try JSONDecoder().decode(Listing.self, from: data)
                
                //Test for secure_media_embed
                //This value is returned as an empty object (e.g. {})
                //This empty object is mapped to nil
                XCTAssertNil(listing.first?.data.secure_media_embed)
                XCTAssertNotNil(listing[1].data.secure_media_embed)
                
            } catch DecodingError.typeMismatch(let theType, let context) {
                XCTFail("\(theType): \(context)")
            } catch DecodingError.keyNotFound(let key, let context) {                print("\(context.codingPath.description)")
                
                let path = context.codingPath.reduce("") { (result, key) -> String in
                    result + key.stringValue + " >> "
                }
                
                print(String(repeating: "=", count: 20))
                print("Key not found in Listing:")
                print(path + key.stringValue)
                print(String(repeating: "=", count: 20))

                XCTFail("\(key): \(context)")
            }
        } catch {
            XCTFail("unexpected error: \(error)")
        }
    }
    
    func testDecodeWithMedia() {
        do {
            let dataURL = urlForJSONResource(named: "videos_new_limit_3")!
            let data = try Data(contentsOf: dataURL)
            XCTAssertNoThrow(try Listing.decoded(from: data))
        } catch {
            XCTFail("unexpected error: \(error)")
        }
    }
    
    /// Tests the decoding of a Text Post with comments
    func testTextPostWithComments() {
        do {
            let dataURL = urlForJSONResource(named: "textPostWithComments")!
            let data = try Data(contentsOf: dataURL)
            XCTAssertNoThrow(try Listing.decoded(from: data))
        } catch {
            XCTFail("unexpected error: \(error)")
        }
    }
    
    func testAwarding() {
        let data = try! Data(contentsOf: urlForJSONResource(named: "AwardObject")!)
        XCTAssertNoThrow(try JSONDecoder().decode(ThingData.Award.self, from: data))
    }
    
    func testError20210705() {
        let data = try! Data(contentsOf: urlForJSONResource(named: "HockeyError20210705")!)
        XCTAssertNoThrow(try JSONDecoder().decode(Listing.self, from: data))
    }
    
    func testTiersByRequiredAwardingsFailure() {
        let data = try! Data(contentsOf: urlForJSONResource(named: "tiers_by_required_awardings_failure")!)
        XCTAssertNoThrow(try JSONDecoder().decode(Listing.self, from: data))
    }
    
    func testHasVideoLinks() throws {
        try withJSON(named: "the_end_do_be_near") { data in
            let listing = try Listing.decoded(from: data)
            XCTAssertNotNil(listing.first?.things.first?.data.secure_media?.first)
            print(listing.first?.things.first?.videoURL)
        }
    }
}
