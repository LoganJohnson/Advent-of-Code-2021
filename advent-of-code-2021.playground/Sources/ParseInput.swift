import Foundation

internal func getFileContents(fileName: String) -> String {
    guard let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
        fatalError("failed to load bundleURL from fileName: \(fileName)")
    }
    
    guard let contentsOfFile = try? String(contentsOfFile: bundleURL.path, encoding: .utf8) else {
        fatalError("failed to parse content of file: \(bundleURL.path)")
    }
    
    return contentsOfFile
}

// Assumes input is a single string on each line
internal func parseInputToStrings(fileName: String) -> [String] {
    let contentsOfFile = getFileContents(fileName: fileName)
    
    var stringInputs = [String]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        if stringComponent.isEmpty { continue }
        
        stringInputs.append(stringComponent)
    }
    
    return stringInputs
}

// Assumes input is a single int on each line
func parseInputToInts(fileName: String) -> [Int] {
    let contentsOfFile = getFileContents(fileName: fileName)
    
    var inputInts = [Int]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        guard let intValue = Int(stringComponent) else { continue }
        inputInts.append(Int(intValue))
    }
    
    return inputInts
}

func parseInputToStringAndInt(fileName: String) -> [(String, Int)] {
    let contentsOfFile = getFileContents(fileName: fileName)
    
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
