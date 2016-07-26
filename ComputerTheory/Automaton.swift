enum AutomatonError: ErrorProtocol {
    case stateAlreadyExists
    case stateNotFound
    case transitionAlreadyExists
}

// MARK: Protocols

protocol AutomatonType : class {
    var initialState:StateType? { get }
    var states:[StateType] { get }
    
    func addState(_ newState: StateType) throws
    func removeState(withValue value: String) throws -> StateType
    func getState(withValue value: String) -> StateType?
    func setInitialState(value: String) throws -> StateType
    func evalutate(string: String) -> Bool
    func addTransition(_ newTransition: String, fromState:StateType, toState:StateType) throws
    func hasState(withValue value:String) -> Bool
    func setFinalState(stateValue value:String) throws -> StateType
}


extension AutomatonType {
    func hasState(withValue value:String) -> Bool {
        return self.getState(withValue: value) != nil
    }
}
