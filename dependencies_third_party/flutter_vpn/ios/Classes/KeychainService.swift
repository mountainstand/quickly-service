
// Identifiers
let serviceIdentifier = "MySerivice"
let userAccount = "authenticatedUser"
let accessGroup = "MySerivice"

// Arguments for the keychain queries
var kSecAttrAccessGroupSwift = NSString(format: kSecClass)

let kSecClassValue: String = kSecClass as String
let kSecAttrAccountValue: String = kSecAttrAccount as String
let kSecValueDataValue: String = kSecValueData as String
let kSecClassGenericPasswordValue: String = kSecClassGenericPassword as String
let kSecAttrServiceValue: String = kSecAttrService as String
let kSecMatchLimitValue: String = kSecMatchLimit as String
let kSecReturnDataValue: String = kSecReturnData as String
let kSecMatchLimitOneValue: String = kSecMatchLimitOne as String
let kSecAttrGenericValue: String = kSecAttrGeneric as String
let kSecAttrAccessibleValue: String = kSecAttrAccessible as String
let kSecReturnPersistentRefValue: String = kSecReturnPersistentRef as String


class KeychainService: NSObject {
    var serviceName: String

    init(serviceName: String = "flutter_vpn") {
        self.serviceName = serviceName
    }

    func save(key: String, value: String) {
        let keyData: Data = key.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let valueData: Data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!

        let keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClassValue] = kSecClassGenericPasswordValue
        keychainQuery[kSecAttrGenericValue] = keyData
        keychainQuery[kSecAttrAccountValue] = keyData
        keychainQuery[kSecAttrServiceValue] = self.serviceName
        keychainQuery[kSecAttrAccessibleValue] = kSecAttrAccessibleAfterFirstUnlock
        keychainQuery[kSecValueDataValue] = valueData

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    func load(key: String) -> Data? {
        let keyData: Data = key.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClassValue] = kSecClassGenericPasswordValue
        keychainQuery[kSecAttrGenericValue] = keyData
        keychainQuery[kSecAttrAccountValue] = keyData
        keychainQuery[kSecAttrServiceValue] = self.serviceName
        keychainQuery[kSecAttrAccessibleValue] = kSecAttrAccessibleAfterFirstUnlock
        keychainQuery[kSecMatchLimitValue] = kSecMatchLimitOne
        keychainQuery[kSecReturnPersistentRefValue] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)

        return status == noErr ? result as? Data : nil
    }
    
    func storeCertificateInKeychain(certData: Data, key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: certData
        ]
        
        // Delete any existing entry
        SecItemDelete(query as CFDictionary)
        
        // Add new certificate
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Certificate stored in Keychain successfully.")
        } else {
            print("Failed to store certificate: \(status)")
        }
    }
    
    func retrieveCertificateFromKeychain(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("Failed to retrieve certificate: \(status)")
            return nil
        }
    }
}
