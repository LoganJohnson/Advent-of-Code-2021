import Foundation

internal func getFileContents(file: String) -> String {
    guard let bundleURL = Bundle.main.url(forResource: file, withExtension: "txt") else {
        fatalError("failed to load bundleURL from file: \(file)")
    }
    
    guard let contentsOfFile = try? String(contentsOfFile: bundleURL.path, encoding: .utf8) else {
        fatalError("failed to parse content of file: \(bundleURL.path)")
    }
    
    return contentsOfFile
}

// Assumes input is a single string on each line
internal func parseInputToStrings(file: String) -> [String] {
    let contentsOfFile = getFileContents(file: file)
    
    var stringInputs = [String]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        if stringComponent.isEmpty { continue }
        
        stringInputs.append(stringComponent)
    }
    
    return stringInputs
}

// Assumes input is a single int on each line
func parseInputToInts(file: String) -> [Int] {
    let contentsOfFile = getFileContents(file: file)
    
    var inputInts = [Int]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        guard let intValue = Int(stringComponent) else { continue }
        inputInts.append(Int(intValue))
    }
    
    return inputInts
}

func parseInputToStringAndInt(file: String) -> [(String, Int)] {
    let contentsOfFile = getFileContents(file: file)
    
    var inputs = [(String, Int)]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        guard !stringComponent.isEmpty else { continue }
        
        let splitUpStringArray = stringComponent.components(separatedBy: " ")
        
        let stringValue = splitUpStringArray[0]
        guard let intValue = Int(splitUpStringArray[1]) else {
            fatalError("failed to convert string to int: \(splitUpStringArray[1])")
        }
        
        inputs.append((stringValue, intValue))
    }
    
    return inputs
}

func parseInputCommaSeparatedInts(file: String) -> [Int] {
    var fishBirthCountdowns = [Int]()
    
    let stringEntries = getFileContents(file: file).components(separatedBy: ",")
    
    for stringEntry in stringEntries {
        guard let intVal = Int(stringEntry.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            fatalError("\(#function): failed to cast to Int: \(stringEntry)")
        }
        fishBirthCountdowns.append(intVal)
    }
    
    return fishBirthCountdowns
}

func parseIntGrid(file: String) -> [[Int]] {
    var intGrid = [[Int]]()
    
    let stringEntries = getFileContents(file: file).components(separatedBy: .newlines)
    
    for stringEntry in stringEntries {
        if stringEntry.isEmpty { continue }
        var gridRow = [Int]()
        
        for char in stringEntry {
            guard let intVal = Int(String(char)) else {
                fatalError("\(#function), Failed to parse char: \(char)")
            }
            gridRow.append(intVal)
        }
        
        intGrid.append(gridRow)
    }
    
    return intGrid
}
