import FirstCourseThirdTaskChecker

let checker = Checker()
let a = StackClass()
let b = QueueClass()
let c = StackStruct()
let d = QueueStruct()
checker.checkInheritance(stack: a, queue: b)
checker.checkProtocols(stack: c, queue: d)
checker.checkExtensions(userType: User.self )

class StackClass: ArrayInitializableStorage {
    override var count: Int { array.count }
    
    private var array: [Int] = []
    
    required init(array: [Int]) {
        super.init()
        self.array = array
    }
    
    required init() {
        super.init()
    }
    
    override func push(_ element: Int) {
        array.append(element)
    }
    
    override func pop() -> Int {
       return array.remove(at: array.count - 1)
    }
}

class QueueClass: ArrayInitializableStorage {
    override var count: Int { array.count }
    
    private var array: [Int] = []
    
    required init(array: [Int]) {
        super.init()
        self.array = array
    }
    
    required init() {
        super.init()
    }
    
    override func push(_ element: Int) {
        array.append(element)
    }
    
    override func pop() -> Int {
       return array.remove(at: 0)
    }
}

struct StackStruct: StorageProtocol, ArrayInitializable {
   
    private var array: [Int] = []
    var count: Int { array.count }
    
    init() {}
    
    init(array: [Int]) {
        self.array = array
    }
    
    mutating func push(_ element: Int) {
        array.append(element)
    }
    
    mutating func pop() -> Int {
        return array.remove(at: array.count - 1)
    }
}

struct QueueStruct: StorageProtocol, ArrayInitializable {
   
    private var array: [Int] = []
    var count: Int { array.count }
    
    init() {}
    
    init(array: [Int]) {
        self.array = array
    }
    
    mutating func push(_ element: Int) {
        array.append(element)
    }
    
    mutating func pop() -> Int {
        return array.remove(at: 0)
    }
}

extension User: JSONInitializable, JSONSerializable {
    public func toJSON() -> String {
        return "{\"fullName\": \"\(self.fullName)\", \"email\": \"\(self.email)\"}"
    }
    
    public convenience init(JSON: String) {
        self.init()
        let data = Data(JSON.utf8)
        
        if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            self.fullName = json["fullName"] as! String
            self.email = json["email"] as! String
        }
    }
}
