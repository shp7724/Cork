//
//  Top Packages Tracker.swift
//  Cork
//
//  Created by David Bureš on 19.08.2023.
//

import Foundation

@MainActor
class TopPackagesTracker: ObservableObject
{
    @Published var topFormulae: [TopPackage] = .init()
    @Published var topCasks: [TopPackage] = .init()
}
