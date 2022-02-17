import Foundation

private enum SyntaxSymbolClosures: String {
    case closingParen = ")"
    case closingSquare = "]"
    case closingCurly = "}"
    case closingCarrot = ">"
    
    var invalidPoints: Int {
        switch self {
            case .closingParen: return 3
            case .closingSquare: return 57
            case .closingCurly: return 1197
            case .closingCarrot: return 25137
        }
    }
    
    var completionPoints: Int {
        switch self {
            case .closingParen: return 1
            case .closingSquare: return 2
            case .closingCurly: return 3
            case .closingCarrot: return 4
        }
    }
}

private enum SyntaxSymbolOpenings: String {
    case openingParen = "("
    case openingSquare = "["
    case openingCurly = "{"
    case openingCarrot = "<"

    var matchingClosure: SyntaxSymbolClosures {
        switch self {
            case .openingParen: return .closingParen
            case .openingSquare: return .closingSquare
            case .openingCurly: return .closingCurly
            case .openingCarrot: return .closingCarrot
        }
    }
}

// https://adventofcode.com/2021/day/10
internal func performDay10A(file: String) -> Int {
    solveDay10A(lineInputs: parseInputToStrings(file: file))
}

// https://adventofcode.com/2021/day/10#part2
internal func performDay10B(file: String) -> Int {
    solveDay10B(lineInputs: parseInputToStrings(file: file))
}

private func solveDay10A(lineInputs: [String]) -> Int {
    var totalPoints = 0
    
    for lineInput in lineInputs {
        totalPoints += getInvalidPoints(lineInput: lineInput)
    }
    
    return totalPoints
}

private func solveDay10B(lineInputs: [String]) -> Int {
    var pointsArray = [Int]()
    
    for lineInput in lineInputs {
        let points = getCompletionPoints(lineInput: lineInput)
        if points > 0 {
            pointsArray.append(points)
        }
    }
    
    return pointsArray.sorted()[pointsArray.count / 2] // return just the middle value
}

private func getInvalidPoints(lineInput: String) -> Int {
    var openingSymbols = [SyntaxSymbolOpenings]()
    
    for char in lineInput {
        if let openingSymbol = SyntaxSymbolOpenings(rawValue: String(char)) {
            openingSymbols.append(openingSymbol)
            continue
        }
        
        guard let closingSymbol = SyntaxSymbolClosures(rawValue: String(char)) else {
            fatalError("symbol was neither opening or closing, rawValue: \(char)")
        }
        
        guard let lastOpeningSymbol = openingSymbols.last else {
            fatalError("tried getting the last opening symbol and there was none")
        }
        
        if closingSymbol == lastOpeningSymbol.matchingClosure {
            openingSymbols.removeLast()
        } else {
            return closingSymbol.invalidPoints
        }
    }
    
    return 0
}

private func getCompletionPoints(lineInput: String) -> Int {
    var openingSymbols = [SyntaxSymbolOpenings]()
    
    for char in lineInput {
        if let openingSymbol = SyntaxSymbolOpenings(rawValue: String(char)) {
            openingSymbols.append(openingSymbol)
            continue
        }
        
        guard let closingSymbol = SyntaxSymbolClosures(rawValue: String(char)) else {
            fatalError("symbol was neither opening or closing, rawValue: \(char)")
        }
        
        guard let lastOpeningSymbol = openingSymbols.last else {
            fatalError("tried getting the last opening symbol and there was none")
        }
        
        if closingSymbol == lastOpeningSymbol.matchingClosure {
            openingSymbols.removeLast()
        } else {
            return 0 // line is corrupt, immediately bail
        }
    }
    
    // reversed so that outermost completions are at the end
    let completionSymbols = openingSymbols.reversed().map({ $0.matchingClosure })
    
    return scoreCompletionSymbols(symbols: completionSymbols)
}

private func scoreCompletionSymbols(symbols: [SyntaxSymbolClosures]) -> Int {
    var totalPoints = 0
    
    for symbol in symbols {
        totalPoints *= 5
        totalPoints += symbol.completionPoints
    }
    
    return totalPoints
}
