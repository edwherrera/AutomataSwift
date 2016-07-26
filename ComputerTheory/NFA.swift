import Foundation

class NFA : DFA {
    
    override func evalutate(string: String) -> Bool {
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
    
    override func addTransition(_ newTransition: String, fromState: StateType, toState: StateType) throws {
        guard let fromState = getState(withValue: fromState.value),
            let toState = getState(withValue: toState.value) else {
                throw AutomatonError.stateNotFound
        }
        fromState.setDestinyState(state: toState, forTransition: newTransition)
    }
}
