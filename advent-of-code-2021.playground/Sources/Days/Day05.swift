import Foundation

private struct VentLineDetail {
    var x1, y1, x2, y2: Int
}

// https://adventofcode.com/2021/day/5
internal func performDay5A(file: String) -> Int {
    solveDay5A(ventLineDetails: parseVentDetails(file: file))
}

// https://adventofcode.com/2021/day/5#part2
internal func performDay5B(file: String) -> Int {
    solveDay5B(ventLineDetails: parseVentDetails(file: file))
}

private func solveDay5A(ventLineDetails: [VentLineDetail]) -> Int {
    getHeavyVentCount(ventLineDetails: ventLineDetails, countDiagonals: false)
}

private func solveDay5B(ventLineDetails: [VentLineDetail]) -> Int {
    getHeavyVentCount(ventLineDetails: ventLineDetails, countDiagonals: true)
}

private func getHeavyVentCount(ventLineDetails: [VentLineDetail], countDiagonals: Bool) -> Int {
    var ventDicitonary = [String: Int]()
    
    for detail in ventLineDetails {
        if detail.x1 == detail.x2 {
            // handle vertical vent lines
            let minY = min(detail.y1, detail.y2)
            let maxY = max(detail.y1, detail.y2)
            
            for yCoord in minY ... maxY {
                ventDicitonary["\(detail.x1)-\(yCoord)", default: 0] += 1
            }
        } else if detail.y1 == detail.y2 {
            // handle horizontal vent lines
            let minX = min(detail.x1, detail.x2)
            let maxX = max(detail.x1, detail.x2)
            
            for xCoord in minX ... maxX {
                ventDicitonary["\(xCoord)-\(detail.y1)", default: 0] += 1
            }
        } else if countDiagonals {
            // handle diagonal vent lines (assumes 45 degree angle)
            var xCoord = detail.x1
            var yCoord = detail.y1
            
            let shouldIncrementX = detail.x1 < detail.x2
            let shouldIncrementY = detail.y1 < detail.y2
            
            while true {
                ventDicitonary["\(xCoord)-\(yCoord)", default: 0] += 1
                
                if xCoord == detail.x2 { break }
                
                xCoord += shouldIncrementX ? 1 : -1
                yCoord += shouldIncrementY ? 1 : -1
            }
        }
    }
    
    // only count vent values greater than 1
    return ventDicitonary.filter({ $0.value > 1 }).count
}

private func parseVentDetails(file: String) -> [VentLineDetail] {
    var ventLineDetails = [VentLineDetail]()
    
    let stringEntries = getFileContents(file: file).components(separatedBy: .newlines)
    
    for stringEntry in stringEntries {
        if stringEntry.isEmpty { continue }
        
        let coordinatePairs = stringEntry.components(separatedBy: " -> ")        
        let firstCoordinatePair = coordinatePairs[0].components(separatedBy: ",")
        let secondCoordinatePair = coordinatePairs[1].components(separatedBy: ",")
        
        let ventLineDetail = VentLineDetail(x1: Int(firstCoordinatePair[0]) ?? 0,
                                            y1: Int(firstCoordinatePair[1]) ?? 0,
                                            x2: Int(secondCoordinatePair[0]) ?? 0,
                                            y2: Int(secondCoordinatePair[1]) ?? 0)
        
        ventLineDetails.append(ventLineDetail)
    }
    
    return ventLineDetails
}
