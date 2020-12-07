//
//  Utils.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/27.
//

import SwiftUI
import AVKit
import UserNotifications
import WidgetKit
import CoreData
import Foundation

let context = PersistenceController.shared.container.viewContext

class Sounds {
    static func playSounds(soundfile: String) {
        var sound: SystemSoundID = 0
        if let path = Bundle.main.url(forResource: soundfile, withExtension: nil){
            AudioServicesCreateSystemSoundID(path as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}

class LunarToSolar {
    static var lunar_month_days = [
        1887, 0x1694, 0x16aa, 0x4ad5, 0xab6, 0xc4b7, 0x4ae, 0xa56, 0xb52a, 0x1d2a,
        0xd54, 0x75aa, 0x156a, 0x1096d, 0x95c, 0x14ae, 0xaa4d, 0x1a4c, 0x1b2a,
        0x8d55, 0xad4, 0x135a, 0x495d, 0x95c, 0xd49b, 0x149a, 0x1a4a, 0xbaa5, 0x16a8,
        0x1ad4, 0x52da, 0x12b6, 0xe937, 0x92e, 0x1496, 0xb64b, 0xd4a, 0xda8, 0x95b5,
        0x56c, 0x12ae, 0x492f, 0x92e, 0xcc96, 0x1a94, 0x1d4a, 0xada9, 0xb5a, 0x56c,
        0x726e, 0x125c, 0xf92d, 0x192a, 0x1a94, 0xdb4a, 0x16aa, 0xad4, 0x955b,
        0x4ba, 0x125a, 0x592b, 0x152a, 0xf695, 0xd94, 0x16aa, 0xaab5, 0x9b4, 0x14b6,
        0x6a57, 0xa56, 0x1152a, 0x1d2a, 0xd54, 0xd5aa, 0x156a, 0x96c, 0x94ae, 0x14ae,
        0xa4c, 0x7d26, 0x1b2a, 0xeb55, 0xad4, 0x12da, 0xa95d, 0x95a, 0x149a, 0x9a4d,
        0x1a4a, 0x11aa5, 0x16a8, 0x16d4, 0xd2da, 0x12b6, 0x936, 0x9497, 0x1496,
        0x1564b, 0xd4a, 0xda8, 0xd5b4, 0x156c, 0x12ae, 0xa92f, 0x92e, 0xc96, 0x6d4a,
        0x1d4a, 0x10d65, 0xb58, 0x156c, 0xb26d, 0x125c, 0x192c, 0x9a95, 0x1a94,
        0x1b4a, 0x4b55, 0xad4, 0xf55b, 0x4ba, 0x125a, 0xb92b, 0x152a, 0x1694, 0x96aa,
        0x15aa, 0x12ab5, 0x974, 0x14b6, 0xca57, 0xa56, 0x1526, 0x8e95, 0xd54, 0x15aa,
        0x49b5, 0x96c, 0xd4ae, 0x149c, 0x1a4c, 0xbd26, 0x1aa6, 0xb54, 0x6d6a, 0x12da,
        0x1695d,0x95a, 0x149a, 0xda4b, 0x1a4a, 0x1aa4, 0xbb54, 0x16b4, 0xada, 0x495b,
        0x936, 0xf497, 0x1496, 0x154a, 0xb6a5, 0xda4, 0x15b4, 0x6ab6, 0x126e, 0x1092f,
        0x92e, 0xc96, 0xcd4a, 0x1d4a, 0xd64, 0x956c, 0x155c, 0x125c, 0x792e, 0x192c,
        0xfa95, 0x1a94, 0x1b4a, 0xab55, 0xad4, 0x14da, 0x8a5d, 0xa5a, 0x1152b, 0x152a,
        0x1694, 0xd6aa, 0x15aa, 0xab4, 0x94ba, 0x14b6, 0xa56, 0x7527, 0xd26, 0xee53,
        0xd54, 0x15aa, 0xa9b5, 0x96c, 0x14ae, 0x8a4e, 0x1a4c, 0x11d26, 0x1aa4, 0x1b54,
        0xcd6a, 0xada, 0x95c, 0x949d, 0x149a, 0x1a2a, 0x5b25, 0x1aa4, 0xfb52, 0x16b4,
        0xaba, 0xa95b, 0x936, 0x1496, 0x9a4b, 0x154a, 0x136a5, 0xda4, 0x15ac ]
    
    static var solar_1_1 = [
        1887, 0xec04c, 0xec23f, 0xec435, 0xec649, 0xec83e, 0xeca51, 0xecc46, 0xece3a,
        0xed04d, 0xed242, 0xed436, 0xed64a, 0xed83f, 0xeda53, 0xedc48, 0xede3d,
        0xee050, 0xee244, 0xee439, 0xee64d, 0xee842, 0xeea36, 0xeec4a, 0xeee3e,
        0xef052, 0xef246, 0xef43a, 0xef64e, 0xef843, 0xefa37, 0xefc4b, 0xefe41,
        0xf0054, 0xf0248, 0xf043c, 0xf0650, 0xf0845, 0xf0a38, 0xf0c4d, 0xf0e42,
        0xf1037, 0xf124a, 0xf143e, 0xf1651, 0xf1846, 0xf1a3a, 0xf1c4e, 0xf1e44,
        0xf2038, 0xf224b, 0xf243f, 0xf2653, 0xf2848, 0xf2a3b, 0xf2c4f, 0xf2e45,
        0xf3039, 0xf324d, 0xf3442, 0xf3636, 0xf384a, 0xf3a3d, 0xf3c51, 0xf3e46,
        0xf403b, 0xf424e, 0xf4443, 0xf4638, 0xf484c, 0xf4a3f, 0xf4c52, 0xf4e48,
        0xf503c, 0xf524f, 0xf5445, 0xf5639, 0xf584d, 0xf5a42, 0xf5c35, 0xf5e49,
        0xf603e, 0xf6251, 0xf6446, 0xf663b, 0xf684f, 0xf6a43, 0xf6c37, 0xf6e4b,
        0xf703f, 0xf7252, 0xf7447, 0xf763c, 0xf7850, 0xf7a45, 0xf7c39, 0xf7e4d,
        0xf8042, 0xf8254, 0xf8449, 0xf863d, 0xf8851, 0xf8a46, 0xf8c3b, 0xf8e4f,
        0xf9044, 0xf9237, 0xf944a, 0xf963f, 0xf9853, 0xf9a47, 0xf9c3c, 0xf9e50,
        0xfa045, 0xfa238, 0xfa44c, 0xfa641, 0xfa836, 0xfaa49, 0xfac3d, 0xfae52,
        0xfb047, 0xfb23a, 0xfb44e, 0xfb643, 0xfb837, 0xfba4a, 0xfbc3f, 0xfbe53,
        0xfc048, 0xfc23c, 0xfc450, 0xfc645, 0xfc839, 0xfca4c, 0xfcc41, 0xfce36,
        0xfd04a, 0xfd23d, 0xfd451, 0xfd646, 0xfd83a, 0xfda4d, 0xfdc43, 0xfde37,
        0xfe04b, 0xfe23f, 0xfe453, 0xfe648, 0xfe83c, 0xfea4f, 0xfec44, 0xfee38,
        0xff04c, 0xff241, 0xff436, 0xff64a, 0xff83e, 0xffa51, 0xffc46, 0xffe3a,
        0x10004e, 0x100242, 0x100437, 0x10064b, 0x100841, 0x100a53, 0x100c48,
        0x100e3c, 0x10104f, 0x101244, 0x101438, 0x10164c, 0x101842, 0x101a35,
        0x101c49, 0x101e3d, 0x102051, 0x102245, 0x10243a, 0x10264e, 0x102843,
        0x102a37, 0x102c4b, 0x102e3f, 0x103053, 0x103247, 0x10343b, 0x10364f,
        0x103845, 0x103a38, 0x103c4c, 0x103e42, 0x104036, 0x104249, 0x10443d,
        0x104651, 0x104846, 0x104a3a, 0x104c4e, 0x104e43, 0x105038, 0x10524a,
        0x10543e, 0x105652, 0x105847, 0x105a3b, 0x105c4f, 0x105e45, 0x106039,
        0x10624c, 0x106441, 0x106635, 0x106849, 0x106a3d, 0x106c51, 0x106e47,
        0x10703c, 0x10724f, 0x107444, 0x107638, 0x10784c, 0x107a3f, 0x107c53,
        0x107e48 ]
    
    static func GetBitInt(data:Int, length:Int, shift:Int) -> Int {
        return (data&(((1<<length)-1)<<shift))>>shift
        
    }
    
    static func SolarToInt(year:Int, month:Int, day:Int) -> Int {
        let m = (month + 9) % 12
        let y = year - m / 10
        
        return 365 * y + y / 4 - y / 100 + y / 400 + (m * 306 + 5) / 10 + (day - 1)
    }
    
    static func SolarFromInt(g:Int) -> (Int, Int, Int){
        var y = (10000*g+14780)/3652425
        var ddd = g-(365*y+y/4-y/100+y/400)
        if ddd < 0 {
            y=y-1
            ddd = g-(365*y+y/4-y/100+y/400)
        }
        let mi = (100*ddd+52)/3060
        let mm = (mi+2)%12+1
        y = y+(mi+2)/12
        let dd = ddd-(mi*306+5)/10+1
        //return "\(y) \(mm) \(dd)"
        return (y, mm, dd)
    }
    
    static func convert(year: Int, month: Int, day: Int) -> (Int, Int, Int){
        //闰月范围1950-2050，如需要增加，自行增加
        //也就是说在1950-2050之外的阴历时间计算阳历，你需要自己给闰月。不然闰月计算阳历会出错
        let leapDic = [1952:5, 1955:3, 1957:8, 1960:6, 1963:4, 1966:3, 1968:7,
                       1971:5, 1974:4, 1976:8, 1979:6, 1982:4, 1984:10, 1987:6,
                       1990:5, 1993:3, 1995:8, 1998:5, 2001:4, 2004:2, 2006:7,
                       2009:5, 2012:4, 2014:9, 2017:6, 2020:4, 2023:2, 2025:6,
                       2028:5, 2031:3, 2033:11, 2036:6, 2039:5, 2042:2, 2044:7,
                       2047:5, 2050:3]
        let days = lunar_month_days[year-lunar_month_days[0]]
        let leap = GetBitInt(data: days, length: 4, shift: 13)
        var offset = 0
        var loopend = leap
        //判断是否是闰月
        var isleap = false
        if leapDic.keys.contains(year) {
            if leapDic[year] == month {
                isleap = true
            } else {
                    isleap = false
                
                }
        }
        print("该农历日期是否闰月:\(isleap)")
        
        if !isleap {
            if month <= leap || leap == 0 {
                loopend = month-1
            } else {
                    loopend = month
                    
                }
        }
        for i in 0..<loopend {
            offset += GetBitInt(data: days, length: 1, shift: 12-i) == 1 ? 30 : 29
        }
        offset += day
        let solar11 = solar_1_1[year-solar_1_1[0]]
        let y = GetBitInt(data: solar11, length: 12, shift: 9)
        let m = GetBitInt(data: solar11, length: 4, shift: 5)
        let d = GetBitInt(data: solar11, length: 5, shift: 0)
        let g = SolarToInt(year: y, month: m, day: d)+offset-1
        return SolarFromInt(g: g)
    }
    
}

func shock() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
}

let sounds = ["默认","猫叫","狗叫","完成","叮玲玲","叮玲玲2", "生日快乐","弹簧","乌鸦","胜利","电吉他","起床","钢琴","幻想","欢快","爵士"]

let lunarMonths = ["正月","二月","三月","四月","五月","六月","七月","八月","九月","十月","冬月","腊月"]

let lunarDays: [String] = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
                 "十一","十二","十三","十四","十五","十六","十七","十八","十九","廿十",
                 "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]

func lunarMonthDays(_ lunarMonth: String) -> Array<String> {
    if lunarMonth == "正月" || lunarMonth == "三月" || lunarMonth == "五月" || lunarMonth == "七月" || lunarMonth == "八月"  || lunarMonth == "十月"  || lunarMonth == "腊月"{
        return Array(lunarDays.prefix(30))
    }
    return Array(lunarDays.prefix(29))
}

func repeatString(_ type: Int) -> String {
    switch type {
    case 1:
        return "每天"
    case 2:
        return "每周"
    case 3:
        return "每月"
    case 4:
        return "每年"
    case 5:
        return "每年农历"
    default:
        return "每天"
    }
}

func repeatInt(_ type: String) -> Int {
    switch type {
    case "周一":
        return 1
    case "周二":
        return 2
    case "周三":
        return 3
    case "周四":
        return 4
    case "周五":
        return 5
    case "周六":
        return 6
    case "周日":
        return 7
    default:
        return 7
    }
}

func addIRepeattemNotification(item: RepeatItem) {
    removeNotification(item.id!.uuidString)
    WidgetCenter.shared.reloadAllTimelines()
    let nContent = UNMutableNotificationContent()
    if item.sound == nil || item.sound!.isEmpty || item.sound! == "默认" {
        nContent.sound = UNNotificationSound.default
    } else {
        let index = sounds.firstIndex(where: {$0 == item.sound!})
        nContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(item.sound!).\(index! >= 10 ? "caf" : "mp3")"))
    }
    nContent.body = item.content!
    nContent.badge = 1
    let date = item.date!.datetime(item.time!)
    print(date.completeDate())
    var dateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: date)
    if item.type == 1 {
        nContent.title = "每天重复"
        dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
    }
    if item.type == 2 {
        nContent.title = "每周重复"
        dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
    }
    if item.type == 3 {
        nContent.title = "每月重复"
        dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
    }
    if item.type == 4 {
        nContent.title = "每年重复"
        dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
    }
    print(dateComponents)
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: item.id!.uuidString,
                content: nContent, trigger: trigger)
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { setting in
        if (setting.authorizationStatus == .authorized) {
            center.add(request) { err in
                print(err ?? "")
            }
        } else {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    center.add(request)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

func addItemNotification(item: Item, eventRepeat: String, notification: String) {
    removeNotification(item.id!.uuidString)
    WidgetCenter.shared.reloadAllTimelines()
    let nContent = UNMutableNotificationContent()
    if item.sound == nil || item.sound!.isEmpty || item.sound! == "默认" {
        nContent.sound = UNNotificationSound.default
    } else {
        nContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(item.sound!).mp3"))
    }
    nContent.body = item.content!
    nContent.title = "时间表提醒你"
    let date = item.date!.datetime(item.time!)
    var dateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: date)
    if !eventRepeat.isEmpty {
        nContent.title = eventRepeat
    }
    switch item.repeatType {
    case 1:
        dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
    case 2:
        dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
    case 3:
        dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
    case 4:
        dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
    default:
        dateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: date)
    }
    if notification == "提前1小时提醒" {
        dateComponents.hour = dateComponents.hour! - 1
    }
    if notification == "提前1天提醒" {
        dateComponents.day = dateComponents.day! - 1
    }
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents, repeats: false)
    
    let request = UNNotificationRequest(identifier: item.id!.uuidString,
                content: nContent, trigger: trigger)
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { setting in
        if (setting.authorizationStatus == .authorized) {
            center.add(request)
        } else {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    center.add(request)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

func addNotification(content: String, date: Date, uuidString: String, eventRepeat: String, notification: String, isbadge: Bool = true, sound: String = "", isCompleted: Bool = false) {
    removeNotification(uuidString)
    WidgetCenter.shared.reloadAllTimelines()
    let nContent = UNMutableNotificationContent()
    nContent.badge = 1
    if sound.isEmpty {
        nContent.sound = UNNotificationSound.default
    } else {
        nContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).mp3"))
    }
    nContent.body = content
    var dateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour, .minute], from: date)
    if eventRepeat == "每天重复" {
        dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
    }
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents, repeats: eventRepeat != "关闭")
    
    let request = UNNotificationRequest(identifier: uuidString,
                content: nContent, trigger: trigger)
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { setting in
        if (setting.authorizationStatus == .authorized) {
            center.add(request)
        } else {
            center.requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    center.add(request)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

func removeNotification(_ uuidString: String) {
    WidgetCenter.shared.reloadAllTimelines()
    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
       var identifiers: [String] = []
       for notification:UNNotificationRequest in notificationRequests {
           if notification.identifier == uuidString {
              identifiers.append(notification.identifier)
           }
       }
       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

func removeRepeatCategory(categoryItems: FetchedResults<CategoryItem>) {
    var categorys: [String] = []
    for categoryItem in categoryItems {
        if categorys.contains(categoryItem.name!) {
            context.delete(categoryItem)
        } else {
            categorys.append(categoryItem.name!)
        }
    }
}

func setTomorrowNotification(date: Date, uuidString: String) {
    let request = NSFetchRequest<Item>(entityName: "Item")
    request.predicate = NSPredicate(format: "date == %@", Date().nextDayDate(date.timeHMDiff() ? 0 : 1).date() as CVarArg)
    request.sortDescriptors =  [
        NSSortDescriptor(keyPath: \Item.allday, ascending: false),
        NSSortDescriptor(keyPath: \Item.time, ascending: true),
        NSSortDescriptor(keyPath: \Item.date, ascending: true),
    ]
    request.predicate = NSCompoundPredicate(type: .or, subpredicates: [
        NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "date == %@", Date().nextDayDate(1).date() as CVarArg),
            NSPredicate(format: "postpone == %d", false),
            NSPredicate(format: "allday == %d", false),
            NSPredicate(format: "recycle == %d", false),
        ]),
        NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "date == %@", Date().nextDayDate(1).date() as CVarArg),
            NSPredicate(format: "postpone == %d", true),
            NSPredicate(format: "allday == %d", false),
            NSPredicate(format: "recycle == %d", false),
        ]),
        NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "date == %@", Date().nextDayDate(1).date() as CVarArg),
            NSPredicate(format: "postpone == %d", false),
            NSPredicate(format: "allday == %d", true),
            NSPredicate(format: "recycle == %d", false),
        ])
    ])
    do {
        let items = try context.fetch(request)
        var content = ""
        if items.count > 0 {
            content += "时间表提醒你,你今天有\(items.count)个日程,"
            content += "第一个在\(items[0].time!.timeString()),日程内容为:\n<\(items[0].content!)>"
            var time = items[0].time!
            if time.hour() > 8 {
                time = date
            } else {
                time = items[0].time!.setHour(-1).time()
            }
            addNotification(content: content, date: time, uuidString: uuidString, eventRepeat: "每天重复", notification: "", isbadge: false, sound: "")
        } else {
            content += "请打开时间表，看看今天有什么安排吧"
            addNotification(content: content, date: date, uuidString: uuidString, eventRepeat: "每天重复", notification: "", isbadge: false, sound: "")
        }
       
    } catch {
        print(error.localizedDescription)
    }
}
