import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SpotifyAPITests.allTests),
        testCase(ObjectDecodingTests.allTests),
    ]
}
#endif
