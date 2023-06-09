//  Created by Wiiliam Peregoy on 6/9/23

import Foundation

internal final class FeedItemsMapper {
    private static var OK_200: Int { 200 }
    
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Identifiable, Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            FeedItem(id: id,
                     description: description,
                     location: location,
                     imageURL: image)
        }
    }

    internal static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
    
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        do {
            let items = try FeedItemsMapper.map(
                data, response: response)
            return .success(items)
        } catch {
            return .failure(.invalidData)
        }
    }
}

