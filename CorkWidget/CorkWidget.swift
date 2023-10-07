//
//  CorkWidget.swift
//  CorkWidget
//
//  Created by David Bureš on 07.10.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HomebrewStatsEntry {
        HomebrewStatsEntry(date: .now, stats: HomebrewStats(installedPackagesCount: 32, installedCasksCount: 12, addedTapsCount: 10))
    }

    func getSnapshot(in context: Context, completion: @escaping (HomebrewStatsEntry) -> ()) {
        let entry = HomebrewStatsEntry(date: .now, stats: HomebrewStats(installedPackagesCount: 3, installedCasksCount: 7, addedTapsCount: 2))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var homebrewStatsEntry: [HomebrewStatsEntry]?

        // Get outdated packages from the shared storage
        homebrewStatsEntry = try? [HomebrewStatsEntry(date: .now, stats: retrieveDataFromSharedStorage(dataType: .homebrewStats) as! HomebrewStats)]

        let timeline = Timeline(entries: homebrewStatsEntry ?? [HomebrewStatsEntry(date: .now, stats: HomebrewStats(installedPackagesCount: 3, installedCasksCount: 7, addedTapsCount: 2))], policy: .atEnd)
        completion(timeline)
    }
}

struct HomebrewStatsEntry: TimelineEntry
{
    let date: Date
    let stats: HomebrewStats
}

struct CorkWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Installed Packages: \(String(entry.stats.installedPackagesCount))")
            Text("Installed Casks: \(String(entry.stats.installedCasksCount))")
            Text("Added Taps: \(String(entry.stats.addedTapsCount))")
        }
    }
}

struct CorkWidget: Widget {
    let kind: String = "CorkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                CorkWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CorkWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Homebrew Stats")
        .description("See your Homebrew stats")
    }
}
