import Foundation

// https://adventofcode.com/2021/day/14
internal func performDay14A(file: String) -> Int {
    let (firstLetter, lastLetter, initialPairCountDict, pairInsertionRules) = parsePairDictionaries(file: file)
    
    return solveDay14(days: 10,
                      firstLetter: firstLetter,
                      lastLetter: lastLetter,
                      initialPairCountDict: initialPairCountDict,
                      pairInsertionRules: pairInsertionRules)
}

// https://adventofcode.com/2021/day/14#part2
internal func performDay14B(file: String) -> Int {
    let (firstLetter, lastLetter, initialPairCountDict, pairInsertionRules) = parsePairDictionaries(file: file)
    
    return solveDay14(days: 40,
                      firstLetter: firstLetter,
                      lastLetter: lastLetter,
                      initialPairCountDict: initialPairCountDict,
                      pairInsertionRules: pairInsertionRules)
}

private func solveDay14(days: Int,
                        firstLetter: String,
                        lastLetter: String,
                        initialPairCountDict: [Pair: Int],
                        pairInsertionRules: [Pair: String]) -> Int {
    
    var modifiedPairCountDict = initialPairCountDict
    
    for _ in 1...days {
        modifiedPairCountDict = processPolymerStep(pairCountDict: modifiedPairCountDict, pairInsertionRules: pairInsertionRules)
    }
    
    return getAnswerFromPairCounts(firstLetter: firstLetter,
                                   lastLetter: lastLetter,
                                   pairCountDict: modifiedPairCountDict)
}

private func processPolymerStep(pairCountDict: [Pair: Int], pairInsertionRules: [Pair: String]) -> [Pair: Int] {
    var modifiedPairCountDict = [Pair: Int]()
    
    for (pair, pairCount) in pairCountDict {
        guard let valToInsert = pairInsertionRules[pair] else {
            fatalError("\(#function) no rule exists for pair: \(pair)")
        }
        
        if pairCount < 1 {
            continue // this is a pair that historically existed but has been "split apart" and no instances occur currently
        }
        
        let newLeftPair = Pair(leftVal: pair.leftVal, rightVal: valToInsert)
        let newRightPair = Pair(leftVal: valToInsert, rightVal: pair.rightVal)
        
        modifiedPairCountDict[newLeftPair, default: 0] += pairCount
        modifiedPairCountDict[newRightPair, default: 0] += pairCount
    }
    
    return modifiedPairCountDict
}

private func getAnswerFromPairCounts(firstLetter: String,
                                     lastLetter: String,
                                     pairCountDict: [Pair: Int]) -> Int {
    
    var letterOccurenceCount = [String: Int]()
    
    for (pair, value) in pairCountDict {
        letterOccurenceCount[pair.leftVal, default: 0] += value
        letterOccurenceCount[pair.rightVal, default: 0] += value
    }
    
    // first and last letters are not double counted exactly 1 time each...
    // this is a gross "pass through" solution but it works currently
    // if I think of something in the shower I'll change this
    letterOccurenceCount[firstLetter, default: 0] += 1
    letterOccurenceCount[lastLetter, default: 0] += 1
    
    // divided by 2 because each pair "double counts" each letter
    let charCounts = letterOccurenceCount.map({ $0.value / 2 }).sorted(by: <)
    
    let mostCommonCharCount = charCounts.last ?? 0
    let leastCommonCharCount = charCounts.first ?? 0
    
    return mostCommonCharCount - leastCommonCharCount
}

private struct Pair: Hashable {
    let leftVal: String
    let rightVal: String
    
    var display: String {
        "\(leftVal)\(rightVal)"
    }
}

// MARK: - Parsing and processing initial inputs

private func parsePairDictionaries(file: String) -> (String, String, [Pair: Int], [Pair: String]) {
    // input "sections" are separated by a blank line
    let inputSections = getFileContents(file: file).components(separatedBy: "\n\n")
    
    guard inputSections.count == 2 else {
        fatalError("\(#function) inputSections should have count of 2, instead got: \(inputSections.count)")
    }
    
    let (firstLetter, lastLetter, initialPairContDict) = getInitialPairCountDict(inputString: inputSections[0])
    let pairInsertionRules = getPairInsertionRules(inputString: inputSections[1])
    
    return (firstLetter, lastLetter, initialPairContDict, pairInsertionRules)
}

private func getInitialPairCountDict(inputString: String) -> (String, String, [Pair: Int]) {
    let firstLetter = String(inputString.first!)
    let lastLetter = String(inputString.last!)
    
    var pairCountDict = [Pair: Int]()
    
    // assumes single line imput string
    for (index, char) in inputString.enumerated() {
        if index == inputString.count - 1 {
            break
        }
        
        let pair = Pair(leftVal: String(char), rightVal: String(inputString[index + 1]))
        
        pairCountDict[pair, default: 0] += 1
    }
    
    return (firstLetter, lastLetter, pairCountDict)
}

private func getPairInsertionRules(inputString: String) -> [Pair: String] {
    var pairInsertionRules = [Pair: String]()
    
    for stringEntry in inputString.components(separatedBy: .newlines) {
        if stringEntry.isEmpty { continue }
        
        let components = stringEntry.components(separatedBy: " -> ")
        
        let pair = Pair(leftVal: String(components[0][0]),
                        rightVal: String(components[0][1]))
        
        pairInsertionRules[pair] = components[1]
    }
    
    return pairInsertionRules
}
