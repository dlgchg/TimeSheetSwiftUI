//
//  TimeSheetBirthdayWidget.swift
//  TimeSheetBirthdayWidget
//
//  Created by 李伟 on 2020/11/30.
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
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.allday, ascending: false),
            NSSortDescriptor(keyPath: \Item.time, ascending: true),
            NSSortDescriptor(keyPath: \Item.date, ascending: true),
        ]
        request.predicate = NSPredicate(format: "categoryName == '生日'", "")
        var items: [Item] = []
        do {
            items = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        let currentDate = Date()
        for hourOffset in 0 ..< 30   {
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

struct TimeSheetBirthdayWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("生日")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color("BlueColor"))
                    .frame(height: 50)
                Spacer()
            }.padding(.horizontal)
            
            if entry.items.count == 0 {
                Text("暂无生日日程")
                    .foregroundColor(Color("GrayColor"))
                    .frame(maxHeight: .infinity)
            } else {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10,  content: {
                    ForEach(entry.items.suffix(widgetFamily == .systemLarge ? 3 : 2), id: \.self) {  item in
                        VStack {
                            TodoItemView(item: item)
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
struct TimeSheetBirthdayWidget: Widget {
    let kind: String = "时间表"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimeSheetBirthdayWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("时间表日程小组件")
        .description("显示生日日程事项")
    }
}

struct TimeSheetBirthdayWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimeSheetBirthdayWidgetEntryView(entry: SimpleEntry(date: Date(), items: []))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            TimeSheetBirthdayWidgetEntryView(entry: SimpleEntry(date: Date(), items: []))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

struct TodoItemView: View {
    
    @State var item: Item = Item(context: PersistenceController.shared.container.viewContext)
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: item.content!)
                    .strikethrough(item.end, color: Color("GrayColor"))
                    .lineLimit(3)
                    .font(.system(size: 16.5, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(item.end ? Color("GrayColor") : .primary)
                Spacer()
            }
            HStack {
                if item.important {
                    Text("重要")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(item.end ? Color("GrayColor") : Color.pink)
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(item.end ? Color("GrayColor") : Color.pink)
                        ).padding(.leading, 1)
                }
                if item.lunarCalendar != nil && !item.lunarCalendar!.isEmpty {
                    Text(item.lunarCalendar ?? "")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(item.end ? Color("GrayColor") : Color.purple)
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(item.end ? Color("GrayColor") : Color.purple)
                        ).padding(.leading, 1)
                }
                Text(item.allday ? "全天" : item.time!.timeString())
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(item.end ? Color("GrayColor") : item.date!.compareCurrentTime(item.time!) == "已过期" ? item.allday ? Color("GrayColor") : Color.pink : Color("GrayColor"))
                
                if item.postpone {
                    Text("顺")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(item.end ? Color("GrayColor") : Color("BlueColor"))
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(item.end ? Color("GrayColor") : Color("BlueColor"))
                        )
                }
                if item.categoryName != nil && !item.categoryName!.isEmpty {
                    if item.end {
                        TagView(title: item.categoryName ?? "" , color: Color("GrayColor"))
                    } else {
                        TagView(title: item.categoryName ?? "" , color: Color("BlueColor"))
                    }
                }
                if item.repeatType > 0 {
                    if item.end {
                        TagView(title: "\(repeatString(Int(item.repeatType)))重复",
                                color: Color("GrayColor"),
                                textcolor: Color("GrayColor"))
                    } else {
                        TagView(title: "\(repeatString(Int(item.repeatType)))重复",
                                color: .purple,
                                textcolor: .primary)
                    }
                }
                Spacer()
                if !item.end {
                    Text(verbatim: item.date!.compareCurrentTime(item.time!))
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(item.date!.compareCurrentTime(item.time!) == "已过期" ? Color.pink : Color("GrayColor"))
                }
            }
        }
    }
}

struct TagView: View {
    
    @State var title = "生活"
    @State var color = Color("BlueColor")
    @State var textcolor = Color.primary
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title).font(.system(size: 10, weight: .regular, design: .rounded))
                .frame(height: 16)
                .foregroundColor(textcolor)
            Rectangle()
                .fill(color)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }.frame(width: (title.count > 4 ? 12 : 13) * CGFloat(title.count))
        .background(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color("GrayColor"))
        )
        .cornerRadius(2)
    }
}
