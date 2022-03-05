import XCTest
@testable import Melodux

struct TestStateShape {
	var name: String
	var version: String
}

enum TestStateActions {
	case SetName(String)
	case SetVersion(String)
}

func rootReducer(action: TestStateActions, state: TestStateShape) -> TestStateShape {
	switch (action) {
	case .SetName(let name):
		return TestStateShape(name: name, version: state.version)
	case .SetVersion(let version):
		return TestStateShape(name: state.name, version: version)
	}
}

final class MeloduxTests: XCTestCase {
	func testBasicStore() throws {
		let initialState = TestStateShape(name: "", version: "")
		let store = Melodux.Store<TestStateActions, TestStateShape>(initialState: initialState, rootReducer: rootReducer)

		XCTAssertEqual(store.state.name, "")
		XCTAssertEqual(store.state.version, "")

		store.dispatch(action: .SetName("Melodux"), background: false)
		XCTAssertEqual(store.state.name, "Melodux")
	}

	func testMiddleware() throws {
		let initialState = TestStateShape(name: "", version: "")
		var middlewareWasCalled = 0
		let middlewares: [(TestStateActions) -> TestStateActions] = [
			{ action in
				middlewareWasCalled += 1
				return action
			}
		]
		let store = Melodux.Store<TestStateActions, TestStateShape>(initialState: initialState, rootReducer: rootReducer)
			.registerMiddlewares(middlewares: middlewares)

		XCTAssertEqual(middlewareWasCalled, 0)
		XCTAssertEqual(store.state.name, "")
		XCTAssertEqual(store.state.version, "")

		store.dispatch(action: .SetName("Melodux"), background: false)
		XCTAssertEqual(middlewareWasCalled, 1)
		XCTAssertEqual(store.state.name, "Melodux")

		store.dispatch(action: .SetVersion("1.2.3"), background: false)
		XCTAssertEqual(middlewareWasCalled, 2)
		XCTAssertEqual(store.state.version, "1.2.3")
	}
}
