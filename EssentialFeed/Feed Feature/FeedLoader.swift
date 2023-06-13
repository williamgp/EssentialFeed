//  Created by Wiiliam Peregoy on 6/1/23.

import Foundation

public typealias LoadFeedResult<Error: Swift.Error> = Result<[FeedItem], Error>

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}

