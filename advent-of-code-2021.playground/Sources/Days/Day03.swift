import Foundation

internal func performDay3A() -> Int {
    return solveDay3A(inputs: parseInputToStrings(fileName: "day-3"))
}

internal func performDay3B() -> Int {
    return solveDay3B(inputs: parseInputToStrings(fileName: "day-3"))
}

private func solveDay3A(inputs: [String]) -> Int {
    if inputs.isEmpty {
        fatalError("getDay3A inputs are empty")
    }
    
    let bitLength = inputs[0].count
        
    var index = 0
    var gammaRate = ""
    var epsilonRate = ""
    
    while index < bitLength {
        var zeroValueCount = 0
        for input in inputs {
            if input[index] == "0" {
                zeroValueCount += 1
            }
        }
        
        // Gamma value takes most common bit value in position
        gammaRate.append(contentsOf: zeroValueCount < inputs.count / 2 ? "1" : "0")
        
        // Epsilon takes least common bit value in position
        epsilonRate.append(contentsOf: zeroValueCount < inputs.count / 2 ? "0" : "1")
        
        index += 1
    }
    
    let gammaDecimal = gammaRate.convertFromBinaryStringToInt
    let epsilonDecimal = epsilonRate.convertFromBinaryStringToInt
    
    return gammaDecimal * epsilonDecimal
}

private func solveDay3B(inputs: [String]) -> Int {
    if inputs.isEmpty {
        fatalError("getDay3B inputs are empty")
    }
    
    let oxygenGeneratorRating = getOxygenGeneratorRating(index: 0,
                                                         inputs: inputs,
                                                         keepMostCommon: true)
    let co2ScrubberRating = getOxygenGeneratorRating(index: 0,
                                                     inputs: inputs,
                                                     keepMostCommon: false)
    
    let oxygenGeneratorDecimal = oxygenGeneratorRating.convertFromBinaryStringToInt
    let co2ScrubberDecimal = co2ScrubberRating.convertFromBinaryStringToInt
    
    return oxygenGeneratorDecimal * co2ScrubberDecimal
}

func getOxygenGeneratorRating(index: Int, inputs: [String], keepMostCommon: Bool) -> String {
    if inputs.count == 1 {
        return inputs[0]
    }
    
    if index > inputs[0].count {
        fatalError("getOxygenGeneratorRating went too far on index: \(index), inputs: \(inputs)")
    }
    
    var zeroValueCount = 0
    var oneValueCount = 0
    for input in inputs {
        if input[index] == "0" {
            zeroValueCount += 1
        } else {
            oneValueCount += 1
        }
    }
    
    var valueToKeep = ""
    if keepMostCommon {
        // prefer 1 on a tie break
        valueToKeep = zeroValueCount <= oneValueCount ? "1" : "0"
    } else {
        // prefer 0 on a tie break
        valueToKeep = zeroValueCount <= oneValueCount ? "0" : "1"
    }
    
    var remainingInputs = [String]()
    
    for input in inputs {
        if "\(input[index])" == valueToKeep {
            remainingInputs.append(input)
        }
    }
    
    return getOxygenGeneratorRating(index: index + 1,
                                    inputs: remainingInputs,
                                    keepMostCommon: keepMostCommon)
}
