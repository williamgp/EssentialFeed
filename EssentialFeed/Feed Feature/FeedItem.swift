//  Created by Wiiliam Peregoy on 6/1/23.

import Foundation

struct FeedItem: Identifiable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
