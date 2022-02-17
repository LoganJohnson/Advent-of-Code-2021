import Foundation

internal func performDay13A(file: String) -> Int {
    let (coordiantes, foldInstructions) = parseCoordiantesAndFoldInstructions(file: file)
    
    return solveDay13A(coordinates: coordiantes, foldInstructions: foldInstructions)
}

internal func performDay13B(file: String) -> Int {
    let (coordiantes, foldInstructions) = parseCoordiantesAndFoldInstructions(file: file)
    
    return solveDay13B(coordinates: coordiantes, foldInstructions: foldInstructions)
}

private func solveDay13A(coordinates: [Coordinate], foldInstructions: [FoldInstruction]) -> Int {
    let firstFoldInstruction = foldInstructions[0]
    
    let newCoordinates = processFold(coordinates: coordinates, foldInstruction: firstFoldInstruction)
    
    return Set(newCoordinates).count
}

private func solveDay13B(coordinates: [Coordinate], foldInstructions: [FoldInstruction]) -> Int {
    var modifiedCoordinates = coordinates
    
    for foldInstruction in foldInstructions {
        modifiedCoordinates = processFold(coordinates: modifiedCoordinates, foldInstruction: foldInstruction)
    }
    
    let sortedXValues = modifiedCoordinates.sorted(by: { $0.x < $1.x })
    guard let smallestX = sortedXValues.first?.x else { return -1 }
    guard let largestX = sortedXValues.last?.x else { return -1 }
    
    let sortedYValues = modifiedCoordinates.sorted(by: { $0.y < $1.y })
    guard let smallestY = sortedYValues.first?.y else { return -1 }
    guard let largestY = sortedYValues.last?.y else { return -1 }
    
    for yVal in smallestY...largestY {
        var rowOutput = ""
        
        for xVal in smallestX...largestX {
            let testCoord = Coordinate(x: xVal, y: yVal)
            
            if modifiedCoordinates.contains(testCoord) {
                rowOutput += "X"
            } else {
                rowOutput += "."
            }
        }
        print(rowOutput)
    }
    
    return modifiedCoordinates.count
}

private struct Coordinate: Hashable {
    var x: Int
    var y: Int
}

private struct FoldInstruction {
    var alongXAxis: Bool
    var value: Int
}

private func processFold(coordinates: [Coordinate], foldInstruction: FoldInstruction) -> [Coordinate] {
    var postFoldCoordiantes = [Coordinate]()
    
    for coordinate in coordinates {
        if foldInstruction.alongXAxis {
            // horizontal fold
            if coordinate.x < foldInstruction.value {
                postFoldCoordiantes.append(coordinate)
            } else {
                let newX = foldInstruction.value - (coordinate.x - foldInstruction.value)
                postFoldCoordiantes.append(Coordinate(x: newX, y: coordinate.y))
            }
        } else {
            // vertical fold
            if coordinate.y < foldInstruction.value {
                postFoldCoordiantes.append(coordinate)
            } else {
                let newY = foldInstruction.value - (coordinate.y - foldInstruction.value)
                postFoldCoordiantes.append(Coordinate(x: coordinate.x, y: newY))
            }
        }
    }
    
    return postFoldCoordiantes
}

private func parseCoordiantesAndFoldInstructions(file: String) -> ([Coordinate], [FoldInstruction]) {
    // input "sections" are separated by a blank line
    let inputSections = getFileContents(file: file).components(separatedBy: "\n\n")
    
    guard inputSections.count == 2 else {
        fatalError("\(#function) inputSections should have count of 2, instead got: \(inputSections.count)")
    }
    
    let coordinates = getCoordinates(inputString: inputSections[0])
    let foldInstructions = getFoldInstructions(inputString: inputSections[1])
    
    return (coordinates, foldInstructions)
}

private func getCoordinates(inputString: String) -> [Coordinate] {
    var coordinates = [Coordinate]()
    
    for stringEntry in inputString.components(separatedBy: .newlines) {
        if stringEntry.isEmpty { continue }
        
        let components = stringEntry.components(separatedBy: ",")
        
        guard let xPoint = Int(components[0]) else {
            fatalError("\(#function) failed to cast x \(components[0]) to an int")
        }
        
        guard let yPoint = Int(components[1]) else {
            fatalError("\(#function) failed to cast y \(components[1]) to an int")
        }
        
        coordinates.append(Coordinate(x: xPoint, y: yPoint))
    }
    
    return coordinates
}

private func getFoldInstructions(inputString: String) -> [FoldInstruction] {
    var foldInstructions = [FoldInstruction]()
    
    for stringEntry in inputString.components(separatedBy: .newlines) {
        if stringEntry.isEmpty { continue }
        
        let trimmedString = stringEntry.replacingOccurrences(of: "fold along ", with: "")
        
        let components = trimmedString.components(separatedBy: "=")
        
        guard let foldValue = Int(components[1]) else {
            fatalError("\(#function) failed to cast fold value \(components[1]) to an int")
        }
        
        foldInstructions.append(FoldInstruction(alongXAxis: components[0] == "x", value: foldValue))
    }
    
    return foldInstructions
}
