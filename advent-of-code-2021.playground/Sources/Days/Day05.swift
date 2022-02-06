import Foundation

struct VentLineDetail {
    var x1, y1, x2, y2: Int
}

internal func performDay5A() -> Int {
    solveDay5A(ventLineDetails: parseVentDetails(fileName: "day-5"))
}

internal func performDay5B() -> Int {
    solveDay5B(ventLineDetails: parseVentDetails(fileName: "day-5"))
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
                let coordinateString = "\(detail.x1)-\(yCoord)"
                let currentValue = ventDicitonary[coordinateString, default: 0]
                ventDicitonary[coordinateString] = currentValue + 1
            }
        } else if detail.y1 == detail.y2 {
            // handle horizontal vent lines
            let minX = min(detail.x1, detail.x2)
            let maxX = max(detail.x1, detail.x2)
            
            for xCoord in minX ... maxX {
                let coordinateString = "\(xCoord)-\(detail.y1)"
                let currentValue = ventDicitonary[coordinateString, default: 0]
                ventDicitonary[coordinateString] = currentValue + 1
            }
        } else if countDiagonals {
            // handle diagonal vent lines (assumes 45 degree angle)
            var xCoord = detail.x1
            var yCoord = detail.y1
            
            let shouldIncrementX = detail.x1 < detail.x2
            let shouldIncrementY = detail.y1 < detail.y2
            
            while true {
                let coordinateString = "\(xCoord)-\(yCoord)"
                let currentValue = ventDicitonary[coordinateString, default: 0]
                ventDicitonary[coordinateString] = currentValue + 1
                
                if xCoord == detail.x2 { break }
                
                xCoord += shouldIncrementX ? 1 : -1
                yCoord += shouldIncrementY ? 1 : -1
            }
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
