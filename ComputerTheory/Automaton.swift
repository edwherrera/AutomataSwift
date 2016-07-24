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


// MARK: Objects

import Foundation

class DFA : AutomatonType {
    private var _initialState: StateType?
    private var _states: [StateType] = [] 
    
    var initialState: StateType?  {
        return _initialState
    }
    
    var states: [StateType] {
        return _states
    }
    
    func addState(_ newState: StateType) throws {
        
        if getState(withValue: newState.value) != nil {
            throw AutomatonError.stateAlreadyExists
        }
        
        _states.append(newState)
        
        if _states.count == 1 {
            _initialState = _states[0]
        } else if _states.count == 0 {
            _initialState = nil
        }
    }
    
    func removeState(withValue value: String) throws -> StateType {
        for (index, state) in states.enumerated() {
            if state.value == value {
                let removedState = _states.remove(at: index)
                for stateIt in _states {
                    stateIt.removeTransitionsToState(state: state)
                }
                return removedState
            }
        }
        throw AutomatonError.stateNotFound
    }
    
    func getState(withValue value: String) -> StateType? {
        for state in states {
            if state.value == value {
                return state
            }
        }
        return nil
    }
    
    func setInitialState(value: String) throws -> StateType {
        guard let foundState = getState(withValue: value) else {
            throw AutomatonError.stateNotFound
        }
        _initialState = foundState
        return foundState
    }
    
    //@available(*, unavailable , message="Method has no implmentation defined")
    func evalutate(string: String) -> Bool {
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
    
    func addTransition(_ newTransition: String, fromState: StateType, toState: StateType) throws {
        
        guard let fromState = getState(withValue: fromState.value),
            let toState = getState(withValue: toState.value) else {
              throw AutomatonError.stateNotFound
        }
        
        if fromState.hasTransition(withValue: newTransition) {
            throw AutomatonError.transitionAlreadyExists
        }
            
        fromState.setDestinyState(state: toState, forTransition: newTransition)
    }
    
    func hasState(withValue value: String) -> Bool {
        return getState(withValue: value) != nil
    }
    
    func setFinalState(stateValue value: String) throws -> StateType {
        guard let foundState = getState(withValue: value) else {
            throw AutomatonError.stateNotFound
        }
        
        foundState.isFinal = !foundState.isFinal
        return foundState
    }
    
    private func ClearTransitionsToState(_ state: StateType) throws {
        
    }
}
