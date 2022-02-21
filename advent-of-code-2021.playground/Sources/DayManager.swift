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
    case day14A, day14B
    case day15A, day15B
    
    var getAnswer: Int {
        switch self {
            case .day1A: return performDay1A(file: fileForDay)
            case .day1B: return performDay1B(file: fileForDay)
            case .day2A: return performDay2A(file: fileForDay)
            case .day2B: return performDay2B(file: fileForDay)
            case .day3A: return performDay3A(file: fileForDay)
            case .day3B: return performDay3B(file: fileForDay)
            case .day4A: return performDay4A(file: fileForDay)
            case .day4B: return performDay4B(file: fileForDay)
            case .day5A: return performDay5A(file: fileForDay)
            case .day5B: return performDay5B(file: fileForDay)
            case .day6A: return performDay6A(file: fileForDay)
            case .day6B: return performDay6B(file: fileForDay)
            case .day7A: return performDay7A(file: fileForDay)
            case .day7B: return performDay7B(file: fileForDay)
            case .day8A: return performDay8A(file: fileForDay)
            case .day8B: return performDay8B(file: fileForDay)
            case .day9A: return performDay9A(file: fileForDay)
            case .day9B: return performDay9B(file: fileForDay)
            case .day10A: return performDay10A(file: fileForDay)
            case .day10B: return performDay10B(file: fileForDay)
            case .day11A: return performDay11A(file: fileForDay)
            case .day11B: return performDay11B(file: fileForDay)
            case .day12A: return performDay12A(file: fileForDay)
            case .day12B: return performDay12B(file: fileForDay)
            case .day13A: return performDay13A(file: fileForDay)
            case .day13B: return performDay13B(file: fileForDay)
            case .day14A: return performDay14A(file: fileForDay)
            case .day14B: return performDay14B(file: fileForDay)
            case .day15A: return performDay15A(file: fileForDay)
            case .day15B: return performDay15B(file: fileForDay)
        }
    }
    
    var fileForDay: String {
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
            case .day14A, .day14B: return "day-14"
            case .day15A, .day15B: return "day-15"
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
