//
//  File.swift
//  
//
//  Created by Mike Muszynski on 7/6/21.
//

import Foundation
import XCTest
@testable import RedditAPI

@available(macOS 12.0, *)
open class AsyncAwaitTests: XCTestCase {
    func testAsynchronousListing() async {
        do {
            let _ = try await Listing.retrieve(from: RedditAPI.jsonURL(forUser: "mmuszynski-ios"), debug: true)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
