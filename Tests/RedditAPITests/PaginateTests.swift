//
//  File.swift
//  
//
//  Created by Mike Muszynski on 6/27/21.
//

import XCTest
import Combine
@testable import RedditAPI

final class PaginateTests: AsynchronousTestCase {
    
    func testPagination() {
        testAsynchronously(timeout: 20) { wait in
            try! RedditListingPublisher(forSubreddit: "hockey", batch: 50, mode: .new, modeLimit: .all)
                .paginate(strategy: { listing in
                    guard let last = listing.last?.url,
                          let url = listing.last?.nextURL(after: last) else {
                              return nil
                        }
                    print(url)
                    return RedditListingPublisher(url: url)
                })
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTFail("\(error)")
                    case .finished:
                        break
                    }
                    wait.fulfill()
                }, receiveValue: { listing in
                    print(listing.first?.url as Any)
                })
                .store(in: &cancellables)
            }
        }
    
}
