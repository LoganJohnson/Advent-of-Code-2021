import Foundation

struct VentLineDetail {
    var x1, y1, x2, y2: Int
}

internal func performDay5A() -> Int {
    solveDay5A(ventLineDetails: parseVentDetails(fileName: "day-5"))
}

private func solveDay5A(ventLineDetails: [VentLineDetail]) -> Int {
    var ventDicitonary = [String: Int]()
    
    for detail in ventLineDetails {
        if detail.x1 == detail.x2 {
            // handle vertical vent lines
            let minY = min(detail.y1, detail.y2)
            let maxY = max(detail.y1, detail.y2)
            
            for yCoord in minY ... maxY {
                let coordinateString = "\(detail.x1)-\(yCoord)"
                if let ventCount = ventDicitonary[coordinateString] {
                    ventDicitonary[coordinateString] = ventCount + 1
                } else {
                    ventDicitonary[coordinateString] = 1
                }
            }
        } else if detail.y1 == detail.y2 {
            // handle horizontal vent lines
            let minX = min(detail.x1, detail.x2)
            let maxX = max(detail.x1, detail.x2)
            
            for xCoord in minX ... maxX {
                let coordinateString = "\(xCoord)-\(detail.y1)"
                if let ventCount = ventDicitonary[coordinateString] {
                    ventDicitonary[coordinateString] = ventCount + 1
                } else {
                    ventDicitonary[coordinateString] = 1
                }
            }
        } else {
            // not a vertical or horizontal vent line
        }
    }
    
    // only count vent values greater than 1
    return ventDicitonary.filter({ $0.value > 1 }).count
}

private func parseVentDetails(fileName: String) -> [VentLineDetail] {
    var ventLineDetails = [VentLineDetail]()
    
    let stringEntries = getFileContents(fileName: fileName).components(separatedBy: .newlines)
    
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
