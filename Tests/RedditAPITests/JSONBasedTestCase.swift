//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest

protocol JSONBasedTestCase {
    func urlForJSONResource(named name: String) -> URL?
}

extension JSONBasedTestCase {
    func urlForJSONResource(named name: String) -> URL? {
        Bundle.module.url(forResource: name, withExtension: "json")
    }
}
