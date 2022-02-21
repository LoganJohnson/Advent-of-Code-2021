import Foundation

// https://adventofcode.com/2021/day/15
internal func performDay15A(file: String) -> Int {
    solveDay15A(intGrid: parseIntGrid(file: file))
}

// https://adventofcode.com/2021/day/15#part2
internal func performDay15B(file: String) -> Int {
    solveDay15B(intGrid: parseIntGrid(file: file))
}

private func solveDay15A(intGrid: [[Int]]) -> Int {
    let startCoord = Coordinate(x: 0, y: 0)
    let endCoord = determineEndCoordinate(intGrid: intGrid)
    let coordGrid = createCoordGrid(intGrid: intGrid)
    
    return getMinRiskTotal(startCoord: startCoord, endCoord: endCoord, grid: coordGrid)
}

private func solveDay15B(intGrid: [[Int]]) -> Int {
    let scale = 5
    
    let startCoord = Coordinate(x: 0, y: 0)
    let endCoord = determineEndCoordinate(intGrid: intGrid, scale: scale)

    let expandedGrid = expandCoordGrid(originalCoordGrid: createCoordGrid(intGrid: intGrid),
                                       originalSize: intGrid.count,
                                       scale: scale)

    return getMinRiskTotal(startCoord: startCoord, endCoord: endCoord, grid: expandedGrid)
}

private struct Coordinate: Hashable {
    var x: Int
    var y: Int
    
    // only adjacents we care about are right/bottom
    var adjacentCoordinates: [Coordinate] {
        [
            Coordinate(x: x - 1, y: y), // left
            Coordinate(x: x, y: y - 1), // top
            Coordinate(x: x + 1, y: y), // right
            Coordinate(x: x, y: y + 1), // bottom
        ]
    }
}

private func createCoordGrid(intGrid: [[Int]]) -> [Coordinate: Int] {
    var coordGrid = [Coordinate: Int]()
    
    for (y, row) in intGrid.enumerated() {
        for (x, intVal) in row.enumerated() {
            coordGrid[Coordinate(x: x, y: y)] = intVal
        }
    }
    
    return coordGrid
}

private func determineEndCoordinate(intGrid: [[Int]], scale: Int = 1) -> Coordinate {
    guard let lastX = intGrid.first?.count else {
        fatalError("\(#function): empty intGrid")
    }
    
    let lastY = intGrid.count
    
    return Coordinate(x: lastX * scale - 1,
                      y: lastY * scale - 1)
}

private func getMinRiskTotal(startCoord: Coordinate, endCoord: Coordinate, grid: [Coordinate: Int]) -> Int {
    var minCosts = [Coordinate: Int]()
    var minCost: Int { minCosts[endCoord] ?? .max }
    
    var currentCoords: [Coordinate: Int] = [startCoord: 0]
    
    while let (coord, cost) = currentCoords.min(by: { $0.value < $1.value }) {
        currentCoords.removeValue(forKey: coord)
        
        guard cost < minCost else { continue }
        
        var adjacentCoords = coord.adjacentCoordinates
        if adjacentCoords.contains(endCoord) {
            adjacentCoords.removeAll(where: { $0 == endCoord })
            minCosts[endCoord] = min(minCost, cost + grid[endCoord]!)
        }
        
        adjacentCoords.forEach { adjacentCoord in
            guard let nextCoordCost = grid[adjacentCoord] else { return }
            
            let totalCost = cost + nextCoordCost
            if let previousCost = minCosts[adjacentCoord], previousCost <= totalCost { return }
            minCosts[adjacentCoord] = totalCost
            currentCoords[adjacentCoord] = totalCost
        }
    }
    
    return minCost
}

private func expandCoordGrid(originalCoordGrid: [Coordinate: Int], originalSize: Int, scale: Int) -> [Coordinate: Int] {
    var scaledCoordGrid = [Coordinate: Int]()
    
    for xScale in 0..<scale {
        for yScale in 0..<scale {
            for (key, value) in originalCoordGrid {
                let newCoord = Coordinate(x: originalSize * xScale + key.x,
                                          y: originalSize * yScale + key.y)
                
                var newValue = value + xScale + yScale
                if newValue > 9 {
                    newValue = newValue % 9
                }
                
                scaledCoordGrid[newCoord] = newValue
            }
        }
    }
    
    return scaledCoordGrid
}
