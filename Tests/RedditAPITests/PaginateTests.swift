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
    
    func testSecureMedia() throws {
        testAsynchronously(timeout: 300) { wait in
            let url = URL(string: "https://www.reddit.com/r/gifs/comments/opzh42/what_do_we_say_to_the_god_of_death")!.jsonURL
            var finalURLs = [URL]()
            RedditListingPublisher(url: url, debug: true)
                .paginate(strategy: { listing in
                    let first = listing.first
                    if let next = first?.nextURL() {
                        return RedditListingPublisher(url: next)
                    } else {
                        return nil
                    }
                })
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTFail("\(error)")
                    case .finished:
                        print(finalURLs)
                        break
                    }
                    wait.fulfill()
                }, receiveValue: { listing in
                    let newURLs = listing.reduce(Array<URL>()) { partialResult, nextListing in
                        let urls = nextListing
                            .compactMap { $0 as? Link }
                            .compactMap(\.url)
                        return partialResult + urls
                    }
                    print("Found \(newURLs.count) urls")
                    finalURLs.append(contentsOf: newURLs)
                })
                .store(in: &cancellables)
        }
    }
    
}
