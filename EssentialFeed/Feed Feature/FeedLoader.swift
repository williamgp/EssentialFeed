//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Wiiliam Peregoy on 6/1/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
