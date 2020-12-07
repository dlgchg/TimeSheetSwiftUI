//
//  ContentView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/24.
//

import SwiftUI
import CoreData
import MessageUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("showTodoInHome") var showTodoInHome = true
    @AppStorage("bg") var bg = ""
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.allday, ascending: false),
            NSSortDescriptor(keyPath: \Item.time, ascending: true),
            NSSortDescriptor(keyPath: \Item.date, ascending: true),
        ],
        predicate: NSCompoundPredicate(type: .or, subpredicates: [
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date >= %@", Date().date() as CVarArg),
                NSPredicate(format: "postpone == %d", false),
                NSPredicate(format: "allday == %d", false),
                NSPredicate(format: "recycle == %d", false),
            ]),
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date >= %@", Date().date() as CVarArg),
                NSPredicate(format: "postpone == %d", true),
                NSPredicate(format: "allday == %d", false),
                NSPredicate(format: "recycle == %d", false),
            ]),
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date >= %@", Date().date() as CVarArg),
                NSPredicate(format: "postpone == %d", false),
                NSPredicate(format: "allday == %d", true),
                NSPredicate(format: "recycle == %d", false),
            ])
        ]),
        animation: .spring())
    var items: FetchedResults<Item>
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.allday, ascending: false),
            NSSortDescriptor(keyPath: \Item.time, ascending: true),
            NSSortDescriptor(keyPath: \Item.date, ascending: true),
        ],
        predicate: NSCompoundPredicate(type: .or, subpredicates: [
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date < %@", Date().date() as CVarArg),
                NSPredicate(format: "postpone == %d", false),
                NSPredicate(format: "allday == %d", false),
                NSPredicate(format: "recycle == %d", false),
                NSPredicate(format: "end == %d", false),
            ]),
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date < %@", Date().date() as CVarArg),
                NSPredicate(format: "postpone == %d", true),
                NSPredicate(format: "allday == %d", false),
                NSPredicate(format: "recycle == %d", false),
                NSPredicate(format: "end == %d", false),
            ]),
            NSCompoundPredicate(type: .and, subpredicates: [
                NSPredicate(format: "date < %@", Date().date() as CVarArg),
                NSPredicate(format: "postpone == %d", false),
                NSPredicate(format: "allday == %d", true),
                NSPredicate(format: "recycle == %d", false),
                NSPredicate(format: "end == %d", false),
            ])
        ]),
        animation: .spring())
    var overDueitems: FetchedResults<Item>
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    @State var searchKey = ""
    @State var sheet: Sheet? = nil
    @State var todoType = 0
    @State var newDate = Date().date()
    var body: some View {

        NavigationView {
            ZStack {
                if !bg.isEmpty {
                    ZStack {
                        Image(bg)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                        if colorScheme == .dark {
                            Color.black.opacity(0.7)
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                } else {
                    Color("BgColor").edgesIgnoringSafeArea(.all)
                }
                List {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("搜索日程、待办", text: $searchKey, onCommit:  {
                            UIApplication.shared.endEditing()
                        })
                            .foregroundColor(searchKey.isEmpty ? .gray : .primary)
                            .keyboardType(.webSearch)
                        Text(searchKey.isEmpty ? "" : "取消")
                            .onTapGesture {
                                shock()
                                self.searchKey = ""
                                UIApplication.shared.endEditing()
                            }
                    }
                    if showTodoInHome {
                        ToDoView(sheet: $sheet, searchKey: $searchKey)
                    }
                    if getDates(items).count > 0 {
                        ForEach(0..<getDates(items).count, id: \.self) { i in
                            DayTodoView(sheet: $sheet, newDate: $newDate, searchKey: $searchKey, date: getDates(items)[i], items: _items, categoryItems: _categoryItems)
                        }
                    } else {
                        TodayEmptyView(sheet: $sheet)
                    }
                }
                .padding(.top, overDueitems.count > 0 ? 50 : 0)
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle(NSLocalizedString("CFBundleDisplayName", comment: ""), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                                        shock()
                                        self.sheet = .allrepeat}, label: {
                        Text("重复")
                            .font(.headline)
                            .foregroundColor(.primary)
//                        Image(systemName: "goforward")
                    }),
                    trailing: NavigationBarTrailingMenuView(sheet: $sheet))
                .sheet(item: $sheet) { item in
                    if item == .gear {
                        GearView()
                    }
                    if item == .new {
                        NewTodoView(date: newDate)
                    }
                    if item == .todo {
                        NewTodoView(todo: true)
                    }
                    if item == .alltodo {
                        AllTodoView()
                    }
                    if item == .allschedule {
                        AllScheduleView(searchKey: $searchKey, sheet: $sheet, newDate: $newDate)
                    }
                    if item == .recycle {
                        AllRecycleView(searchKey: $searchKey, sheet: $sheet, newDate: $newDate)
                    }
                    if item == .allrepeat {
                        AllRepeatView()
                    }
                    if item == .overdue {
                        AllOverDueView(searchKey: $searchKey, sheet: $sheet, newDate: $newDate)
                    }
                    if item == .overduenoend {
                        AllOverDueNoEndView(searchKey: $searchKey, sheet: $sheet, newDate: $newDate)
                    }
                    if item == .envelope {
                        MailView(isShowing: $sheet, result: $result)
                    }
            }
                if overDueitems.count > 0 {
                    VStack {
                        Text("过期未结束(\(overDueitems.count))")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color("RedColor"))
                            .foregroundColor(.white)
                            .onTapGesture {
                                shock()
                                self.sheet = .overduenoend
                            }
                        Spacer()
                    }
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarColor(backgroundColor: UIColor(Color("BgColor")))
    }
    
    func getDates(_ toitems: FetchedResults<Item>) -> [Date] {
        var dates: [Date] = []
        toitems.forEach { item in
            let fs = dates.filter{($0.dateString() == item.date!.dateString())}
            if fs.count == 0 {
                dates.append(item.date!)
            }
        }
        return dates.sorted()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environment(\.colorScheme, .light)
            .environment(\.locale, .init(identifier: "zh"))
    }
}

enum Sheet: Identifiable {
    case gear, new, todo, alltodo,
         allschedule, allrepeat,
         recycle, overdue, overduenoend, envelope
    
    var id: Int {
        return self.hashValue
    }
}


struct NavigationBarTrailingMenuView: View {
    
    @Binding var sheet: Sheet?
    
    var body: some View {
        Menu(content: {
            Button(action: {
                shock()
                self.sheet = .alltodo
            }, label: {
                Label("全部待办", systemImage: "network")
            })
            Button(action: {
                shock()
                self.sheet = .allschedule
            }, label: {
                Label("全部日程", systemImage: "calendar")
            })
            Button(action: {
                shock()
                self.sheet = .allrepeat
            }, label: {
                Label("重复日程", systemImage: "gobackward")
            })
            Button(action: {
                shock()
                self.sheet = .recycle
            }, label: {
                Label("已归档", systemImage: "tray.full")
            })
            Button(action: {
                shock()
                self.sheet = .overdue
            }, label: {
                Label("已过期", systemImage: "timelapse")
            })
            Section {
                Button(action: {
                    shock()
                    self.sheet = .gear
                }, label: {
                    Label("设置", systemImage: "gear")
                })
                Button(action: {
                    shock()
                    if MFMailComposeViewController.canSendMail() {
                        self.sheet = .envelope
                    } else {
                        openEmail()
                    }
                }, label: {
                    Label("意见反馈", systemImage: "envelope")
                })
            }
            
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.primary)
                .frame(width: 40, height: 40)
        })
    }
}

struct TodayEmptyView: View {
    @Binding var sheet: Sheet?
    var body: some View {
        Section(header: HStack {
            Text(Date().mdString()).padding(.leading)
            Text("农历 \(Date().solarToLunar())")
        }) {
            HStack {
                Image("trusted1").resizable().frame(width: 20, height: 20)
                Text(Date().weekString())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .bold()
                Text("今天")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .bold()
                    .foregroundColor(Color("BlueColor"))
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(Color("BlueColor"))
                    .font(.title2)
                    .onTapGesture {
                        shock()
                        self.sheet = .new
                    }
            }.padding(.vertical, 10)
            Text("暂无日程")
                .foregroundColor(Color("GrayColor"))
                .frame(maxWidth: .infinity)
                .frame(height: 100)
        }
    }
}
