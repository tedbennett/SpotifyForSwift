import XCTest
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let manager = SpotifyAPI.shared
        manager.authorize {result in
            XCTAssertEqual(result, true)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
