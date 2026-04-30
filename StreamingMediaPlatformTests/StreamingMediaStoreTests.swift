import XCTest
@testable import StreamingMediaPlatform

@MainActor
final class StreamingMediaStoreTests: XCTestCase {
    func testSessionSignInAndSignOut() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = StreamingMediaStore(sync: StreamingMediaSync(defaults: defaults, key: "streaming.tests.session"))

        XCTAssertFalse(store.isSignedIn)
        store.execute(.account(.signIn("viewer")))
        XCTAssertTrue(store.isSignedIn)
        XCTAssertEqual(store.state.session?.userName, "viewer")

        store.execute(.account(.signOut))
        XCTAssertFalse(store.isSignedIn)
    }

    func testWatchlistPersistsRoundTrip() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let key = "streaming.tests.watchlist"
        let store = StreamingMediaStore(sync: StreamingMediaSync(defaults: defaults, key: key))
        let title = store.state.titles.first!

        store.execute(.list(.toggleWatchlist(title.id)))
        XCTAssertTrue(store.state.watchlistIDs.contains(title.id))

        let restored = StreamingMediaStore(sync: StreamingMediaSync(defaults: defaults, key: key))
        XCTAssertTrue(restored.state.watchlistIDs.contains(title.id))
    }

    func testPlaybackCreatesContinuation() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = StreamingMediaStore(sync: StreamingMediaSync(defaults: defaults, key: "streaming.tests.playback"))
        let title = store.state.titles.first!

        store.execute(.playback(.start(title.id)))
        store.execute(.playback(.seek(120)))
        store.execute(.playback(.stop))

        XCTAssertNil(store.playback)
        XCTAssertEqual(store.continuation?.titleID, title.id)
        XCTAssertEqual(store.continuation?.positionSeconds, 120)
    }
}
