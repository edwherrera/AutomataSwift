protocol StateType : class {
    var value: String { get }
    var transitions: [ String : [StateType] ] { get }
    var isFinal: Bool { get set }
    
    func getDestinyStates(_ withTransition: String) -> [StateType]
    func hasTransition(withValue value: String) -> Bool
    func setDestinyState(state:StateType, forTransition:String)
    func removeTransitionsToState(state: StateType)
    func getAllExits() -> [StateType]
    
    init(value: String)
    
}

class State : StateType {
    private let _value: String
    private var _transitions: [String : [StateType]] = [:]
    private var _isFinal: Bool = false
    
    var value: String {
        return _value
    }
    
    var transitions: [String : [StateType]] {
        return _transitions
    }
    
    var isFinal: Bool {
        get {
            return _isFinal
        }
        set(isFinal) {
            _isFinal = isFinal
        }
    }
    
    required init(value: String) {
        _value = value
    }

    func getDestinyStates(_ withTransition: String) -> [StateType] {
        return _transitions[withTransition] ?? []
    }
    
    func hasTransition(withValue value: String) -> Bool {
        return getDestinyStates(value).count > 0
    }
    
    func setDestinyState(state: StateType, forTransition: String) {
        var destinyStates = getDestinyStates(forTransition)
        if destinyStates.contains({ destState in state.value == destState.value }) {
            destinyStates.append(state)
        }
        _transitions.updateValue(destinyStates, forKey: forTransition)
    }
    
    func removeTransitionsToState(state: StateType) {
        for transition in _transitions {
            let destinyStates = transition.1.filter({ (stateIt) -> Bool in
                stateIt.value != state.value
            })
            if destinyStates.count == 0 {
                _transitions.removeValue(forKey: transition.0)
            } else {
                _transitions.updateValue(destinyStates, forKey: transition.0)
            }
        }
    }
    
    func getAllExits() -> [StateType] {
        var exits = [StateType]()
        for (_, destStates) in _transitions {
            for state in destStates {
                if !exits.contains({exit in exit.value == state.value}) {
                    exits.append(state)
                }
            }
        }
        return exits
    }
}
