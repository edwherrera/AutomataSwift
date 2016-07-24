let dfa: AutomatonType = DFA()

let newState = State(value: "A")
let otherState = State(value: "B")

try dfa.addState(newState)
try dfa.addState(otherState)

let _ = try dfa.setFinalState(stateValue: "A")
try dfa.addTransition("a", fromState: newState, toState: otherState)
try dfa.addTransition("b", fromState: newState, toState: newState)

let _ = try dfa.removeState(withValue: "B")


print(dfa.evalutate(string: ""))
print(dfa.evalutate(string: "A"))
