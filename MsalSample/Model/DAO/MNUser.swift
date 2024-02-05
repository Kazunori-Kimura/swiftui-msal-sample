//
//  MNUser.swift
//  MsalSample
//
//  Created by Kazunori Kimura on 2024/02/05.
//

import Foundation

extension MNDao {
    enum Role: String {
        case User = "0"
        case OrgAdmin = "1"
        case SysAdmin = "2"
    }
    
    struct MNUser: Codable {
        let id: Int
        let email: String
        let objectId: String?
        let organizationId: Int?
        let role: String
        let createdAt: String
        let updatedAt: String
        let organization: MNOrganization?
    }
    
    struct MNOrganization: Codable {
        let id: Int
        let displayName: String
        let license: String
        let limit: String
    }
}
