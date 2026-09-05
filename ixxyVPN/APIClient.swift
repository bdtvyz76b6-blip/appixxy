import Foundation

enum APIError: LocalizedError {
case invalidURL
case unauthorized
case serverError(Int)
case invalidResponse
case decodingError

var errorDescription: String? {
    switch self {
    case .invalidURL:
        return "Неверный адрес API."
    case .unauthorized:
        return "Необходима авторизация."
    case .serverError(let code):
        return "Ошибка сервера: \(code)."
    case .invalidResponse:
        return "Некорректный ответ сервера."
    case .decodingError:
        return "Не удалось обработать ответ сервера."
    }
}

}

final class APIClient {
static let shared = APIClient()

// Здесь позже будет адрес API ixxy VPN.
// Меняется только эта строка.
private let baseURL = URL(string: "https://YOUR-API-DOMAIN/v1")!
private let session: URLSession
private init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 15
    configuration.timeoutIntervalForResource = 30
    self.session = URLSession(configuration: configuration)
}
func getSubscription(token: String) async throws -> Subscription {
    let url = baseURL.appendingPathComponent("subscription")
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let (data, response) = try await session.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
    }
    switch httpResponse.statusCode {
    case 200...299:
        break
    case 401, 403:
        throw APIError.unauthorized
    case 400...599:
        throw APIError.serverError(httpResponse.statusCode)
    default:
        throw APIError.invalidResponse
    }
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Subscription.self, from: data)
    } catch {
        throw APIError.decodingError
    }
}

}