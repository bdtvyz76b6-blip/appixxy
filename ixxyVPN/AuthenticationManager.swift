import Foundation

@MainActor
final class AuthenticationManager: ObservableObject {
static let shared = AuthenticationManager()

@Published private(set) var isAuthenticated = false
private init() {
    Task {
        await checkAuthentication()
    }
}
func checkAuthentication() async {
    do {
        let token = try KeychainStore.shared.getToken()
        isAuthenticated = !(token?.isEmpty ?? true)
    } catch {
        isAuthenticated = false
    }
}
func setToken(_ token: String) {
    guard !token.isEmpty else {
        isAuthenticated = false
        return
    }
    do {
        try KeychainStore.shared.saveToken(token)
        isAuthenticated = true
    } catch {
        isAuthenticated = false
    }
}
func logout() {
    do {
        try KeychainStore.shared.deleteToken()
    } catch {
        // Токен уже считается удалённым для приложения.
    }
    isAuthenticated = false
    SubscriptionManager.shared.clearSubscription()
}

}