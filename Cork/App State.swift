//
//  AppState.swift
//  Cork
//
//  Created by David Bureš on 05.02.2023.
//

import Foundation

class AppState: ObservableObject {
    /// Stuff for controlling various sheets from the menu bar
    @Published var isShowingInstallationSheet: Bool = false
    @Published var isShowingUninstallationSheet: Bool = false
    @Published var isShowingMaintenanceSheet: Bool = false
    @Published var isShowingFastCacheDeletionMaintenanceView: Bool = false
    @Published var isShowingAddTapSheet: Bool = false
    @Published var isShowingUpdateSheet: Bool = false
    
    @Published var isShowingUninstallationProgressView: Bool = false
    @Published var isShowingUninstallationNotPossibleDueToDependencyAlert: Bool = false
    @Published var offendingDependencyProhibitingUninstallation: String = ""
    @Published var isShowingRemoveTapFailedAlert: Bool = false
    
    @Published var isLoadingFormulae: Bool = true
    @Published var isLoadingCasks: Bool = true
    
    @Published var isShowingNoHomebrewExecutableFoundError: Bool = false
    
    @Published var cachedDownloadsFolderSize: Int64 = directorySize(url: AppConstants.brewCachedDownloadsPath)
    
    func checkIfHomebrewWasFound() -> Void
    {
        if AppConstants.brewExecutablePath.absoluteString.isEmpty
        {
            print("Homebrew executable was not found")
            self.isShowingNoHomebrewExecutableFoundError = true
        }
        else
        {
            print("Homebrew executable was found")
        }
    }
}
