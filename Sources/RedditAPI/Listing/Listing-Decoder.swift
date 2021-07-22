//
//  File.swift
//  
//
//  Created by Mike Muszynski on 7/6/21.
//

import Foundation

extension Listing {
    public enum DecodeError: Error {
        case unknown
        case multiple(_ errors: [Error])
    }
    
    /// Decodes a `Listing` from a reddit JSON endpoint
    /// - Parameter data: JSON data representing a Reddit `Listing`
    /// - Throws: `DecodeError` if any issues arise, including `DecodeError.multiple` if more than one decoding error occurs
    /// - Returns: `Array<Listing>`
    ///
    /// Normally, a `Listing` returned from the API consists of a JSON dictionary, but in some cases (such as a gallery link), the data returned is an `Array<Listing>`. To accommodate both of these possibilities, this method returns an `Array`, even if there is only one value expected.
    public static func decoded(from data: Data, debug: Bool = false) throws -> Array<Listing> {
        if debug {
            print(String(bytes: data, encoding: .utf8) ?? "")
        }
        
        var errors: [Error] = []
        
        //Try to decode a listing and return it in an array
        do {
            return try [JSONDecoder().decode(Listing.self, from: data)]
        } catch DecodingError.typeMismatch(let type, let context) {
            if !context.codingPath.isEmpty {
                throw DecodingError.typeMismatch(type, context)
            }
        } catch {
            errors.append(error)
        }
        
        //Try to decode the array itself
        do {
            return try JSONDecoder().decode(Array<Listing>.self, from: data)
        } catch {
            if !errors.contains(where: { oldError in
                return oldError.localizedDescription == error.localizedDescription
            }) {
                errors.append(error)
            }
        }
        
        //Throw errors if we get here
        //Can a single error even be thrown? Who knows.
        if errors.isEmpty {
            throw DecodeError.unknown
        } else if errors.count == 1 {
            throw errors.first!
        } else {
            throw DecodeError.multiple(errors)
        }
    }
}
