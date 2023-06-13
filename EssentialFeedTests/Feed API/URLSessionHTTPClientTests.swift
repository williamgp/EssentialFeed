//  Created by Wiiliam Peregoy on 6/13/23

import XCTest

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test() {
        let url = URL(string: "http://any-url.com")!
        
        XCTAssertEqual(session.receivedURLs, [url])
    }

}
