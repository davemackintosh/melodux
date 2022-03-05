import Foundation

final class Store<Actions, StateShape> {
	var state: StateShape
	private var rootReducer: (Actions, StateShape) -> StateShape
	private var middlewares: [(Actions) -> Actions] = []

	init(
		initialState: StateShape,
		rootReducer: @escaping (Actions, StateShape) -> StateShape
	) {
		self.state = initialState
		self.rootReducer = rootReducer
	}

	func registerMiddlewares(middlewares: [(Actions) -> Actions]) -> Store<Actions, StateShape> {
		self.middlewares = middlewares
		return self
	}

	static func composeReducers(reducers: [(Actions, StateShape) -> StateShape]) -> (Actions, StateShape) -> StateShape {
		return { action, state in
			return reducers.reduce(state, { prev, next in
				next(action, prev)
			})
		}
	}

	func dispatch(action: Actions, background: Bool?) {
		let currentState = self.state
		let nextAction: Actions = self.middlewares.reduce(action, { prevAction, currentMiddleware in
			return currentMiddleware(prevAction)
		})
		let nextState = self.rootReducer(nextAction, currentState)
		self.state = nextState
	}
}


