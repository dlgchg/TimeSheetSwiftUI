//
//  TimeSheetTodoWidget.swift
//  TimeSheetTodoWidget
//
//  Created by 李伟 on 2020/11/26.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), items: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.create, ascending: true)]
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "postpone == %d", true),
            NSPredicate(format: "allday == %d", true),
            NSPredicate(format: "end == %d", false),
            NSPredicate(format: "recycle == %d", false),
        ])
        var items: [Item] = []
        do {
            items = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, items: items)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [Item]
}

struct TimeSheetTodoWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("待办事项")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("BlueColor"))
                    .frame(height: 50)
                Spacer()
            }.padding(.horizontal)
            if entry.items.count == 0 {
                Text("暂无待办")
                    .foregroundColor(Color("GrayColor"))
                    .frame(maxHeight: .infinity)
            } else {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10,  content: {
                    ForEach(entry.items.suffix(widgetFamily == .systemLarge ? 7 : 3), id: \.self) { item in
                        VStack {
                            HStack {
                                Text(verbatim: item.content ?? "")
                                    .lineLimit(1)
                                    .font(.system(size: 16.5, weight: .regular, design: .rounded))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            Divider()
                        }
                    }
                }).padding(.horizontal)
            }
            Spacer()
        }
    }
}

@main
struct TimeSheetTodoWidget: Widget {
    let kind: String = "时间表"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimeSheetTodoWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("时间表待办小组件")
        .description("显示待办事项")
    }
}

struct TimeSheetTodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TimeSheetTodoWidgetEntryView(entry: SimpleEntry(date: Date(), items: []))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            TimeSheetTodoWidgetEntryView(entry: SimpleEntry(date: Date(), items: []))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
