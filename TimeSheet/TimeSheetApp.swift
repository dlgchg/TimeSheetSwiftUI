//
//  TimeSheetApp.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/24.
//

import SwiftUI
import CoreData

@main
struct TimeSheetApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("firstOpenApp") var firstOpenApp = true
    @AppStorage("openEveryTime") var openEveryTime = true
    @AppStorage("everyTime") var everyTime = "08:00"
    @AppStorage("everyTimeUUID") var everyTimeUUID = ""
    @AppStorage("alldayTime") var alldayTime = "15:00"
    @AppStorage("alldayTimeUUID") var alldayTimeUUID = ""
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    @FetchRequest(
        entity: RepeatItem.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \RepeatItem.create, ascending: true),
        ],
        predicate: NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "recycle == %d", false),
            NSPredicate(format: "end == %d", false)
        ]),
        animation: .spring())
    var repeatItems: FetchedResults<RepeatItem>
    
    init() {
        //        UITableView.appearance().backgroundColor = UIColor(Color("BgColor"))
        UITableView.appearance().backgroundColor = UIColor.clear
        UISegmentedControl.appearance().backgroundColor = UIColor.white
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("BlueColor"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    if firstOpenApp {
                        firstOpenApp.toggle()
                        everyTimeUUID = UUID().uuidString
                        alldayTimeUUID = UUID().uuidString
                        addNotification(content: "请打开时间表，看看今天有什么待办需要完成", date: alldayTime.timeDate(), uuidString: alldayTimeUUID, eventRepeat: "每天重复", notification: "", isbadge: false)
                    }
                    let request = NSFetchRequest<Item>(entityName: "Item")
                    request.fetchLimit = 1
                    request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.date, ascending: false)]
                    repeatItems.forEach { repeatItem in
                        request.predicate = NSPredicate(format: "repeatId == %@", repeatItem.id! as CVarArg)
                        do {
                            let items = try persistenceController.container.viewContext.fetch(request)
                            if items.count > 0 && !items[0].date!.timeDiff(items[0].time!){
                                updateRepeatChildItem(repeatItem: repeatItem)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        if categoryItems.count == 0 {
                            let categorys = ["未分类", "工作","生活","理财","生日","其它"]
                            for (i, category) in categorys.enumerated() {
                                let categoryItem = CategoryItem(context: context)
                                categoryItem.id = UUID()
                                categoryItem.order = Int16(i - 1)
                                categoryItem.name = category
                                categoryItem.color = ""
                            }
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            removeRepeatCategory(categoryItems: categoryItems)
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
                    if openEveryTime {
                        setTomorrowNotification(date: everyTime.timeDate(), uuidString: everyTimeUUID)
                    }
                })
        }
    }
}

func openEmail() {
    let email = "curmido@gmail.com"
    if let url = URL(string: "mailto:\(email)") {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

func fiveStar(id: String) {
    let url  = URL(string: "itms-apps://itunes.apple.com/app/id\(id)")
    if UIApplication.shared.canOpenURL(url!) == true  {
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


