//
//  File.swift
//
//
//  Created by Mike Muszynski on 2/13/21.
//

import Foundation

extension URL {
    
    /// Returns a `URL` suitable for requesting JSON from reddit
    var jsonURL: URL {
        guard self.pathExtension != "json" else { return self }
        let appended = self.appendingPathExtension("json")
        
        //sanitize for reddit
        let string = appended.absoluteString.replacingOccurrences(of: ".json/", with: ".json")
        let final = URL(string: string)!
        
        return final
    }
}

/// Namespace for various Reddit API helpers
enum RedditAPI {
    
    private static var baseURLComponents: URLComponents = {
        var components = URLComponents()
        components.host = "www.reddit.com"
        components.scheme = "https"
        return components
    }()
    
    /// Errors that arise when forming a `URL`
    enum URLError: Error {
        case couldNotFormURL
    }
    
    /// Creates a `URL` suitable for requesting JSON information from a given subreddit
    /// - Parameters:
    ///   - subredditName: The name of the subreddit
    ///   - batch: The requested length of each listing returned
    ///   - mode: A modifier for the reddit algorithm (see `SubredditMode`)
    ///   - modeLimit: A further limit on the algorithm (see `SubredditModeLimit`)
    /// - Throws: `URLError` if a `URL` can not be formed
    /// - Returns: A `URL` suitable for requesting JSON information from a given subreddit
    public static func jsonURL(forSubreddit subredditName: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws -> URL {
        return try url(forSubreddit: subredditName, batch: batch, mode: mode, modeLimit: modeLimit).jsonURL
    }
    
    /// Creates a `URL` suitable for requesting JSON information from a given user
    /// - Parameters:
    ///   - subredditName: The name of the subreddit
    ///   - batch: The requested length of each listing returned
    ///   - mode: A modifier for the reddit algorithm (see `SubredditMode`)
    ///   - modeLimit: A further limit on the algorithm (see `SubredditModeLimit`)
    /// - Throws: `URLError` if a `URL` can not be formed
    /// - Returns: A `URL` suitable for requesting JSON information from a given user
    public static func jsonURL(forUser username: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws -> URL {
        return try url(forUser: username, batch: batch, mode: mode, modeLimit: modeLimit).jsonURL
    }
    
    /// Creates a `URL` suitable for requesting information from a given user
    /// - Parameters:
    ///   - subredditName: The name of the user
    ///   - batch: The requested length of each listing returned
    ///   - mode: A modifier for the reddit algorithm (see `SubredditMode`)
    ///   - modeLimit: A further limit on the algorithm (see `SubredditModeLimit`)
    /// - Throws: `URLError` if a `URL` can not be formed
    /// - Returns: A `URL` suitable for requesting information from a given subreddit
    public static func url(forUser username: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws -> URL {
        return try url(forName: username, type: "user", batch: batch, mode: mode, modeLimit: modeLimit)
    }
    
    /// Creates a `URL` suitable for requesting information from a given user
    /// - Parameters:
    ///   - subredditName: The name of the user
    ///   - batch: The requested length of each listing returned
    ///   - mode: A modifier for the reddit algorithm (see `SubredditMode`)
    ///   - modeLimit: A further limit on the algorithm (see `SubredditModeLimit`)
    /// - Throws: `URLError` if a `URL` can not be formed
    /// - Returns: A `URL` suitable for requesting information from a given subreddit
    public static func url(forSubreddit subredditName: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws -> URL {
        return try url(forName: subredditName, type: "r", batch: batch, mode: mode, modeLimit: modeLimit)
    }
    
    /// Creates a `URL` suitable for requesting information from a given reddit type (e.g. "user", "subreddit" or otherwise)
    /// - Parameters:
    ///   - subredditName: The name of the user
    ///   - batch: The requested length of each listing returned
    ///   - mode: A modifier for the reddit algorithm (see `SubredditMode`)
    ///   - modeLimit: A further limit on the algorithm (see `SubredditModeLimit`)
    /// - Throws: `URLError` if a `URL` can not be formed
    /// - Returns: A `URL` suitable for requesting information from reddit
    private static func url(forName name: String, type: String, batch: Int = 25, mode: SubredditMode = .hot, modeLimit: SubredditModeLimit = .all) throws -> URL {
        guard name != "" else {
            throw URLError.couldNotFormURL
        }
        
        var components = self.baseURLComponents
        
        if [.top, .controversial].contains(mode) {
            let items = [modeLimit.queryItem]
            if components.queryItems == nil {
                components.queryItems = items
            } else {
                components.queryItems?.append(contentsOf: items)
            }
        }
        
        if batch != 25 {
            let item = URLQueryItem(name: "limit", value: "\(batch)")
            if components.queryItems == nil {
                components.queryItems = [item]
            } else {
                components.queryItems?.append(item)
            }
        }
        
        var url = components.url
        url?.appendPathComponent(type)
        url?.appendPathComponent(name)
        url?.appendPathComponent(mode.subpath)
        
        guard let returnURL = url else {
            throw URLError.couldNotFormURL
        }
        
        return returnURL
    }
    
    public static func url(fromPermalink permalink: String) -> URL? {
        var baseComponents = self.baseURLComponents
        baseComponents.path = permalink
        return baseComponents.url
    }
    
    public static func jsonUrl(fromPermalink permalink: String) -> URL? {
        var baseComponents = self.baseURLComponents
        baseComponents.path = permalink
        return baseComponents.url?.jsonURL
    }
}
