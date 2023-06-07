//  Created by Wiiliam Peregoy on 6/1/23.

import Foundation

public struct FeedItem: Identifiable, Equatable {
    public let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
