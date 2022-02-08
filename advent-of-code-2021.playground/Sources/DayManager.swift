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
    case day6A
    case day6B
    case day7A
    
    var getAnswer: Int {
        switch self {
        case .day1A: return performDay1A(fileName: fileNameForDay)
        case .day1B: return performDay1B(fileName: fileNameForDay)
        case .day2A: return performDay2A(fileName: fileNameForDay)
        case .day2B: return performDay2B(fileName: fileNameForDay)
        case .day3A: return performDay3A(fileName: fileNameForDay)
        case .day3B: return performDay3B(fileName: fileNameForDay)
        case .day4A: return performDay4A(fileName: fileNameForDay)
        case .day4B: return performDay4B(fileName: fileNameForDay)
        case .day5A: return performDay5A(fileName: fileNameForDay)
        case .day5B: return performDay5B(fileName: fileNameForDay)
        case .day6A: return performDay6A(fileName: fileNameForDay)
        case .day6B: return performDay6B(fileName: fileNameForDay)
        case .day7A: return performDay7A(fileName: fileNameForDay)
        }
    }
    
    var fileNameForDay: String {
        switch self {
        case .day1A, .day1B: return "day-1"
        case .day2A, .day2B: return "day-2"
        case .day3A, .day3B: return "day-3"
        case .day4A, .day4B: return "day-4"
        case .day5A, .day5B: return "day-5"
        case .day6A, .day6B: return "day-6"
        case .day7A: return "day-7"
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
