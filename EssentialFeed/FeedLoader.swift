//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Wiiliam Peregoy on 6/1/23.
//

import Foundation

protocol FeedLoader {
    func load(completion: @escaping () -> Void)
}
