//
//  Service.swift
//  Cork
//
//  Created by David Bureš on 20.03.2024.
//

import Foundation

struct HomebrewService: Identifiable, Hashable, Codable
{
    var id: UUID = .init()

    let name: String
    let status: ServiceStatus

    let user: String?

    let file: URL

    let exitCode: Int?
    
    private enum CodingKeys: String, CodingKey
    {
        case name, status, user, file, exitCode
    }
}
