import Foundation

public enum Day: String, CaseIterable {
    case day1A
    case day1B
    case day2A
    case day2B
    case day3A
    case day3B
    case day4A
    case day4B
    case day5A
    case day5B
    
    var getAnswer: Int {
        switch self {
        case .day1A: return performDay1A()
        case .day1B: return performDay1B()
        case .day2A: return performDay2A()
        case .day2B: return performDay2B()
        case .day3A: return performDay3A()
        case .day3B: return performDay3B()
        case .day4A: return performDay4A()
        case .day4B: return performDay4B()
        case .day5A: return performDay5A()
        case .day5B: return performDay5B()
        }
    }
}

public func executeAllDays() {
    for day in Day.allCases {
        executeSingleDay(day: day)
    }
}

public func executeSingleDay(day: Day) {
    let startTime = Date()
    let answer = day.getAnswer
    let durationMs = Date().timeIntervalSince(startTime).toMilliseconds
    
    displayResults(dayVal: day.rawValue,
                   answer: answer,
                   durationMs: durationMs)
}

private func displayResults(dayVal: String, answer: Int, durationMs: Int) {
    print("\(dayVal) : \(answer) : \(durationMs)ms")
}
