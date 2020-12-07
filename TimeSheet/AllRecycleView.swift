//
//  AllRecycleView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct AllRecycleView: View {
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.allday, ascending: false),
            NSSortDescriptor(keyPath: \Item.time, ascending: true),
            NSSortDescriptor(keyPath: \Item.date, ascending: true),
        ],
        predicate: NSCompoundPredicate(type: .or, subpredicates: [
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "postpone == %d", false),
                NSPredicate(format: "allday == %d", false),
                NSPredicate(format: "recycle == %d", true),
            ]),
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "postpone == %d", true),
                NSPredicate(format: "allday == %d", false),
                NSPredicate(format: "recycle == %d", true),
            ]),
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "postpone == %d", false),
                NSPredicate(format: "allday == %d", true),
                NSPredicate(format: "recycle == %d", true),
            ])
        ]),
        animation: .spring())
    var items: FetchedResults<Item>
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    @Binding var searchKey: String
    @Binding var sheet: Sheet?
    @Binding var newDate: Date
    var body: some View {
        let dates = getDates()
        return NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                List {
                    RecycleTodoView(sheet: $sheet, searchKey: $searchKey, hiddenNew: true)
                    if dates.count > 0 {
                        ForEach(0..<dates.count, id: \.self) { i in
                            DayTodoView(sheet: $sheet, newDate: $newDate, searchKey: $searchKey, date: dates[i], items: _items, categoryItems: _categoryItems)
                        }
                    } else {
                        Text("暂无日程")
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color("GrayColor"))
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("已归档", displayMode: .inline)
            }
        }
    }
    func getDates() -> [Date] {
        var dates: [Date] = []
        items.forEach { item in
            let fs = dates.filter{($0.dateString() == item.date!.dateString())}
            if fs.count == 0 {
                dates.append(item.date!)
            }
        }
        return dates
    }
}

struct AllRecycleView_Previews: PreviewProvider {
    static var previews: some View {
        AllRecycleView(searchKey: .constant(""), sheet: .constant(nil), newDate: .constant(Date()))
    }
}
