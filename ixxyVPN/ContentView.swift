import SwiftUI

struct ContentView: View {
    @State private var isConnected = false
    @State private var usedTraffic: Double = 0
    @State private var expirationDate = "—"

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ixxy")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)

                        Text("VPN")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Circle()
                        .fill(isConnected ? .green : .gray)
                        .frame(width: 10, height: 10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()

                VStack(spacing: 22) {
                    ZStack {
                        Circle()
                            .stroke(
                                isConnected ? Color.green.opacity(0.25) : Color.white.opacity(0.08),
                                lineWidth: 18
                            )
                            .frame(width: 220, height: 220)

                        Circle()
                            .stroke(
                                isConnected ? Color.green : Color.white.opacity(0.25),
                                lineWidth: 3
                            )
                            .frame(width: 220, height: 220)

                        VStack(spacing: 8) {
                            Image(systemName: "bolt.shield.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(isConnected ? .green : .white)

                            Text(isConnected ? "Подключено" : "Отключено")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isConnected.toggle()
                        }
                    } label: {
                        Text(isConnected ? "Отключить" : "Подключиться")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                                isConnected ? Color.white : Color.green,
                                in: RoundedRectangle(cornerRadius: 18)
                            )
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()

                VStack(spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Трафик")
                                .foregroundStyle(.gray)
                                .font(.system(size: 14))

                            Text(String(format: "%.1f ГБ", usedTraffic))
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 5) {
                            Text("Лимит")
                                .foregroundStyle(.gray)
                                .font(.system(size: 14))

                            Text("Безлимит")
                                .foregroundStyle(.green)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }

                    Divider()
                        .overlay(Color.white.opacity(0.1))

                    HStack {
                        Text("Подписка до")
                            .foregroundStyle(.gray)

                        Spacer()

                        Text(expirationDate)
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                    }
                }
                .padding(20)
                .background(
                    Color.white.opacity(0.06),
                    in: RoundedRectangle(cornerRadius: 22)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}