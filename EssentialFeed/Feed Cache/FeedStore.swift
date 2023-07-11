//  Created by Wiiliam Peregoy on 7/11/23

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    func insert(_ items: [FeedItem],
                timestamp: Date,
                completion: @escaping InsertionCompletion)
}
