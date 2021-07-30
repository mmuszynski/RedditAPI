//
//  File.swift
//  File
//
//  Created by Mike Muszynski on 7/26/21.
//

internal extension KeyedDecodingContainer {
    private struct EmptyObject: Decodable {}
    
    func decodeIfPresent<T: Decodable>(_ key: K) throws -> T? {
        return try self.decodeIfPresent(T.self, forKey: key)
    }
    
    func decode<T: Decodable>(_ key: K) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    func decodePossibleEmptyObject<T: Decodable>(_ key: K) throws -> T? {
        return try? self.decode(T.self, forKey: key)
    }
}
