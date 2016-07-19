protocol StateType : class {
    var value: String { get }
    var transitions: [ String : [StateType] ] { get }
    var isFinal: Bool { get set }
    
    func getDestinyStates(withTransition: String) -> [StateType]
    func hasTransition(withValue value: String) -> Bool
    func setDestinyState(state state:StateType, forTransition:String)
    
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

    func getDestinyStates(withTransition: String) -> [StateType] {
        return _transitions[withTransition] ?? []
    }
    
    func hasTransition(withValue value: String) -> Bool {
        return getDestinyStates(value).count > 0
    }
    
    func setDestinyState(state state: StateType, forTransition: String) {
        var destinyStates = getDestinyStates(forTransition)
        destinyStates.append(state)
        _transitions.updateValue(destinyStates, forKey: forTransition)
    }
}