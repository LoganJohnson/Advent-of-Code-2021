import Foundation

extension Int {
    // calculates 5+4+3+2+1 but efficient
    var plusEachLowerNumber: Int {
        guard self > 0 else { return 0 }
        
        return (self * self + self) / 2
    }
}
