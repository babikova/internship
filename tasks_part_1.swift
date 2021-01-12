import UIKit

// task 1
func arrayElements(arr: [Int]) -> (Int, Int) {
    var sumEven: Int = 0
    var sumUneven: Int = 0
    
    for el in arr {
        if el % 2 == 0 {
            sumEven += 1
        } else {
            sumUneven += 1
        }
    }
    
    return (sumEven, sumUneven)
}

// task 2
enum Color: String {
    case white = "Белый"
    case red = "Красный"
    case green = "Зелёный"
    case black = "Чёрный"
    case blue = "Синий"
}

struct Circle {
    var radius: Double
    var color: Color
}

let c1 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.white)
let c2 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.white)
let c3 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.red)
let c4 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.red)
let c5 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.red)
let c6 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.green)
let c7 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.green)
let c8 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.green)
let c9 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.black)
let c10 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.black)
let c11 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.blue)
let c12 = Circle(radius: Double.random(in: 1.0...10.0), color: Color.blue)

let dict = [0: c1, 1: c2, 2: c3, 3: c4, 4: c5, 5: c6, 6: c7, 7: c8, 8: c9, 9: c10, 10: c11, 11: c12]

func arrayCircle(dict: [Int: Circle]) -> [Circle] {
    var arrWhite: [Circle] = []
    var arrOther: [Circle] = []
    var arrBlue: [Circle] = []
    
    var array = Array(dict.values)
    
    for i in 0..<array.count {
        switch array[i].color {
        case .white:
            arrWhite.append(array[i])
        case .black:
            array[i].radius *= 2.0
            arrOther.append(array[i])
        case .red:
            continue
        case .green:
            array[i].color = .blue
            arrBlue.append(array[i])
        case .blue:
            arrBlue.append(array[i])
        }
    }
    
    return arrWhite + arrOther + arrBlue
}

// task 3
let arrayDict = [["fullName": "Name1", "salary": "600", "company": "Company1"], ["fullName": "Name2", "salary": "200", "company": "Company2"], ["fullName": "Name3", "salary": "300", "company": "Company3"], ["fullName": "Name4", "salary": "350", "company": "Company4"], ["fullName": "Name5", "salary": "200", "company": "Company5", "language": "language1"], ["fullName": "Name6", "salary": "600", "age": "19", "language": "language2"], ["fullnme": "Name7", "salry": "700"], ["fulname": "Name8", "salay": "100"], ["fullName": "Name9", "salary": "700"], ["fullname": "Name10", "salary": "1000"]]

struct Employee {
    let fullName: String
    let salary: String
    let company: String
}

func sortEmployee(array: [[String: String]]) -> [Employee] {
    var arrEmp: [Employee] = []
    for i in array {
        guard i.count == 3 else {
            continue
        }
        guard let fullName = i["fullName"], let salary = i["salary"], let company = i["company"] else {
            continue
        }
        let emp = Employee(fullName:fullName, salary: salary, company: company)
        arrEmp.append(emp)
    }
    
    let sortedArr = arrEmp.sorted {
        if let first: Int = Int($0.salary), let second: Int = Int($1.salary) {
            return first < second
        }
        return false
    }
    
    return sortedArr
}

// task 4
let arrayName: [String] = ["Вася", "Олег", "Вова", "Оля", "Маша", "Миша", "Марина", "Костя", "Катя", "Ксюша", "Игорь", "Антон", "Аня", "Андрей", "Саша", "Света", "Даниил", "Даша", "Дима", "Лера"]

func arrayGroup(array: [String]) -> [String: [String]] {
    var lettersArray: [String] = []
    for i in array {
        lettersArray.append(String(i.prefix(1)))
    }
    
    let letters = Set<String>(lettersArray)
    var dict: [String: [String]] = [:]
    
    for i in letters {
        let filteredArray = array.filter {
            String($0.prefix(1)) == i
        }
        if filteredArray.count > 2 {
            let sortedArray = filteredArray.sorted {
                $0 > $1
            }
            dict[i] = sortedArray
        }
    }
    
    return dict
}

let sortedArray = Dictionary(grouping: arrayName.sorted { $0 > $1 }, by: { $0.first! }).filter { $0.value.count > 2}