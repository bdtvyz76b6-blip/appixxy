import SwiftUI

struct ContentView: View {
@StateObject private var subscriptionManager = SubscriptionManager.shared
@StateObject private var vpnManager = VPNManager.shared

var body: some View {
    ZStack {
        Color.black
            .ignoresSafeArea()
        ScrollView {
            VStack(spacing: 24) {
                header
                connectionSection
                trafficSection
                subscriptionSection
                if let error = subscriptionManager.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
    .preferredColorScheme(.dark)
    .task {
        await subscriptionManager.loadSubscription()
    }
}
private var header: some View {
    HStack {
        VStack(alignment: .leading, spacing: 4) {
            Text("ixxy")
                .font(.system(size: 32, weight: .bold))
            Text("VPN")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
        }
        Spacer()
        Circle()
            .fill(vpnManager.isConnected ? .green : .gray)
            .frame(width: 10, height: 10)
    }
}
private var connectionSection: some View {
    VStack(spacing: 18) {
        ZStack {
            Circle()
                .fill(
                    vpnManager.isConnected
                    ? Color.green.opacity(0.15)
                    : Color.white.opacity(0.06)
                )
                .frame(width: 190, height: 190)
            Image(systemName: "shield.fill")
                .font(.system(size: 72))
                .foregroundStyle(
                    vpnManager.isConnected ? .green : .white
                )
        }
        Text(vpnManager.isConnected ? "Подключено" : "Отключено")
            .font(.title2.weight(.semibold))
        Button {
            Task {
                if vpnManager.isConnected {
                    vpnManager.disconnect()
                } else {
                    await vpnManager.connect()
                }
            }
        } label: {
            HStack {
                if vpnManager.isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(
                    vpnManager.isConnected
                    ? "Отключить"
                    : "Подключиться"
                )
                .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                vpnManager.isConnected
                ? Color.white.opacity(0.12)
                : Color.green
            )
            .foregroundStyle(
                vpnManager.isConnected ? .white : .black
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(vpnManager.isLoading)
    }
}
private var trafficSection: some View {
    VStack(alignment: .leading, spacing: 12) {
        Text("Трафик")
            .font(.headline)
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Использовано")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(
                    String(
                        format: "%.2f ГБ",
                        subscriptionManager.subscription?.usedTrafficGB ?? 0
                    )
                )
                .font(.title3.weight(.semibold))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("Лимит")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Безлимит")
                    .font(.title3.weight(.semibold))
            }
        }
    }
    .padding()
    .background(Color.white.opacity(0.06))
    .clipShape(RoundedRectangle(cornerRadius: 18))
}
private var subscriptionSection: some View {
    VStack(alignment: .leading, spacing: 12) {
        Text("Подписка")
            .font(.headline)
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Статус")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(
                    subscriptionManager.subscription?.active == true
                    ? "Активна"
                    : "Не активна"
                )
                .font(.body.weight(.semibold))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("До")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(
                    subscriptionManager.subscription?.expirationText ?? "—"
                )
                .font(.body.weight(.semibold))
            }
        }
    }
    .padding()
    .background(Color.white.opacity(0.06))
    .clipShape(RoundedRectangle(cornerRadius: 18))
}

}

#Preview {
ContentView()
}