import Foundation

public func day4() {
    let (callNumbers, boards) = parseBingoInput(fileName: "day-4")
    
    let startTime = Date()
    let answer4A = getDay4A(callNumbers: callNumbers, boards: boards)
    
    print("Day4A : \(answer4A) : \(Date().timeIntervalSince(startTime).toMilliseconds)")
    
    let day4BStart = Date()
    let answer4B = getDay4B(callNumbers: callNumbers, boards: boards)
    print("Day4B : \(answer4B) : \(Date().timeIntervalSince(day4BStart).toMilliseconds)")
}

// https://adventofcode.com/2021/day/4
// determine the board that wins first, answer is (winning number * sum of uncalled numbers on board)
func getDay4A(callNumbers: [Int], boards: [[[Int]]]) -> Int {
    let (winningNumber, calledNumbers, winningBoard) = getWinningBoard(callNumbers: callNumbers, boards: boards)
    
    let uncalledNumberSum = getSumOfUncalledNumbers(calledNumbers: calledNumbers, board: winningBoard)
    
    return winningNumber * uncalledNumberSum
}

// https://adventofcode.com/2021/day/4#part2
// determine the board that wins last, answer is (winning number * sum of uncalled numbers on board)
func getDay4B(callNumbers: [Int], boards: [[[Int]]]) -> Int {
    let (winningNumber, calledNumbers, winningBoard) = getLastWinningBoard(callNumbers: callNumbers, boards: boards)
    
    let uncalledNumberSum = getSumOfUncalledNumbers(calledNumbers: calledNumbers, board: winningBoard)
    
    return winningNumber * uncalledNumberSum
}

private func parseBingoInput(fileName: String) -> ([Int], [[[Int]]])  {
    let contentsOfFile = getFileContents(fileName: fileName)
    
    var callNumbers = [Int]()
    var boards = [[[Int]]]()
    
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
                boards.append(createBoard(stringRows: inProgressBoardRows))
                inProgressBoardRows.removeAll()
            } else if !stringComponent.isEmpty {
                inProgressBoardRows.append(stringComponent.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        }
    }
    
    // make sure to create the last board, there is not blank line to trigger this one
    if !inProgressBoardRows.isEmpty {
        boards.append(createBoard(stringRows: inProgressBoardRows))
    }
    
    return (callNumbers, boards)
}

private func createBoard(stringRows: [String]) -> [[Int]] {
    var board = [[Int]]()
    
    for stringRow in stringRows {
        var boardRow = [Int]()
        for stringVal in stringRow.components(separatedBy: .whitespaces) {
            if stringVal.isEmpty { continue }
            
            guard let intValue = Int(stringVal) else {
                fatalError("createBoard failed to cast to int: \(stringVal)")
            }
            
            boardRow.append(intValue)
        }
        board.append(boardRow)
    }
    
    return board
}

private func getWinningBoard(callNumbers: [Int], boards: [[[Int]]]) -> (Int, [Int], [[Int]]) {
    var calledNumbers = [Int]()
    
    for callNumber in callNumbers {
        calledNumbers.append(callNumber)
        for board in boards {
            if boardHasWon(calledNumbers: calledNumbers, board: board) {
                return (callNumber, calledNumbers, board)
            }
        }
    }
    
    fatalError("getWinningInfo, should have found a winning board")
}

private func getLastWinningBoard(callNumbers: [Int], boards: [[[Int]]]) -> (Int, [Int], [[Int]]) {
    var lastWinningBoard = [[Int]]()
    var lastWinningCalledNumbers = [Int]()
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

private func boardHasWon(calledNumbers: [Int], board: [[Int]]) -> Bool {
    // short circuit early checks
    guard calledNumbers.count > 5 else { return false }
    
    // check horizontal rows
    for boardRow in board {
        if allNumbersCalledInRow(calledNumbers: calledNumbers, boardRowNumbers: boardRow) {
            return true
        }
    }
    
    // build vertical rows
    var verticalRows = [[Int]]()
    for index in 0..<board.count {
        verticalRows.append(board.map({ $0[index] }))
    }
    
    // check vertical rows
    for verticalRow in verticalRows {
        if allNumbersCalledInRow(calledNumbers: calledNumbers, boardRowNumbers: verticalRow) {
            return true
        }
    }
    
    return false
}

private func allNumbersCalledInRow(calledNumbers: [Int], boardRowNumbers: [Int]) -> Bool {
    for boardRowNumber in boardRowNumbers {
        if !calledNumbers.contains(boardRowNumber) {
            // At least one number has not been called yet
            return false
        }
    }
    
    return true
}

private func getSumOfUncalledNumbers(calledNumbers: [Int], board: [[Int]]) -> Int {
    var uncalledNumberSum = 0

    for boardRow in board {
        for rowNumber in boardRow {
            if !calledNumbers.contains(rowNumber) {
                uncalledNumberSum += rowNumber
            }
        }
    }
    
    return uncalledNumberSum
}
