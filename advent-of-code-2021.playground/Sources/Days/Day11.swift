import Foundation

// https://adventofcode.com/2021/day/11
internal func performDay11A(file: String) -> Int {
    solveDay11A(intGrid: parseIntGrid(file: file))
}

// https://adventofcode.com/2021/day/11#part2
internal func performDay11B(file: String) -> Int {
    solveDay11B(intGrid: parseIntGrid(file: file))
}

// find flash count over 100 steps of incrementing values and "flashing" once a position reaches a high enough energy value
private func solveDay11A(intGrid: [[Int]]) -> Int {
    var flashDictionary = createFlashDicitonary(intGrid: intGrid)
    
    var totalFlashes = 0
    
    for _ in 1...100 {
        // increment all positions
        flashDictionary = incrementFlashDictionary(flashDictionary)
        // resolve all flashes this step
        flashDictionary = resolveFlashes(flashDictionary)
        // add up all flashes that occured this step
        totalFlashes += getFlashCount(flashDictionary: flashDictionary)
    }
    
    return totalFlashes
}

// find the first step where all values in grid are "flashing" at the same time
private func solveDay11B(intGrid: [[Int]]) -> Int {
    var flashDictionary = createFlashDicitonary(intGrid: intGrid)
    
    let totalPositionCount = flashDictionary.count
    
    var step = 1
    
    while true {
        flashDictionary = incrementFlashDictionary(flashDictionary)
        flashDictionary = resolveFlashes(flashDictionary)
        
        if totalPositionCount == getFlashCount(flashDictionary: flashDictionary) {
            return step
        }
        step += 1
    }
}

private struct Coordinate: Hashable {
    var x: Int
    var y: Int
    
    var adjacentCoordinates: [Coordinate] {
        var adjacentCoordinates = [Coordinate]()
        
        for i in -1...1 {
            for j in -1...1 {
                if i == 0 && j == 0 {
                    // skip current coordinate
                    continue
                }
                adjacentCoordinates.append(Coordinate(x: x+i, y: y+j))
            }
        }
        
        return adjacentCoordinates
    }
}

// converts a 2D array of ints in to a dictionary of [Coordinate: Int]
// the dictionary is used for easier determining of valid adjacent positions
private func createFlashDicitonary(intGrid: [[Int]]) -> [Coordinate: Int] {
    var flashDictionary = [Coordinate: Int]()
    
    for (i, row) in intGrid.enumerated() {
        for (j, intVal) in row.enumerated() {
            flashDictionary[Coordinate(x: i, y: j)] = intVal
        }
    }
    
    return flashDictionary
}

// increment each int value by 1
private func incrementFlashDictionary(_ flashDictionary: [Coordinate: Int]) -> [Coordinate: Int] {
    var modifiedFlashDictionary = flashDictionary
    
    for (key, value) in modifiedFlashDictionary {
        if value == -1 {
            // -1 means the position "flashed" last step, this brings it back up to energy level 1 (instead of 0)
            modifiedFlashDictionary[key] = 1
        } else {
            modifiedFlashDictionary[key] = value + 1
        }
    }
    
    return modifiedFlashDictionary
}

// finds values greater than 9 and performs "flashes"
// which increment all adjacent values by 1
private func resolveFlashes(_ flashDictionary: [Coordinate: Int]) -> [Coordinate: Int] {
    var modifiedFlashDictionary = flashDictionary
    
    var aFlashHasOccurred = false
    
    for (key, value) in modifiedFlashDictionary {
        if value > 9 {
            // resolve the flash, set value to -1 and increment all adjacent values
            aFlashHasOccurred = true
            modifiedFlashDictionary[key] = -1
            
            for adjacentCoord in key.adjacentCoordinates {
                if let adjacentValue = modifiedFlashDictionary[adjacentCoord] {
                    if adjacentValue == -1 {
                        // adjacent position has already flashed this step, skip
                        continue
                    } else {
                        modifiedFlashDictionary[adjacentCoord] = adjacentValue + 1
                    }
                }
            }
        }
    }
    
    if aFlashHasOccurred {
        return resolveFlashes(modifiedFlashDictionary)
    } else {
        return modifiedFlashDictionary
    }
}

// returns the count of all positions that are currently "flashing" AKA value -1
private func getFlashCount(flashDictionary: [Coordinate: Int]) -> Int {
    flashDictionary.filter({ $0.value == -1 }).count
}
