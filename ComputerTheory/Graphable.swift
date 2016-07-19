protocol Graphable {
    var coordinates: (x: Int, y: Int) { get }
}

class GraphableState: State, Graphable {
    private var _x: Int
    private var _y: Int
    
    var coordinates: (x: Int, y: Int) {
        return (_x, _y)
    }
    
    init(value: String, x:Int, y:Int) {
        _x = x
        _y = y
        super.init(value: value)
    }
    
    required convenience init(value: String) {
        self.init(value: value, x:-1, y:-1)
    }
}