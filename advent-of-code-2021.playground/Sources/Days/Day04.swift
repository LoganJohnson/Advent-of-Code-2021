import Foundation

internal func performDay4A(fileName: String) -> Int {
    let (callNumbers, boards) = parseBingoInput(fileName: fileName)
    
    return getDay4A(callNumbers: callNumbers, boards: boards)
}

internal func performDay4B(fileName: String) -> Int {
    let (callNumbers, boards) = parseBingoInput(fileName: fileName)
    
    return getDay4B(callNumbers: callNumbers, boards: boards)
}

// https://adventofcode.com/2021/day/4
// determine the board that wins first, answer is (winning number * sum of uncalled numbers on board)
private func getDay4A(callNumbers: [Int], boards: [[Set<Int>]]) -> Int {
    let (winningNumber, calledNumbers, winningBoard) = getWinningBoard(callNumbers: callNumbers, boards: boards)
    
    let uncalledNumberSum = getSumOfUncalledNumbers(calledNumbers: calledNumbers, board: winningBoard)
    
    return winningNumber * uncalledNumberSum
}

// https://adventofcode.com/2021/day/4#part2
// determine the board that wins last, answer is (winning number * sum of uncalled numbers on board)
private func getDay4B(callNumbers: [Int], boards: [[Set<Int>]]) -> Int {
    let (winningNumber, calledNumbers, winningBoard) = getLastWinningBoard(callNumbers: callNumbers, boards: boards)
    
    let uncalledNumberSum = getSumOfUncalledNumbers(calledNumbers: calledNumbers, board: winningBoard)
    
    return winningNumber * uncalledNumberSum
}

private func parseBingoInput(fileName: String) -> ([Int], [[Set<Int>]])  {
    let contentsOfFile = getFileContents(fileName: fileName)
    
    var callNumbers = [Int]()
    var boardRows = [[Set<Int>]]()
    
    var inProgressBoardRows = [String]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        if callNumbers.isEmpty {
            for stringCallNumber in stringComponent.components(separatedBy: ",") {
                guard let intValue = Int(stringCallNumber) else {
                    fatalError("stringCallNumber failed to parse: \(stringCallNumber)")
                }
                callNumbers.append(intValue)
            }
        } else {
            // blank line with in progress board rows triggers a board create
            if stringComponent.isEmpty && !inProgressBoardRows.isEmpty {
                boardRows.append(createBoardRows(stringRows: inProgressBoardRows))
                inProgressBoardRows.removeAll()
            } else if !stringComponent.isEmpty {
                inProgressBoardRows.append(stringComponent.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        }
    }
    
    // make sure to create the last board, there is not blank line to trigger this one
    if !inProgressBoardRows.isEmpty {
        boardRows.append(createBoardRows(stringRows: inProgressBoardRows))
    }
    
    return (callNumbers, boardRows)
}

// Converts an array of whitespace separated string numbers into an array of Set<Int>
private func createBoardRows(stringRows: [String]) -> [Set<Int>] {
    // need to create arrays first to be able to build vertical row sets below
    var horizontalBoardArrays = [[Int]]()
    for stringRow in stringRows {
        var row = [Int]()
        for stringVal in stringRow.components(separatedBy: .whitespaces) {
            if stringVal.isEmpty { continue }
            
            guard let intValue = Int(stringVal) else {
                fatalError("createBoard failed to cast to int: \(stringVal)")
            }
            
            row.append(intValue)
        }
        horizontalBoardArrays.append(row)
    }
    
    var boardSets = [Set<Int>]()
    
    // build horizontal row sets
    for horizontalBoard in horizontalBoardArrays {
        boardSets.append(Set(horizontalBoard))
    }
    
    // build vertical row sets
    for index in 0..<horizontalBoardArrays.count {
        boardSets.append(Set(horizontalBoardArrays.map({ $0[index] })))
    }
    
    return boardSets
}

private func getWinningBoard(callNumbers: [Int], boards: [[Set<Int>]]) -> (Int, Set<Int>, [Set<Int>]) {
    var calledNumbers = Set<Int>()
    
    for callNumber in callNumbers {
        calledNumbers.insert(callNumber)
        for board in boards {
            if boardHasWon(calledNumbers: calledNumbers, board: board) {
                return (callNumber, calledNumbers, board)
            }
        }
    }
    
    fatalError("\(#function), should have found a winning board")
}

private func getLastWinningBoard(callNumbers: [Int], boards: [[Set<Int>]]) -> (Int, Set<Int>, [Set<Int>]) {
    var lastWinningBoard = [Set<Int>]()
    var lastWinningCalledNumbers = Set<Int>()
    var lastWinningNumber = 0
    
    for board in boards {
        // Just pass in 1 board at a time to always get the winning info for that single board
        let (winningNumber, calledNumbers, _) = getWinningBoard(callNumbers: callNumbers, boards: [board])
        
        if lastWinningCalledNumbers.count < calledNumbers.count {
            lastWinningBoard = board
            lastWinningCalledNumbers = calledNumbers
            lastWinningNumber = winningNumber
        }
    }
    
    return (lastWinningNumber, lastWinningCalledNumbers, lastWinningBoard)
}

private func boardHasWon(calledNumbers: Set<Int>, board: [Set<Int>]) -> Bool {
    // short circuit early checks
    guard calledNumbers.count >= 5 else { return false }
    
    for boardRow in board {
        if boardRow.isSubset(of: calledNumbers) {
            return true
        }
    }
    
    return false
}

private func getSumOfUncalledNumbers(calledNumbers: Set<Int>, board: [Set<Int>]) -> Int {
    var uncalledNumberSum = 0

    for boardRow in board {
        for rowNumber in boardRow where !calledNumbers.contains(rowNumber) {
            uncalledNumberSum += rowNumber
        }
    }
    
    // divide by 2 because "board" contains both vertical and horizontal rows
    // (all numbers are double represented in the board array of sets)
    return uncalledNumberSum / 2
}
