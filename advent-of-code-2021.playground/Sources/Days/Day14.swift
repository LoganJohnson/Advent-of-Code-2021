import Foundation

// https://adventofcode.com/2021/day/14
internal func performDay14A(file: String) -> Int {
    let (template, pairInsertionRules) = parseTemplateAndPairInsertions(file: file)
    
    return solveDay14A(template: template, pairInsertionRules: pairInsertionRules)
}

// https://adventofcode.com/2021/day/14#part2
internal func performDay14B(file: String) -> Int {
    let (template, pairInsertionRules) = parseTemplateAndPairInsertions(file: file)
    
    return solveDay14B(template: template, pairInsertionRules: pairInsertionRules)
}

private func solveDay14A(template: String, pairInsertionRules: [PairInsertionRule]) -> Int {
    var modifiedTemplate = template
    
    for _ in 1...10 {
        modifiedTemplate = processPolymerStep(startingTemplate: modifiedTemplate, pairInsertionRules: pairInsertionRules)
    }
    
    return getAnswerFromTemplate(template: modifiedTemplate)
}

private func solveDay14B(template: String, pairInsertionRules: [PairInsertionRule]) -> Int {
    var modifiedTemplate = template
    
    for _ in 1...40 {
        modifiedTemplate = processPolymerStep(startingTemplate: modifiedTemplate, pairInsertionRules: pairInsertionRules)
    }
    
    return getAnswerFromTemplate(template: modifiedTemplate)
}

private func getAnswerFromTemplate(template: String) -> Int {
    let occurenceMap = getCharOccurenceMap(template: template)
    
    let charCounts = occurenceMap.map({ $0.value }).sorted(by: <)
    let mostCommonCharCount = charCounts.last ?? 0
    let leastCommonCharCount = charCounts.first ?? 0
    
    return mostCommonCharCount - leastCommonCharCount
}

private func processPolymerStep(startingTemplate: String, pairInsertionRules: [PairInsertionRule]) -> String {
    var endTemplate = ""
    
    for (index, char) in startingTemplate.enumerated() {
        endTemplate += String(char)
        
        if index == startingTemplate.count - 1 {
            break
        }
        
        let pair = "\(char)\(startingTemplate[index + 1])"
        
        guard let pairInsertionRule = pairInsertionRules.filter({ $0.pair == pair }).first else {
            fatalError("\(#function) failed to find rule for pair: \(pair)")
        }
        
        endTemplate += pairInsertionRule.insertion
    }
    
    return endTemplate
}

private func getCharOccurenceMap(template: String) -> [String: Int] {
    var occurenceMap = [String: Int]()
    
    for char in template {
        occurenceMap[String(char), default: 0] += 1
    }
    
    return occurenceMap
}

private struct PairInsertionRule {
    let pair: String
    let insertion: String
}

private func parseTemplateAndPairInsertions(file: String) -> (String, [PairInsertionRule]) {
    // input "sections" are separated by a blank line
    let inputSections = getFileContents(file: file).components(separatedBy: "\n\n")
    
    guard inputSections.count == 2 else {
        fatalError("\(#function) inputSections should have count of 2, instead got: \(inputSections.count)")
    }
    
    let template = inputSections[0]
    let pairInsertionRules = getPairInsertionRules(inputString: inputSections[1])
    
    return (template, pairInsertionRules)
}

private func getPairInsertionRules(inputString: String) -> [PairInsertionRule] {
    var pairInsertionRules = [PairInsertionRule]()
    
    for stringEntry in inputString.components(separatedBy: .newlines) {
        if stringEntry.isEmpty { continue }
        
        let components = stringEntry.components(separatedBy: " -> ")
        
        pairInsertionRules.append(PairInsertionRule(pair: components[0], insertion: components[1]))
    }
    
    return pairInsertionRules
}
