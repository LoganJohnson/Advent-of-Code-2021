import Foundation

extension Array {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

extension Array where Element == Int {
    var median: Int {
        guard self.isNotEmpty else { return 0 }
        
        return self.sorted(by: <)[self.count / 2]
    }
}
