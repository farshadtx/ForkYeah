import XCTest

func XCTAssertThrowsErrorAsync(
    _ expression: @autoclosure () async throws -> Void,
    file: StaticString = #file,
    line: UInt = #line,
    handler: ((Error) -> Void)? = nil
) async {
    do {
        try await expression()
        XCTFail("Expected error, but no error was thrown", file: file, line: line)
    } catch {
        handler?(error)
    }
}
