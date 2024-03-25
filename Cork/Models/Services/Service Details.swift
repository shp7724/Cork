//
//  Service Details.swift
//  Cork
//
//  Created by David Bureš on 21.03.2024.
//

import Foundation

struct ServiceDetails: Identifiable, Hashable, Codable
{
    var id: UUID = .init()
    
    let loaded: Bool
    let schedulable: Bool
    let pid: Int?
    
    let rootDir: URL?
    let logPath: URL?
    let errorLogPath: URL?
    
    private enum CodingKeys: String, CodingKey
    {
        case loaded, schedulable, pid, rootDir, logPath, errorLogPath
    }
}
