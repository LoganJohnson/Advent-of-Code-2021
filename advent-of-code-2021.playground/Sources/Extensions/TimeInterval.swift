import Foundation

extension TimeInterval {
    public var toMilliseconds: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
