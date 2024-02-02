//
//  Bundle+Extension.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/01.
//

import Foundation
import OSLog

extension Bundle {
    /**
     * Info.plist から String のデータを取得
     */
    static func getBundleString(key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
            return ""
        }
        Logger.auth.debug("\(#function): \(key) = \(value as! String)")
        return value as! String
    }
    
    /**
     * Info.plist から [String] のデータを取得
     */
    static func getBundleArray(key: String) -> [String] {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
            return []
        }
        Logger.auth.debug("\(#function): \(key) = \(value as! [String])")
        return value as! [String]
    }
}
