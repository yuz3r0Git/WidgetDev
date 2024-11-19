//
//  SamWidLiveActivity.swift
//  SamWid
//
//  Created by HayatoInoue on 2024/11/19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SamWidAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SamWidLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SamWidAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SamWidAttributes {
    fileprivate static var preview: SamWidAttributes {
        SamWidAttributes(name: "World")
    }
}

extension SamWidAttributes.ContentState {
    fileprivate static var smiley: SamWidAttributes.ContentState {
        SamWidAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SamWidAttributes.ContentState {
         SamWidAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SamWidAttributes.preview) {
   SamWidLiveActivity()
} contentStates: {
    SamWidAttributes.ContentState.smiley
    SamWidAttributes.ContentState.starEyes
}
