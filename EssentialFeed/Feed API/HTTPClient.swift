//  Created by William Peregoy on 6/9/23

import Foundation

public typealias HTTPClientResult = Result <(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL,
             completion: @escaping (HTTPClientResult) -> Void)
}
