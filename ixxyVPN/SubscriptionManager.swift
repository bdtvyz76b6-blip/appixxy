import Foundation

@MainActor
final class SubscriptionManager: ObservableObject {
static let shared = SubscriptionManager()

@Published private(set) var subscription: Subscription?
@Published private(set) var isLoading = false
@Published private(set) var errorMessage: String?
private init() {}
func loadSubscription() async {
    isLoading = true
    errorMessage = nil
    defer {
        isLoading = false
    }
    do {
        guard let token = try KeychainStore.shared.getToken(),
              !token.isEmpty else {
            errorMessage = "Аккаунт не авторизован."
            return
        }
        let result = try await APIClient.shared.getSubscription(token: token)
        subscription = result
    } catch {
        errorMessage = error.localizedDescription
    }
}
func clearSubscription() {
    subscription = nil
}

}