// SamWid.swift
// SamWid
//
// Created by HayatoInoue on 2024/11/19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent.smiley)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationAppIntent.smiley)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: ConfigurationAppIntent.smiley)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct SamWidEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily // get widget family
    
    var body: some View {
        Group {
            switch widgetFamily {
                case .accessoryInline:
                    Text(entry.configuration.favoriteEmoji) // show the simple text
                case .accessoryCircular:
                    ZStack {
                        Circle().stroke(lineWidth: 2)
                        Text(entry.configuration.favoriteEmoji)
                    }
                default:
                    // Writing to show detail a note app
                    VStack {
                        Text("Time:")
                        Text(entry.date, style: .time)
                    }
            }
        }
        .containerBackground(.fill, for: .widget) // First argument have to need background value
    }
}

struct SamWid: Widget {
    let kind: String = "SamWid"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SamWidEntryView(entry: entry)
        }
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
        .configurationDisplayName("Water Tracker Widget")
        .description("Track your water consumption directly from the Home Screen")
    }
}

// Extension moved to top-level
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    SamWid()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
