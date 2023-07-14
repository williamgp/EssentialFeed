//  Created by Wiiliam Peregoy on 7/14/23

import Foundation

internal struct RemoteFeedItem: Identifiable, Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
