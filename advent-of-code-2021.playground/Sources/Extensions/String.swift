import Foundation

extension String {
    var convertFromBinaryStringToInt: Int {
      return Int(strtoul(self, nil, 2))
    }
}
