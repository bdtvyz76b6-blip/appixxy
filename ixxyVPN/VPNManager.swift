import Foundation
import NetworkExtension

@MainActor
final class VPNManager: ObservableObject {
static let shared = VPNManager()

@Published private(set) var isConnected = false
@Published private(set) var isLoading = false
@Published private(set) var errorMessage: String?
private var manager: NETunnelProviderManager?
private init() {
    Task {
        await load()
    }
}
func load() async {
    do {
        let managers = try await NETunnelProviderManager.loadAllFromPreferencesAsync()
        if let existing = managers.first {
            manager = existing
            updateStatus()
        }
    } catch {
        errorMessage = error.localizedDescription
    }
}
func connect() async {
    isLoading = true
    errorMessage = nil
    do {
        let vpn = try await prepareManager()
        try vpn.connection.startVPNTunnel()
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
private func prepareManager() async throws -> NETunnelProviderManager {
    if let manager {
        return manager
    }
    let vpn = NETunnelProviderManager()
    let configuration = NETunnelProviderProtocol()
    configuration.providerBundleIdentifier =
        VPNConfiguration.providerBundleIdentifier
    configuration.serverAddress = "ixxy VPN"
    vpn.protocolConfiguration = configuration
    vpn.localizedDescription = "ixxy VPN"
    vpn.isEnabled = true
    try await vpn.saveToPreferencesAsync()
    manager = vpn
    return vpn
}
private func updateStatus() {
    guard let status = manager?.connection.status else {
        isConnected = false
        return
    }
    isConnected = status == .connected ||
                  status == .connecting
}

}

private extension NETunnelProviderManager {

static func loadAllFromPreferencesAsync()
    async throws -> [NETunnelProviderManager] {
    try await withCheckedThrowingContinuation { continuation in
        loadAllFromPreferences { managers, error in
            if let error {
                continuation.resume(throwing: error)
            } else {
                continuation.resume(
                    returning: managers ?? []
                )
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