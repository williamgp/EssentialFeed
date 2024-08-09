//  Created by Wiiliam Peregoy on 8/8/24

import Foundation
import EssentialFeed

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
 
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void
    ) -> EssentialFeed.FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url) { _ in }
                return data
            })
        }
    }
}
