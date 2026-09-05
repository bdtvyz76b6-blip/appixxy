import Foundation
import NetworkExtension

@MainActor
final class VPNManager: ObservableObject {
static let shared = VPNManager()

@Published private(set) var isConnected = false
@Published private(set) var isLoading = false
@Published private(set) var errorMessage: String?
private var manager: NEVPNManager?
private init() {
    Task {
        await loadVPNConfiguration()
    }
}
func loadVPNConfiguration() async {
    do {
        let managers = try await NEVPNManager.shared().loadFromPreferencesAsync()
        if let manager = managers {
            self.manager = manager
            self.isConnected = manager.connection.status == .connected
        }
    } catch {
        errorMessage = error.localizedDescription
    }
}
func connect() async {
    isLoading = true
    errorMessage = nil
    do {
        let vpnManager = try await getManager()
        try await saveConfiguration(vpnManager)
        try vpnManager.connection.startVPNTunnel()
        isConnected = true
    } catch {
        isConnected = false
        errorMessage = error.localizedDescription
    }
    isLoading = false
}
func disconnect() {
    manager?.connection.stopVPNTunnel()
    isConnected = false
}
private func getManager() async throws -> NEVPNManager {
    if let manager {
        return manager
    }
    let manager = NEVPNManager.shared()
    try await manager.loadFromPreferencesAsync()
    self.manager = manager
    return manager
}
private func saveConfiguration(_ manager: NEVPNManager) async throws {
    manager.localizedDescription = "ixxy VPN"
    /*
     Конфигурация Packet Tunnel Provider будет добавлена
     после создания VPN Extension.
     Здесь специально НЕ хранится VLESS,
     UUID, Reality key или другие серверные настройки.
    */
    try await manager.saveToPreferencesAsync()
}

}

// MARK: - Async NetworkExtension helpers

private extension NEVPNManager {
func loadFromPreferencesAsync() async throws {
try await withCheckedThrowingContinuation { continuation in
loadFromPreferences { error in
if let error {
continuation.resume(throwing: error)
} else {
continuation.resume()
}
}
}
}

func saveToPreferencesAsync() async throws {
    try await withCheckedThrowingContinuation { continuation in
        saveToPreferences { error in
            if let error {
                continuation.resume(throwing: error)
            } else {
                continuation.resume()
            }
        }
    }
}

}