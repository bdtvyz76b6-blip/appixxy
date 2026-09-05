import Foundation
import Security

final class KeychainStore {
static let shared = KeychainStore()

private let service = "com.ixxyvpn.app"
private init() {}
func saveToken(_ token: String) throws {
    guard let data = token.data(using: .utf8) else {
        throw KeychainError.invalidData
    }
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: "api_token"
    ]
    let attributes: [String: Any] = [
        kSecValueData as String: data
    ]
    let updateStatus = SecItemUpdate(
        query as CFDictionary,
        attributes as CFDictionary
    )
    if updateStatus == errSecSuccess {
        return
    }
    if updateStatus != errSecItemNotFound {
        throw KeychainError.osStatus(updateStatus)
    }
    var addQuery = query
    addQuery[kSecValueData as String] = data
    let status = SecItemAdd(
        addQuery as CFDictionary,
        nil
    )
    guard status == errSecSuccess else {
        throw KeychainError.osStatus(status)
    }
}
func getToken() throws -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: "api_token",
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: CFTypeRef?
    let status = SecItemCopyMatching(
        query as CFDictionary,
        &result
    )
    if status == errSecItemNotFound {
        return nil
    }
    guard status == errSecSuccess else {
        throw KeychainError.osStatus(status)
    }
    guard
        let data = result as? Data,
        let token = String(data: data, encoding: .utf8)
    else {
        throw KeychainError.invalidData
    }
    return token
}
func deleteToken() throws {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: "api_token"
    ]
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
        throw KeychainError.osStatus(status)
    }
}

}

enum KeychainError: LocalizedError {
case invalidData
case osStatus(OSStatus)

var errorDescription: String? {
    switch self {
    case .invalidData:
        return "Не удалось обработать данные Keychain."
    case .osStatus(let status):
        return "Ошибка Keychain: \(status)."
    }
}

}