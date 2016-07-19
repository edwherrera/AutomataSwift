enum AutomatonError: ErrorType {
    case StateAlreadyExists
    case StateNotFound
    case TransitionAlreadyExists
}

// MARK: Protocols

protocol AutomatonType : class {
    var initialState:StateType? { get }
    var states:[StateType] { get }
    
    func addState(newState: StateType) throws
    func removeState(withValue value: String) throws -> StateType
    func getState(withValue value: String) -> StateType?
    func setInitialState(value value: String) throws -> StateType
    func evalutate(string string: String) -> Bool
    func addTransition(newTransition: String, fromState:StateType, toState:StateType) throws
    func hasState(withValue value:String) -> Bool
    func setFinalState(stateValue value:String) throws -> StateType
}


// MARK: Objects

import Foundation

class DFA : AutomatonType {
    private var _initialState: StateType?
    private var _states: [StateType] = [] {
        didSet {
            if _states.count == 1 {
                _initialState = _states[0]
            } else if _states.count == 0 {
                _initialState = nil
            }
        }
    }
    
    var initialState: StateType?  {
        return _initialState
    }
    
    var states: [StateType] {
        return _states
    }
    
    func addState(newState: StateType) throws {
        
        if getState(withValue: newState.value) != nil {
            throw AutomatonError.StateAlreadyExists
        }
        
        _states.append(newState)
    }
    
    func removeState(withValue value: String) throws -> StateType {
        for (index, state) in states.enumerate() {
            if state.value == value {
                return _states.removeAtIndex(index)
            }
        }
        throw AutomatonError.StateNotFound
    }
    
    func getState(withValue value: String) -> StateType? {
        for state in states {
            if state.value == value {
                return state
            }
        }
        return nil
    }
    
    func setInitialState(value value: String) throws -> StateType {
        guard let foundState = getState(withValue: value) else {
            throw AutomatonError.StateNotFound
        }
        _initialState = foundState
        return foundState
    }
    
    //@available(*, unavailable , message="Method has no implmentation defined")
    func evalutate(string string: String) -> Bool {
        guard var state = initialState  else {
            return false
        }
        
        for c in string.characters{
            guard let destinyState = state.getDestinyStates(String(c)).first else {
                return false
            }
            state = destinyState
        }
        
        return state.isFinal
        
    }
    
    func addTransition(newTransition: String, fromState: StateType, toState: StateType) throws {
        
        guard let fromState = getState(withValue: fromState.value),
            let toState = getState(withValue: toState.value) else {
              throw AutomatonError.StateNotFound
        }
        
        if fromState.hasTransition(withValue: newTransition) {
            throw AutomatonError.TransitionAlreadyExists
        }
            
        fromState.setDestinyState(state: toState, forTransition: newTransition)
    }
    
    func hasState(withValue value: String) -> Bool {
        return getState(withValue: value) != nil
    }
    
    func setFinalState(stateValue value: String) throws -> StateType {
        guard let foundState = getState(withValue: value) else {
            throw AutomatonError.StateNotFound
        }
        
        foundState.isFinal = !foundState.isFinal
        return foundState
    }
}
