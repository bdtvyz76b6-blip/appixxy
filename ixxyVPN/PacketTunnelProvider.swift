import NetworkExtension
import Foundation

final class PacketTunnelProvider: NEPacketTunnelProvider {

override func startTunnel(
    options: [String: NSObject]?,
    completionHandler: @escaping (Error?) -> Void
) {
    let settings = NEPacketTunnelNetworkSettings(
        tunnelRemoteAddress: "10.0.0.1"
    )
    settings.ipv4Settings = NEIPv4Settings(
        addresses: ["10.0.0.2"],
        subnetMasks: ["255.255.255.0"]
    )
    settings.ipv4Settings?.includedRoutes = [
        NEIPv4Route.default()
    ]
    settings.mtu = 1400
    setTunnelNetworkSettings(settings) { error in
        if let error {
            completionHandler(error)
            return
        }
        completionHandler(nil)
    }
}
override func stopTunnel(
    with reason: NEProviderStopReason,
    completionHandler: @escaping () -> Void
) {
    completionHandler()
}
override func handleAppMessage(
    _ messageData: Data,
    completionHandler: ((Data?) -> Void)?
) {
    completionHandler?(nil)
}

}