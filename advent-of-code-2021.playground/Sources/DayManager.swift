import Foundation

public enum Day: String, CaseIterable {
    case day1A, day1B
    case day2A, day2B
    case day3A, day3B
    case day4A, day4B
    case day5A, day5B
    case day6A, day6B
    case day7A, day7B
    case day8A, day8B
    case day9A, day9B
    case day10A, day10B
    case day11A, day11B
    case day12A, day12B
    case day13A, day13B
    
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
            case .day7B: return performDay7B(fileName: fileNameForDay)
            case .day8A: return performDay8A(fileName: fileNameForDay)
            case .day8B: return performDay8B(fileName: fileNameForDay)
            case .day9A: return performDay9A(fileName: fileNameForDay)
            case .day9B: return performDay9B(fileName: fileNameForDay)
            case .day10A: return performDay10A(fileName: fileNameForDay)
            case .day10B: return performDay10B(fileName: fileNameForDay)
            case .day11A: return performDay11A(fileName: fileNameForDay)
            case .day11B: return performDay11B(fileName: fileNameForDay)
            case .day12A: return performDay12A(fileName: fileNameForDay)
            case .day12B: return performDay12B(fileName: fileNameForDay)
            case .day13A: return performDay13A(fileName: fileNameForDay)
            case .day13B: return performDay13B(fileName: fileNameForDay)
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
            case .day7A, .day7B: return "day-7"
            case .day8A, .day8B: return "day-8"
            case .day9A, .day9B: return "day-9"
            case .day10A, .day10B: return "day-10"
            case .day11A, .day11B: return "day-11"
            case .day12A, .day12B: return "day-12"
            case .day13A, .day13B: return "day-13"
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
