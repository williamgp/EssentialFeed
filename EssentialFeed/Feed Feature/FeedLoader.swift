//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Wiiliam Peregoy on 6/1/23.
//

import Foundation

typealias LoadFeedResult = Result<[FeedItem], Error>

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
