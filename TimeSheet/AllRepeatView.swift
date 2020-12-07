//
//  AllRepeatView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct AllRepeatView: View {
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: RepeatItem.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \RepeatItem.create, ascending: true),
        ],
        predicate: NSPredicate(format: "recycle == %d", false),
        animation: .spring())
    var repeatItems: FetchedResults<RepeatItem>
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    @State var sheet = false
    @State var newRepeatType = 0
    @State var searchKey = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                List {
                    ForEach(1...5, id: \.self) { type in
                        RepeatTodoView(sheet: $sheet, newRepeatType: $newRepeatType, searchKey: $searchKey, type: type, repeatItems: _repeatItems, categoryItems: _categoryItems)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("重复日程", displayMode: .inline)
            }
        }
    }
}

struct AllRepeatView_Previews: PreviewProvider {
    static var previews: some View {
        AllRepeatView()
    }
}
