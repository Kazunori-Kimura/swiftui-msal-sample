//
//  HTTPURLResponse+Extension.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/05.
//

import Foundation

extension HTTPURLResponse {
    var ok: Bool {
        get {
            return (200...299).contains(self.statusCode)
        }
    }
    
    var status: String {
        get {
            return HTTPURLResponse.localizedString(forStatusCode: self.statusCode)
        }
    }
}
