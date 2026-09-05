import Foundation

struct Subscription: Codable {
    let active: Bool
    let until: Date?
    let usedTrafficBytes: Int64

    var usedTrafficGB: Double {
        Double(usedTrafficBytes) / 1_073_741_824.0
    }

    var trafficLimitText: String {
        "Безлимит"
    }

    var expirationText: String {
        guard let until else {
            return "—"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"

        return formatter.string(from: until)
    }
}

struct UserAccount: Codable {
    let userID: Int64
    let subscription: Subscription
}