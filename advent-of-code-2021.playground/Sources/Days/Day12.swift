import Foundation

internal func performDay12A(fileName: String) -> Int {
    return solveDay12A(caveDict: parseCaveDict(fileName: fileName))
}

internal func performDay12B(fileName: String) -> Int {
    return solveDay12B(caveDict: parseCaveDict(fileName: fileName))
}

private func solveDay12A(caveDict: [Cave: Set<Cave>]) -> Int {
    let allSplunks = splunkA(currentCavePath: CavePath(path: [Cave(name: "start")], hasVisitedASmallTwice: false),
                             caveDict: caveDict)

    return allSplunks.count
}

private func solveDay12B(caveDict: [Cave: Set<Cave>]) -> Int {
    let allSplunks = splunkB(currentCavePath: CavePath(path: [Cave(name: "start")], hasVisitedASmallTwice: false),
                             caveDict: caveDict)
    
    return allSplunks.count
}

private struct CavePath {
    var path: [Cave]
    var hasVisitedASmallTwice: Bool
}

private struct Cave: Equatable, Hashable {
    let name: String
    let isSmall: Bool
    
    init(name: String) {
        self.name = name
        self.isSmall = name.lowercased() == name
    }
}

private func splunkA(currentCavePath: CavePath, caveDict: [Cave: Set<Cave>]) -> [CavePath] {
    guard let currentCave = currentCavePath.path.last else { return [CavePath]() }
    
    var allNewSplunks = [CavePath]()
    
    for linkedCave in caveDict[currentCave] ?? [] {
        if linkedCave.isSmall && currentCavePath.path.contains(linkedCave) {
            // already traversed this small cave, skip
        } else {
            var newCavePath = currentCavePath
            newCavePath.path.append(linkedCave)
            
            if linkedCave.name == "end" {
                allNewSplunks.append(newCavePath)
            } else {
                allNewSplunks.append(contentsOf: splunkA(currentCavePath: newCavePath, caveDict: caveDict))
            }
        }
    }
    
    return allNewSplunks
}

private func splunkB(currentCavePath: CavePath, caveDict: [Cave: Set<Cave>]) -> [CavePath] {
    guard let currentCave = currentCavePath.path.last else { return [CavePath]() }
    
    var allNewSplunks = [CavePath]()
    
    for linkedCave in caveDict[currentCave] ?? [] {
        if linkedCave.name == "start" { continue } // never visit start again
        
        if linkedCave.isSmall && currentCavePath.path.contains(linkedCave) {
            if currentCavePath.hasVisitedASmallTwice {
                // do nothing
            } else {
                var newCavePath = currentCavePath
                newCavePath.path.append(linkedCave)
                newCavePath.hasVisitedASmallTwice = true
                
                if linkedCave.name == "end" {
                    allNewSplunks.append(newCavePath)
                } else {
                    allNewSplunks.append(contentsOf: splunkB(currentCavePath: newCavePath, caveDict: caveDict))
                }
            }
        } else {
            var newCavePath = currentCavePath
            newCavePath.path.append(linkedCave)
            
            if linkedCave.name == "end" {
                allNewSplunks.append(newCavePath)
            } else {
                allNewSplunks.append(contentsOf: splunkB(currentCavePath: newCavePath, caveDict: caveDict))
            }
        }
    }
    
    return allNewSplunks
}

private func parseCaveDict(fileName: String) -> [Cave: Set<Cave>] {
    var caveDict = [Cave: Set<Cave>]()
    
    let stringEntries = getFileContents(fileName: fileName).components(separatedBy: .newlines)
    
    for stringEntry in stringEntries {
        if stringEntry.isEmpty { continue }
        
        let caveStrings = stringEntry.components(separatedBy: "-")
        
        let originCave = Cave(name: caveStrings[0])
        let destinationCave = Cave(name: caveStrings[1])
        
        caveDict[originCave, default: []].insert(destinationCave)
        caveDict[destinationCave, default: []].insert(originCave)
    }
    
    return caveDict
}
