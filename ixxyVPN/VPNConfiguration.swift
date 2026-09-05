import Foundation
import NetworkExtension

struct VPNConfiguration {

static let providerBundleIdentifier = "com.ixxyvpn.app.PacketTunnel"
static func makeManager() -> NETunnelProviderManager {
    let manager = NETunnelProviderManager()
    let configuration = NETunnelProviderProtocol()
    configuration.providerBundleIdentifier = providerBundleIdentifier
    configuration.serverAddress = "ixxy VPN"
    manager.protocolConfiguration = configuration
    manager.localizedDescription = "ixxy VPN"
    manager.isEnabled = true
    return manager
}

}