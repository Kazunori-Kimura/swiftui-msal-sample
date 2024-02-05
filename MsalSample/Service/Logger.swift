//
//  Logger.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import OSLog

extension Logger {
    static let api = Logger(subsystem: Bundle.main.bundleIdentifier ?? "unknown", category: "API")
    static let auth = Logger(subsystem: Bundle.main.bundleIdentifier ?? "unknown", category: "Auth")
}
