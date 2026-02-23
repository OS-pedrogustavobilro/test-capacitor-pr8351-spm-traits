import Foundation

@objc public class PluginWithTraits: NSObject {

    // MARK: - Properties

    #if DEBUG_LOGGING
    private let debugEnabled = true
    #else
    private let debugEnabled = false
    #endif

    #if PRIVACY_MANIFEST
    private var privacyTrackingEnabled = true
    private var dataAccessLog: [String] = []
    #endif

    // MARK: - Initialization

    public override init() {
        super.init()

        #if DEBUG_LOGGING
        log("PluginWithTraits initialized with DEBUG_LOGGING trait enabled")
        #endif

        #if PRIVACY_MANIFEST
        log("Privacy manifest tracking is enabled")
        #endif

        #if EXTENDED_FEATURES
        log("Extended features are available")
        #endif
    }

    // MARK: - Public Methods

    @objc public func echo(_ value: String) -> String {
        #if DEBUG_LOGGING
        log("echo() called with value: '\(value)'")
        #endif

        #if PRIVACY_MANIFEST
        trackDataAccess(operation: "echo", data: value)
        #endif

        return value
    }

    #if EXTENDED_FEATURES
    // Extended feature: Transforms the echo value
    @objc public func echoTransformed(_ value: String, uppercase: Bool = false) -> String {
        #if DEBUG_LOGGING
        log("echoTransformed() called with value: '\(value)', uppercase: \(uppercase)")
        #endif

        let transformed = uppercase ? value.uppercased() : value.lowercased()

        #if PRIVACY_MANIFEST
        trackDataAccess(operation: "echoTransformed", data: value)
        #endif

        return transformed
    }
    #endif

    // MARK: - Privacy Manifest Features

    #if PRIVACY_MANIFEST
    @objc public func getPrivacyLog() -> [String] {
        #if DEBUG_LOGGING
        log("getPrivacyLog() called, returning \(dataAccessLog.count) entries")
        #endif
        return dataAccessLog
    }

    @objc public func clearPrivacyLog() {
        #if DEBUG_LOGGING
        log("clearPrivacyLog() called")
        #endif
        dataAccessLog.removeAll()
    }

    private func trackDataAccess(operation: String, data: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let logEntry = "[\(timestamp)] \(operation): \(data.prefix(50))"
        dataAccessLog.append(logEntry)

        #if DEBUG_LOGGING
        log("Privacy tracking: \(logEntry)")
        #endif
    }
    #endif

    // MARK: - Debug Logging

    private func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[PluginWithTraits][\(timestamp)] \(message)")
    }

    #if DEBUG_LOGGING
    @objc public func getDebugInfo() -> [String: Any] {
        return [
            "debugEnabled": debugEnabled,
            "timestamp": Date().timeIntervalSince1970,
            "features": getSupportedFeatures()
        ]
    }
    #endif

    // MARK: - Feature Detection

    @objc public func getSupportedFeatures() -> [String] {
        var features = ["echo"]

        #if DEBUG_LOGGING
        features.append("debug_logging")
        #endif

        #if PRIVACY_MANIFEST
        features.append("privacy_tracking")
        #endif

        #if EXTENDED_FEATURES
        features.append("extended_features")
        features.append("echo_transformed")
        features.append("echo_with_delay")
        #endif

        return features
    }
}
