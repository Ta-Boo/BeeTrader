import Foundation

extension Int {
    func toPrice() -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.locale = Locale(identifier: "sk_SK")
        return "\(numFormatter.string(from: NSNumber(value: self/100)) ?? "0")€"
    }
}
