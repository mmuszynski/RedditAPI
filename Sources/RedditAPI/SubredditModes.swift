//
//  File.swift
//  
//
//  Created by Mike Muszynski on 2/13/21.
//

import Foundation

/// Modes for the displaying of Subreddits
///
/// Defaults to `SubredditMode.hot`. Can be combined with `SubredditMode`s in `URL` generation. For example, to specify the `URL` https://www.reddit.com/r/politics/controversial, provide `SubredditMode.controversial` to the `URL` generator.
public enum SubredditMode: String, CaseIterable, Codable {
    case hot, new, rising, top, controversial
    
    internal var subpath: String {
        switch self {
        case .hot:
            return ""
        case .new:
            return "new"
        case .rising:
            return "rising"
        case .top:
            return "top"
        case .controversial:
            return "controversial"
        }
    }
}

/// Further limits to apply to the various `SubredditMode` values
///
/// - Note: Certain combinations are invalid. These combinations will not raise an error, but rather, will cause the `SubredditMode` to remain unmodified.
///
/// Example: Combining `SubredditMode.hot` with `SubredditModeLimit.hour` will not result in further modifications to the `SubredditMode`.
public enum SubredditModeLimit: String, CaseIterable, Codable {
    case hour, day, week, month, year, all
    
    internal var queryItem: URLQueryItem {
        return URLQueryItem(name: "t", value: self.rawValue)
    }
}
