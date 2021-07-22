//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest
import Combine

open class AsynchronousTestCase: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    func testAsynchronously(timeout interval: TimeInterval, _ block: (XCTestExpectation)->()) {
        let ex = expectation(description: "Wait for async")
        block(ex)
        wait(for: [ex], timeout: interval)
    }
}
