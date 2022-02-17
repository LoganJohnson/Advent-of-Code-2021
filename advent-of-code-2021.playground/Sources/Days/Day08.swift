import Foundation

private struct SevenSegmentDetail {
    let signalPatterns: [Set<Character>]
    let outputValues: [Set<Character>]
}

// https://adventofcode.com/2021/day/8
internal func performDay8A(file: String) -> Int {
    return solveDay8A(sevenSegmentDetails: parseSevenSegmentDetails(file: file))
}

// https://adventofcode.com/2021/day/8#part2
internal func performDay8B(file: String) -> Int {
    return solveDay8B(sevenSegmentDetails: parseSevenSegmentDetails(file: file))
}

private func solveDay8A(sevenSegmentDetails: [SevenSegmentDetail]) -> Int {
    var uniqueOutputCount = 0
    
    // values 1,4,7,8 have unique segment counts
    let uniqueSegmentCounts = Set([2, 3, 4, 7])
    
    for sevenSegmentDetail in sevenSegmentDetails {
        for outputValue in sevenSegmentDetail.outputValues {
            if uniqueSegmentCounts.contains(outputValue.count) {
                uniqueOutputCount += 1
            }
        }
    }
    
    return uniqueOutputCount
}

private func solveDay8B(sevenSegmentDetails: [SevenSegmentDetail]) -> Int {
    var outputTotal = 0
    
    for sevenSegmentDetail in sevenSegmentDetails {
        var deductionDict = [Int: Set<Character>]()
        
        // Get easy values (1, 7, 4, 8) based on segment count
        for signalPattern in sevenSegmentDetail.signalPatterns {
            switch signalPattern.count {
            case 2:
                deductionDict[1] = signalPattern
            case 3:
                deductionDict[7] = signalPattern
            case 4:
                deductionDict[4] = signalPattern
            case 7:
                deductionDict[8] = signalPattern
            default:
                continue // not enough info
            }
        }
        
        // figure out 9: count of 6 and contains all "4" chars and all "7" chars
        for signalPattern in sevenSegmentDetail.signalPatterns.filter({ $0.count == 6 }) {
            if deductionDict[4]!.isSubset(of: signalPattern) && deductionDict[7]!.isSubset(of: signalPattern) {
                deductionDict[9] = signalPattern
                break
            }
        }
        
        // figure out 6: count of 6, "1" is NOT a subset, does not equal the "9" set
        for signalPattern in sevenSegmentDetail.signalPatterns.filter({ $0.count == 6 }) {
            if !deductionDict[1]!.isSubset(of: signalPattern) && deductionDict[9]! != signalPattern {
                deductionDict[6] = signalPattern
                break
            }
        }
        
        // figure out 0: count of 6, does not equal "9" or "6" set
        for signalPattern in sevenSegmentDetail.signalPatterns.filter({ $0.count == 6 }) {
            if deductionDict[9]! != signalPattern && deductionDict[6]! != signalPattern {
                deductionDict[0] = signalPattern
                break
            }
        }
        
        // figure out 3: count of 5, "7" is a subset
        for signalPattern in sevenSegmentDetail.signalPatterns.filter({ $0.count == 5 }) {
            if deductionDict[7]!.isSubset(of: signalPattern) {
                deductionDict[3] = signalPattern
                break
            }
        }
        
        // figure out 5: count of 5, subset of "6" set
        for signalPattern in sevenSegmentDetail.signalPatterns.filter({ $0.count == 5 }) {
            if deductionDict[6]!.isSuperset(of: signalPattern) {
                deductionDict[5] = signalPattern
                break
            }
        }
        
        // figure out 2: count of 5, not equal to 3 or 5 sets
        for signalPattern in sevenSegmentDetail.signalPatterns.filter({ $0.count == 5 }) {
            if signalPattern != deductionDict[3]! && signalPattern != deductionDict[5]! {
                deductionDict[2] = signalPattern
                break
            }
        }
        
        outputTotal += getRealNumberValue(outputValues: sevenSegmentDetail.outputValues,
                                          deductionDictionary: deductionDict)
    }
    
    return outputTotal
}

private func getRealNumberValue(outputValues: [Set<Character>], deductionDictionary: [Int: Set<Character>]) -> Int {
    var stringNum = ""
    
    for outputValue in outputValues {
        for (key, value) in deductionDictionary {
            if outputValue == value {
                stringNum.append(String(key))
            }
        }
    }
    
    return Int(stringNum) ?? 0
}

private func parseSevenSegmentDetails(file: String) -> [SevenSegmentDetail] {
    var sevenSegmentDetails = [SevenSegmentDetail]()
    
    let stringEntries = getFileContents(file: file).components(separatedBy: .newlines)
    
    for stringEntry in stringEntries {
        if stringEntry.isEmpty { continue }
        
        let patternsAndOutputs = stringEntry.components(separatedBy: "|")
        let signalPatterns = patternsAndOutputs[0].components(separatedBy: .whitespaces).map({ Set($0) })
        let outputValues = patternsAndOutputs[1].components(separatedBy: .whitespaces).map({ Set($0) })
        
        sevenSegmentDetails.append(SevenSegmentDetail(signalPatterns: signalPatterns,
                                                      outputValues: outputValues))
    }
    
    return sevenSegmentDetails
}
