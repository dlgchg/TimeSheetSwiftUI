//
//  DayTodoView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/24.
//

import SwiftUI
import CoreData

struct DayTodoView: View {
    @Binding var sheet: Sheet?
    @Binding var newDate: Date
    @Binding var searchKey: String
    @State var date: Date = Date().date()
    @FetchRequest var items: FetchedResults<Item>
    @FetchRequest var categoryItems: FetchedResults<CategoryItem>
    @State var showAll = false
    var body: some View {
        let newItems = filerDateItem(date).filter({searchKey.isEmpty ? true : ($0.content!.contains(searchKey) || $0.important == (searchKey.contains("重要") ? true : false))})
        return Section(header: HStack {
            Text(date.mdString()).padding(.leading)
            Text("农历 \(date.solarToLunar())")
        }) {
            HStack {
                Image("trusted1").resizable().frame(width: 20, height: 20)
                Text(date.weekString())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .bold()
                Text(date.compareCurrentDate())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .bold()
                    .foregroundColor(Color("BlueColor"))
                Spacer()
                if searchKey.isEmpty {
                Image(systemName: "plus")
                    .foregroundColor(Color("BlueColor"))
                    .font(.title2)
                    .onTapGesture {
                        shock()
                        self.newDate = date
                        self.sheet = .new
                    }
                }
            }.padding(.vertical, 10)
            ForEach(date.dateString() == Date().dateString() ? newItems : (showAll ? newItems.suffix(4) : newItems)) { item in
                TodoItemView(categoryItems: _categoryItems, item: item)
            }.onDelete(perform: { indexSet in
                withAnimation {
                    indexSet.map { newItems[$0] }.forEach(context.delete)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            if date.dateString() != Date().dateString() && searchKey.isEmpty {
                if newItems.count > 4 {
                    Text(self.showAll ? "隐藏部分" : "展开全部")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color("GrayColor"))
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            shock()
                            self.showAll.toggle()
                        }
                }
            }
           
        }
    }
    
    
    func filerDateItem(_ date: Date) -> [Item] {
        return items.filter({
            $0.date!.dateString() == date.dateString()
        })
    }
}
