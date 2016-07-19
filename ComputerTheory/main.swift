let dfa: AutomatonType = DFA()

let newState = State(value: "A")
try dfa.addState(newState)
try dfa.setFinalState(stateValue: "A")
try dfa.addTransition("a", fromState: newState, toState: newState)

print(dfa.evalutate(string: ""))
print(dfa.evalutate(string: "A"))
