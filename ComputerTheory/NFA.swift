import Foundation

class NFA : AutomatonType {
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
    
    @available(*, unavailable , message: "Method has no implmentation defined")
    func evalutate(string: String) -> Bool {
        guard let currState = initialState else {
            return false
        }
        
        return evaluate(string: string, currentState: currState)
        
    }
    
    private func evaluate(string: String, currentState:StateType) -> Bool {
        if string.isEmpty { return currentState.isFinal }
        
        var string = string
        let toEval = String(string.characters.popFirst())
        let destStates = currentState.getDestinyStates(toEval)
        
        for state in destStates {
            if evaluate(string: string, currentState: state) { return true }
        }
        
        return false
    }
    
    
    func addTransition(_ newTransition: String, fromState: StateType, toState: StateType) throws {
        guard let fromState = getState(withValue: fromState.value),
            let toState = getState(withValue: toState.value) else {
                throw AutomatonError.stateNotFound
        }
        
        fromState.setDestinyState(state: toState, forTransition: newTransition)
        
    }
    
    func setFinalState(stateValue value: String) throws -> StateType {
        guard let foundState = getState(withValue: value) else {
            throw AutomatonError.stateNotFound
        }
        
        foundState.isFinal = !foundState.isFinal
        return foundState
    }
}
