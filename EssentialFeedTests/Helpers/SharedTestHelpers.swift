//  Created by William Peregoy on 7/25/23

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}


func anyData() -> Data {
    Data("any data".utf8)
}
