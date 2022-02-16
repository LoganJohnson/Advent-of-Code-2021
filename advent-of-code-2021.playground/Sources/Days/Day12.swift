import Foundation

internal func performDay12A(fileName: String) -> Int {
    return solveDay12A(caveLinks: parseCaveLinks(fileName: fileName))
}

private func solveDay12A(caveLinks: [CaveLink]) -> Int {
    let allSplunks = splunk(currentCavePath: [Cave(name: "start")], caveLinks: caveLinks)
    
//    for splunk in allSplunks {
//        print(splunk.map({ $0.name }).joined(separator: ","))
//    }
    
    return allSplunks.count
}

private struct CaveLink {
    let origin: Cave
    let destination: Cave
}

private struct Cave: Equatable {
    let name: String
    
    var isSmall: Bool {
        name.lowercased() == name
    }
}

private func splunk(currentCavePath: [Cave], caveLinks: [CaveLink]) -> [[Cave]] {
    guard let currentCave = currentCavePath.last else { return [[Cave]]() }
    
    let destinationCaves = caveLinks.filter({ $0.origin == currentCave }).map({ $0.destination })
    let originCaves = caveLinks.filter({ $0.destination == currentCave }).map({ $0.origin })
    let nextCaves = destinationCaves + originCaves
    
    var allNewSplunks = [[Cave]]()
    
    for nextCave in nextCaves {
        if nextCave.isSmall && currentCavePath.contains(nextCave) {
            // we have already been to this small cave, not a valid path
        } else {
            var newCavePath = currentCavePath
            newCavePath.append(nextCave)
            
            if nextCave.name == "end" {
                allNewSplunks.append(newCavePath)
            } else {
                allNewSplunks.append(contentsOf: splunk(currentCavePath: newCavePath, caveLinks: caveLinks))
            }
        }
    }
    
    return allNewSplunks
}

private func parseCaveLinks(fileName: String) -> [CaveLink] {
    var caveLinks = [CaveLink]()
    
    let stringEntries = getFileContents(fileName: fileName).components(separatedBy: .newlines)
    
    for stringEntry in stringEntries {
        if stringEntry.isEmpty { continue }
        
        let caves = stringEntry.components(separatedBy: "-")
        caveLinks.append(CaveLink(origin: Cave(name: caves[0]),
                                  destination: Cave(name: caves[1])))
    }
    
    return caveLinks
}
