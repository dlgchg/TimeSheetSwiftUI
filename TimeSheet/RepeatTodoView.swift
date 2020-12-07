//
//  RepeatTodoView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI
import CoreData
import MobileCoreServices

struct RepeatTodoView: View {
    @Binding var sheet: Bool
    @Binding var newRepeatType: Int
    @Binding var searchKey: String
    @State var type: Int = 0
    @FetchRequest var repeatItems: FetchedResults<RepeatItem>
    @FetchRequest var categoryItems: FetchedResults<CategoryItem>
    
    var body: some View {
        let newItems = filerDateRepeatItem(type).filter({searchKey.isEmpty ? true : $0.content!.contains(searchKey)})
        return Section {
            HStack {
                Image("trusted1").resizable().frame(width: 20, height: 20)
                Text(repeatString(type))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .bold()
                Spacer()
                ZStack {
                    Image(systemName: "plus")
                        .foregroundColor(Color("BlueColor"))
                        .font(.title2)
                    NavigationLink(
                        destination: NewRepeatTodoView(repeatType: type),
                        label: {
                            EmptyView()
                        })
                        .opacity(0)
                        .fixedSize()
                }
            }.padding(.vertical, 10)
            ForEach(newItems) { repeatItem in
                RepeatTodoItemView(repeatItem: repeatItem, categoryItems: _categoryItems)
            }.onDelete(perform: { indexSet in
                withAnimation {
                    indexSet.map { newItems[$0] }.forEach({
                        removeNotification($0.id!.uuidString)
                        deleteRepeatChildItem(repeatItem: $0)
                        context.delete($0)
                    })
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }
    
    func filerDateRepeatItem(_ type: Int) -> [RepeatItem] {
        return repeatItems.filter({
            $0.type == type
        })
    }
}

struct RepeatTodoItemView: View {
    @AppStorage("endSound") var endSound = "默认"
    @State var typeAction = false
    @State var repeatItem: RepeatItem = RepeatItem(context: context)
    @FetchRequest var categoryItems: FetchedResults<CategoryItem>
    @State var end = false
    @State var todo = false
    @State var important = false
    @State var postpone = false
    @State var allday = false
    @State var recycle = false
    @State var categoryName = ""
    @State var edit = false
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: repeatItem.content!)
                    .strikethrough(self.end, color: Color("GrayColor"))
                    .lineLimit(3)
                    .font(.system(size: 16.5, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(self.end ? Color("GrayColor") : .primary)
                Spacer()
                Image(systemName: self.end ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .foregroundColor(Color("GrayColor"))
                    .onTapGesture {
                        shock()
                        Sounds.playSounds(soundfile: endSound)
                        withAnimation {
                            self.end.toggle()
                            repeatItem.end.toggle()
                            if repeatItem.end {
                                removeNotification(repeatItem.id!.uuidString)
                                deleteRepeatChildItem(repeatItem: repeatItem)
                            } else {
                                updateRepeatChildItem(repeatItem: repeatItem)
                            }
                        }
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
            }
            HStack {
                if !todo {
                    if important {
                        Text("重要")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(self.end ? Color("GrayColor") : Color.pink)
                            .padding(2)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(self.end ? Color("GrayColor") : Color.pink)
                            ).padding(.leading, 1)
                    }
                    if repeatItem.type == 2 || repeatItem.type == 3 {
                        Text(repeatItem.ttype ?? "")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(self.end ? Color("GrayColor") : Color.purple)
                            .padding(2)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(self.end ? Color("GrayColor") : Color.purple)
                            ).padding(.leading, 1)
                    }
                    if repeatItem.type == 5 {
                        Text(repeatItem.lunarCalendar ?? "")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(self.end ? Color("GrayColor") : Color.purple)
                            .padding(2)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(self.end ? Color("GrayColor") : Color.purple)
                            ).padding(.leading, 1)
                    }
                    Text(allday ? "全天" : repeatItem.time!.timeString())
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(Color("GrayColor"))
                    
                    if postpone {
                        Text("顺")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(self.end ? Color("GrayColor") : Color("BlueColor"))
                            .padding(2)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(self.end ? Color("GrayColor") : Color("BlueColor"))
                            )
                    }
                }
                if !categoryName.isEmpty {
                    if self.end {
                        TagView(title: categoryName, color: Color("GrayColor"), textcolor: Color("GrayColor"))
                    } else {
                        TagView(title: categoryName, color: Color("BlueColor"), textcolor: .primary)
                    }
                    
                }
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .cornerRadius(10)
        .clipped()
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .contextMenu(menuItems: {
            Button(action: {
                shock()
                withAnimation {
                    self.end.toggle()
                    repeatItem.end.toggle()
                    if repeatItem.end {
                        removeNotification(repeatItem.id!.uuidString)
                        deleteRepeatChildItem(repeatItem: repeatItem)
                    } else {
                        updateRepeatChildItem(repeatItem: repeatItem)
                    }
                }
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Label(repeatItem.end ? "开启重复" : "关闭重复", systemImage: "stop.circle")
            })
 
            Button(action: {
                shock()
                UIPasteboard.general.setValue(repeatItem.content!,
                           forPasteboardType: kUTTypePlainText as String)
            }, label: {
                Label("复制内容", systemImage: "doc.on.clipboard")
            })
            Button(action: {
                shock()
                self.typeAction.toggle()
            }, label: {
                Label("设置分类", systemImage: "greetingcard")
            })
            Button(action: {
                shock()
                self.important.toggle()
                repeatItem.important.toggle()
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
                removeNotification(repeatItem.id!.uuidString)
                deleteRepeatChildItem(repeatItem: repeatItem)
                updateRepeatChildItem(repeatItem: repeatItem)
            }, label: {
                Label(important ? "取消重要" : "设为重要", systemImage: "bookmark.circle")
            })
            Section {
                Button(action: {
                    shock()
                    removeNotification(repeatItem.id!.uuidString)
                    deleteRepeatChildItem(repeatItem: repeatItem)
                    context.delete(repeatItem)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }, label: {
                    Label("删除日程", systemImage: "trash")
                })
            }
        })
        .actionSheet(isPresented: $typeAction) {
            ActionSheet(title: Text("选择分类"),
                        message: Text("点击下方分类即可为重复设置分类"),
                        buttons: categoryItems.map({ (categoryItem) -> ActionSheet.Button in
                            ActionSheet.Button.default(Text(categoryItem.name!), action: {
                                if categoryItem.name == "未分类" {
                                    repeatItem.categoryName = ""
                                    self.categoryName = ""
                                    repeatItem.categoryId = UUID()
                                } else {
                                    repeatItem.categoryName = categoryItem.name!
                                    repeatItem.categoryId = categoryItem.id!
                                    self.categoryName = categoryItem.name!
                                }
                                do {
                                    try context.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                                removeNotification(repeatItem.id!.uuidString)
                                deleteRepeatChildItem(repeatItem: repeatItem)
                                updateRepeatChildItem(repeatItem: repeatItem)
                            })
                        })
            )
        }
        .onAppear {
            self.end = repeatItem.end
            self.important = repeatItem.important
            self.postpone = repeatItem.postpone
            self.allday = repeatItem.allday
            self.recycle = repeatItem.recycle
        }
        .sheet(isPresented: $edit, content: {
            EditRepeatTodoView(repeatId: repeatItem.id!)
        })
    }
}

