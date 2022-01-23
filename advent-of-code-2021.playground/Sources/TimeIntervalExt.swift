import Foundation

extension TimeInterval {
    var toMilliseconds: String {
        return "\(Int((self*1000).truncatingRemainder(dividingBy: 1000)))ms"
    }
}
