import Foundation

// Assumes input is a single int on each line
func parseInputToInts(fileName: String) -> [Int] {
    guard let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
        fatalError("failed to load bundleURL from fileName: \(fileName)")
    }

    guard let contentsOfFile = try? String(contentsOfFile: bundleURL.path, encoding: .utf8) else {
        fatalError("failed to parse content of file: \(bundleURL.path)")
    }
    
    var inputInts = [Int]()
    
    for stringComponent in contentsOfFile.components(separatedBy: .newlines) {
        guard let intValue = Int(stringComponent) else { continue }
        inputInts.append(Int(intValue))
    }
    
    return inputInts
}

func executeAnswer(operation: ([Int]) -> Int, input: [Int]) {
    let startTime = Date()
    
    print("Answer: \(operation(input)) : \(Date().timeIntervalSince(startTime))")
}
