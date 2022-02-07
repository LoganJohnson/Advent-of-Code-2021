import Foundation

// https://adventofcode.com/2021/day/6
internal func performDay6A(fileName: String) -> Int {
    solveDay6(totalDays: 80, fishBirthCountdowns: parseFishBirthCountdowns(fileName: fileName))
}

// https://adventofcode.com/2021/day/6#part2
internal func performDay6B(fileName: String) -> Int {
    solveDay6(totalDays: 256, fishBirthCountdowns: parseFishBirthCountdowns(fileName: fileName))
}

private func solveDay6(totalDays: Int, fishBirthCountdowns: [Int]) -> Int {
    var totalFishCount = 0
    // used to save already solved decendant count based on a fish's "giving birth" day (memoization 🎩)
    // example key/vaule would be [23: 9]
    // (if you are a fish giving birth with 29 days left, you and your decendants will equal 9 fish)
    var solvedDays = [Int: Int]()
    
    for firstBirthContdown in fishBirthCountdowns {
        let (decendantCount, newSolvedDays) = getDecendantCount(dayOfBirth: totalDays - firstBirthContdown,
                                                                solvedDays: solvedDays)
        totalFishCount += decendantCount
        solvedDays = newSolvedDays
    }
    
    return totalFishCount
}

// the number of days after a birth until an adult fish can give birth again
private let fishBirthCountdownAdult = 7
// baby fish take an additional 2 days on their first "cycle" to give birth
private let fishBirthCountdownBaby = 9

private func getDecendantCount(dayOfBirth: Int, solvedDays: [Int: Int]) -> (Int, [Int: Int]) {
    if let solvedDay = solvedDays[dayOfBirth] {
        // just returned the already solved decendant count for this day of birth
        return (solvedDay, solvedDays)
    } else if dayOfBirth <= 0 {
        // not enough time to actually give birth again, just return the "current fish"
        return (1, solvedDays)
    } else {
        // get decendant count of the current adult fish after it gives birth
        let (adultDecentdantCount, firstSolvedDays) = getDecendantCount(dayOfBirth: dayOfBirth - fishBirthCountdownAdult, solvedDays: solvedDays)
        
        // and get the decendant count of the brand new baby fish
        var (babyDecendantCount, secondSolvedDays) = getDecendantCount(dayOfBirth: dayOfBirth - fishBirthCountdownBaby, solvedDays: firstSolvedDays)
        
        // add up counts to get the total decendant count of this "tree"
        let decendantCount = adultDecentdantCount + babyDecendantCount
        
        // tack on the solved count of the top level "dayOfBirth" day
        secondSolvedDays[dayOfBirth] = decendantCount
        
        return (decendantCount, secondSolvedDays)
    }
}

private func parseFishBirthCountdowns(fileName: String) -> [Int] {
    var fishBirthCountdowns = [Int]()
    
    let stringEntries = getFileContents(fileName: fileName).components(separatedBy: ",")
    
    for stringEntry in stringEntries {
        guard let intVal = Int(stringEntry.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            fatalError("\(#function): failed to cast to Int: \(stringEntry)")
        }
        fishBirthCountdowns.append(intVal)
    }
    
    return fishBirthCountdowns
}
