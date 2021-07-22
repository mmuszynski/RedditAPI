//
//  File.swift
//  
//
//  Created by Mike Muszynski on 7/6/21.
//

import Foundation

internal extension Data {
    var utfString: String? {
        return String(bytes: self, encoding: .utf8)
    }
}

@available(macOS 12.0, *)
extension Listing {
    public static func retrieve(from url: URL, debug: Bool = false) async throws -> [Listing] {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError()
        }
        do {
            return try Listing.decoded(from: data)
        } catch {
            if debug {
                print(url)
                print(data.utfString ?? "Unrecognized data")
            }
            throw error
        }
    }
}
