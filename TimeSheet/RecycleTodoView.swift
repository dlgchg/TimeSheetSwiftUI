//
//  RecycleTodoView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct RecycleTodoView: View {
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.create, ascending: true),
        ],
        predicate: NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "postpone == %d", true),
            NSPredicate(format: "allday == %d", true),
            NSPredicate(format: "end == %d", false),
            NSPredicate(format: "recycle == %d", true),
        ]),
        animation: .spring())
    var items: FetchedResults<Item>
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    @Binding var sheet: Sheet?
    @Binding var searchKey: String
    @State var todoType = 0
    @State var hiddenNew = false
    var body: some View {
        Section {
            if items.count > 0 {
                ForEach(items.filter({searchKey.isEmpty ? true : $0.content!.contains(searchKey)})) { item in
                    TodoItemView(categoryItems: _categoryItems, item: item, todo: true)
                }.onDelete(perform: { indexSet in
                    withAnimation {
                        indexSet.map { items.filter({searchKey.isEmpty ? true : $0.content!.contains(searchKey)})[$0] }.forEach(context.delete)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
            } else {
                Text("暂无待办")
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("GrayColor"))
            }
            if searchKey.isEmpty && !hiddenNew{
                Text("新建待办")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("BlueColor"))
                    .onTapGesture {
                        shock()
                        self.sheet = .todo
                    }
            }
        }
    }
}

struct RecycleTodoView_Previews: PreviewProvider {
    static var previews: some View {
        RecycleTodoView(sheet: .constant(nil), searchKey: .constant(""))
    }
}
