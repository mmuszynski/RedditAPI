//
//  File.swift
//  
//
//  Created by Mike Muszynski on 3/15/21.
//

import XCTest

enum JSONBaseTestError: Error {
    case InvalidURL
    case LoadError
}

protocol JSONBasedTestCase {
    func urlForJSONResource(named name: String) -> URL?
}

extension JSONBasedTestCase {
    func urlForJSONResource(named name: String) -> URL? {
        Bundle.module.url(forResource: name, withExtension: "json")
    }
    
    func withJSON(named name: String, _ block: (Data) throws -> Void) throws {
        guard let url = urlForJSONResource(named: name) else { throw JSONBaseTestError.InvalidURL }
        let data = try Data(contentsOf: url)
        do {
            try block(data)
        } catch DecodingError.typeMismatch(let type, let context) {
            var path = ""
            for context in context.codingPath {
                path += " >> " + context.stringValue
            }
            print(String(repeating: "-", count: 25))
            print("DECODING ERROR")
            print("\(type) does not match expected type \(context.codingPath.last?.description ?? "unknown")")
            print(path)
            print(String(repeating: "-", count: 25))
            throw DecodingError.typeMismatch(type, context)
        } catch {
            throw error
        }
    }
}
