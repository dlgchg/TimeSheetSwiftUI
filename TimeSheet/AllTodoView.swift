//
//  AllTodoView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct AllTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.create, ascending: true),
        ],
        predicate: NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "postpone == %d", true),
            NSPredicate(format: "allday == %d", true),
            NSPredicate(format: "recycle == %d", false),
        ]),
        animation: .spring())
    var items: FetchedResults<Item>
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                List {
                    if items.count > 0 {
                        ForEach(items) { item in
                            TodoItemView(categoryItems: _categoryItems, item: item, todo: true)
                        }.onDelete(perform: { indexSet in
                            withAnimation {
                                indexSet.map { items[$0] }.forEach(context.delete)
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
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("全部待办", displayMode: .inline)
            }
        }
    }
}

struct AllTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AllTodoView()
    }
}
