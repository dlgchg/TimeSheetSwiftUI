//
//  TodoItemView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/26.
//

import SwiftUI
import MobileCoreServices
enum EditSheet: Identifiable {
    case todo, rep
    var id: Int {
        return self.hashValue
    }
}
struct TodoItemView: View {
    @AppStorage("endSound") var endSound = "默认"
    @FetchRequest var categoryItems: FetchedResults<CategoryItem>
    @State var typeAction = false
    @State var item: Item = Item(context: context)
    @State var end = false
    @State var todo = false
    @State var important = false
    @State var postpone = false
    @State var allday = false
    @State var recycle = false
    @State var categoryName = ""
    @State var editSheet: EditSheet? = nil
    @State var edit = false
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: item.content ?? "")
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
                        Sounds.playSounds(soundfile: "\(endSound).mp3")
                        withAnimation {
                            self.end.toggle()
                            item.end.toggle()
                        }
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        if item.end {
                            removeNotification(item.id!.uuidString)
                        } else {
                            if !item.allday {
                                addItemNotification(item: item, eventRepeat: "", notification: "")
                            }
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
                    if item.lunarCalendar != nil && !item.lunarCalendar!.isEmpty {
                        Text(item.lunarCalendar ?? "")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(self.end ? Color("GrayColor") : Color.purple)
                            .padding(2)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(self.end ? Color("GrayColor") : Color.purple)
                            ).padding(.leading, 1)
                    }
                    Text(allday ? "全天" : item.time == nil ? "" : item.time!.timeString())
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(self.end ? Color("GrayColor") : item.date!.compareCurrentTime(item.time!) == "已过期" ? item.allday ? Color("GrayColor") : Color.pink : Color("GrayColor"))
                    
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
                    if end {
                        TagView(title: categoryName , color: Color("GrayColor")
                                ,textcolor: Color("GrayColor"))
                            .foregroundColor(Color("GrayColor"))
                    } else {
                        TagView(title: categoryName , color: Color("BlueColor")
                                ,textcolor: .primary)
                    }
                }
                if item.repeatType > 0 {
                    if end {
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
                if !item.allday && !self.end {
                    Text(verbatim: item.date!.compareCurrentTime(item.time!))
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(item.date!.compareCurrentTime(item.time!) == "已过期" ? Color.pink : Color("GrayColor"))
                }
            }
        }
        .padding(.vertical, 10)
        .cornerRadius(10)
        .clipped()
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .contextMenu(menuItems: {
            Section {
                Button(action: {
                    shock()
                    withAnimation {
                        self.end.toggle()
                        item.end.toggle()
                    }
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    if item.end {
                        removeNotification(item.id!.uuidString)
                    } else {
                        if !item.allday {
                            addItemNotification(item: item, eventRepeat: "", notification: "")
                        }
                    }
                }, label: {
                    Label(item.end ? "开启日程" : "结束日程", systemImage: "stop.circle")
                })
                if !todo && item.repeatType <= 0 {
                    Button(action: {
                        shock()
                        self.postpone.toggle()
                        item.postpone.toggle()
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        if item.postpone && item.end {
                            removeNotification(item.id!.uuidString)
                        }
                        
                    }, label: {
                        Label(postpone ? "取消顺延" : "设为顺延", systemImage: "dock.arrow.down.rectangle")
                    })
                }
                if item.repeatType <= 0 {
                    Button(action: {
                        shock()
                        showDatePickerAlert(todo: todo)
                        if !item.allday {
                            addItemNotification(item: item, eventRepeat: "", notification: "")
                        }
                    }, label: {
                        Label(todo ? "移出待办" : "推后日程", systemImage: "arrowshape.zigzag.forward")
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
                        item.important.toggle()
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }, label: {
                        Label(important ? "取消重要" : "设为重要", systemImage: "bookmark.circle")
                    })
                }
                
            }
            Section {
                if !todo && item.repeatType <= 0 {
                    Button(action: {
                        shock()
                        item.postpone = true
                        item.allday = true
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        removeNotification(item.id!.uuidString)
                    }, label: {
                        Label("移到待办", systemImage: "move.3d")
                    })
                }
                if item.repeatType <= 0 {
                    Button(action: {
                        shock()
                        self.recycle.toggle()
                        item.recycle.toggle()
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        removeNotification(item.id!.uuidString)
                    }, label: {
                        Label(recycle ? "取消归档" : "设为归档", systemImage: "tray")
                    })
                }
                
                Button(action: {
                    shock()
                    UIPasteboard.general.setValue(item.content!,
                                                  forPasteboardType: kUTTypePlainText as String)
                }, label: {
                    Label("复制内容", systemImage: "doc.on.clipboard")
                })
            }
            
            Section {
                Button(action: {
                    shock()
                    context.delete(item)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    removeNotification(item.id!.uuidString)
                }, label: {
                    Label("删除日程", systemImage: "trash")
                })
            }
        })
        .actionSheet(isPresented: $typeAction) {
            ActionSheet(title: Text("选择分类"),
                        message: Text("点击下方分类即可为日程设置分类"),
                        buttons: categoryItems.map({ (categoryItem) -> ActionSheet.Button in
                            ActionSheet.Button.default(Text(categoryItem.name!), action: {
                                if categoryItem.name == "未分类" {
                                    item.categoryName = ""
                                    self.categoryName = ""
                                    item.categoryId = UUID()
                                } else {
                                    item.categoryName = categoryItem.name!
                                    item.categoryId = categoryItem.id!
                                    self.categoryName = categoryItem.name!
                                }
                                do {
                                    try context.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            })
                        })
            )
        }
        .onAppear {
            self.end = item.end
            self.important = item.important
            self.postpone = item.postpone
            self.allday = item.allday
            self.recycle = item.recycle
            self.categoryName = item.categoryName ?? ""
        }
        .onTapGesture {
            self.edit.toggle()
        }
        .sheet(isPresented: $edit, content: {
            if item.repeatType > 0 {
                EditRepeatTodoView(repeatId: item.repeatId!)
            } else {
                EditTodoView(item: item)
            }
        })
    }
    
    func showDatePickerAlert(todo: Bool = false) {
        let alertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.bounds = datePicker.frame.insetBy(dx: -40, dy: 0)
        alertVC.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "确认修改", style: .default) { _ in
            shock()
            item.date = datePicker.date.date()
            if todo {
                item.postpone = false
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        alertVC.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertVC.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
}

