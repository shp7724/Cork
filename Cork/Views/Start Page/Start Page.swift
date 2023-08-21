//
//  Start Page.swift
//  Cork
//
//  Created by David Bureš on 10.02.2023.
//

import SwiftUI

struct StartPage: View
{
    @AppStorage("allowBrewAnalytics") var allowBrewAnalytics: Bool = true

    @EnvironmentObject var brewData: BrewDataStorage
    @EnvironmentObject var availableTaps: AvailableTaps

    @EnvironmentObject var appState: AppState

    @EnvironmentObject var updateProgressTracker: UpdateProgressTracker

    @State private var isLoadingUpgradeablePackages = true
    @State private var upgradeablePackages: [BrewPackage] = .init()

    @State private var isShowingFastCacheDeletionMaintenanceView: Bool = false

    @State private var isDisclosureGroupExpanded: Bool = false
    
    @State private var hasCopiedCommand: Bool = false

    var body: some View
    {
        VStack
        {
            if isLoadingUpgradeablePackages
            {
                ProgressView
                {
                    Text("Checking for Package Updates...")
                }
            }
            else
            {
                VStack
                {
                    VStack(alignment: .leading)
                    {
                        Text("Homebrew Status")
                            .font(.title)

                        if upgradeablePackages.count != 0
                        {
                            GroupBox
                            {
                                Grid
                                {
                                    GridRow(alignment: .firstTextBaseline)
                                    {
                                        VStack(alignment: .leading)
                                        {
                                            Text(upgradeablePackages.count == 1 ? "There is 1 outdated package" : "There are \(upgradeablePackages.count) outdated packages")
                                                .font(.headline)
                                            DisclosureGroup(isExpanded: $isDisclosureGroupExpanded)
                                            {} label: {
                                                Text("Outdated packages")
                                                    .font(.subheadline)
                                            }

                                            if isDisclosureGroupExpanded
                                            {
                                                List(upgradeablePackages)
                                                { package in
                                                    Text(package.name)
                                                }
                                                .listStyle(.bordered(alternatesRowBackgrounds: true))
                                                .frame(height: 100)
                                            }
                                        }

                                        Button
                                        {
                                            updateBrewPackages(updateProgressTracker, appState: appState)
                                        } label: {
                                            Text("Update")
                                        }
                                    }
                                }
                            }
                        }

                        if !appState.isLoadingFormulae && !appState.isLoadingCasks
                        {
                            GroupBox
                            {
                                Grid(alignment: .leading)
                                {
                                    GridRow(alignment: .firstTextBaseline)
                                    {
                                        GroupBoxHeadlineGroup(title: "You have \(brewData.installedFormulae.count) Formulae installed", mainText: "Formulae are usually apps that you run in a terminal")
                                            .animation(.none, value: brewData.installedFormulae.count)
                                    }

                                    Divider()

                                    GridRow(alignment: .firstTextBaseline)
                                    {
                                        GroupBoxHeadlineGroup(title: "You have \(brewData.installedCasks.count) Casks installed", mainText: "Casks are usually graphical apps")
                                            .animation(.none, value: brewData.installedCasks.count)
                                    }

                                    Divider()

                                    GridRow(alignment: .firstTextBaseline)
                                    {
                                        GroupBoxHeadlineGroup(title: "You have \(availableTaps.addedTaps.count) Taps added", mainText: "Taps are sources of packages that are not provided by Homebrew itself")
                                            .animation(.none, value: availableTaps.addedTaps.count)
                                    }
                                }
                            }

                            GroupBox
                            {
                                Grid(alignment: .leading)
                                {
                                    GridRow(alignment: .firstTextBaseline)
                                    {
                                        GroupBoxHeadlineGroup(title: "Brew analytics are \(allowBrewAnalytics ? "enabled" : "disabled")", mainText: "\(allowBrewAnalytics ? "Brew is collecting various anonymized data, such as which packages you have installed" : "Brew is not collecting any data about how you use it")")
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }

                            if appState.cachedDownloadsFolderSize != 0
                            {
                                GroupBox
                                {
                                    Grid(alignment: .leading)
                                    {
                                        GridRow(alignment: .center)
                                        {
                                            HStack
                                            {
                                                GroupBoxHeadlineGroup(title: "You have \(appState.cachedDownloadsFolderSize.convertDirectorySizeToPresentableFormat(size: appState.cachedDownloadsFolderSize)) of cached downloads", mainText: "These files were used for installing packages.\nThey are safe to remove.")

                                                Spacer()

                                                Button
                                                {
                                                    appState.isShowingFastCacheDeletionMaintenanceView = true
                                                } label: {
                                                    Text("Delete Cached Downloads")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Spacer()

                    HStack
                    {
                        Spacer()

                        UninstallationProgressWheel()

                        Button
                        {
                            print("Would perform maintenance")
                            appState.isShowingMaintenanceSheet.toggle()
                        } label: {
                            Text("Brew Maintenance")
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear
        {
            Task(priority: .high)
            {
                isLoadingUpgradeablePackages = true
                upgradeablePackages = await getListOfUpgradeablePackages()
                isLoadingUpgradeablePackages = false
            }
        }
        .sheet(isPresented: $appState.isShowingNoHomebrewExecutableFoundError)
        {
            VStack(alignment: .center, spacing: 10)
            {
                
                Image(systemName: "mug")
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
                
                Text("Could not find Homebrew")
                    .font(.largeTitle)
                Text("You need to have Homebrew installed to use Cork\nYou can install it by running this command in the Terminal:")
                    .multilineTextAlignment(.center)
                GroupBox
                {
                    HStack(alignment: .center, spacing: 5)
                    {
                        Text(verbatim: "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"")
                            .textSelection(.enabled)
                            .padding(5)

                        Divider()

                        Button
                        {
                            copyToClipboard(whatToCopy: """
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
""")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                            {
                                hasCopiedCommand = true
                                NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
                            }
                        } label: {
                            Label
                            {
                                Text(hasCopiedCommand ? "Command Copied" : "Copy Command")
                            } icon: {
                                Image(systemName: hasCopiedCommand ? "checkmark" : "doc.on.doc")
                            }
                            .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .fixedSize()

                Text("When you click the button below, a Terminal window will open\nUse ⌘+V to insert the command, and then press ↩ (Return) to execute the command\nWait until the command finishes running, and then use the button below to restart Cork")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Button
                {
                    openTerminal()
                    copyToClipboard(whatToCopy: """
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
""")
                } label: {
                    Text("Copy Command and Open Terminal")
                }
                .keyboardShortcut(.defaultAction)

                Button
                {
                    restartApp()
                } label: {
                    Text("Restart Cork")
                }
                .keyboardShortcut(.cancelAction)
            }
            .padding()
        }
    }

    func openTerminal()
    {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else { return }

        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url, configuration: configuration, completionHandler: nil)
    }
    
    func copyToClipboard(whatToCopy: String)
    {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(whatToCopy, forType: .string)
    }
}
