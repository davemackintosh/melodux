# Melodux

A super simple Redux implementation in Swift.

# Usage

1. Define a `struct` which defines the shape of your state.
2. Define an `enum` which defines the actions available to your reducers and middleware.
	* These `case`s should `let` the arguments they take.
3. Define your app's initial state that conforms to your struct above.
4. Define a reducer
	* if you want to spread your logic into categories use `Store.composeReducers`.
5. Optional, define middlewares and register with `store.registerMiddlewares([])
6. Profit.

## Full example

```swift
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

let initialState = TestStateShape(name: "", version: "")
let store = Melodux.Store<TestStateActions, TestStateShape>(initialState: initialState, rootReducer: rootReducer)

store.dispatch(action: .SetName("Melodux"), background: false)
```

I use this as an `@EnvironmentObject` in my Swift app "Melodist", a cross platform musical tablature editor.
