//
//  Extension.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

extension Date {
    func solarToLunar() -> String {
        //初始化公历日历
        let solarCalendar = Calendar.init(identifier: .gregorian)
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        let solarDate = solarCalendar.date(from: components)
         
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: solarDate!)
    }
    
    func date() -> Date {
        let cal = Calendar.current
        let coms = cal.dateComponents([.year, .month, .day], from: self)
        return cal.date(from: coms)!
    }
    func time() -> Date {
        let cal = Calendar.current
        let coms = cal.dateComponents([.hour, .minute], from: self)
        return cal.date(from: coms)!
    }
    
    func datetime(_ time: Date) -> Date {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let tcoms = cal.dateComponents([.hour, .minute], from: time)
        coms.hour = tcoms.hour!
        coms.minute = tcoms.minute!
        return cal.date(from: coms)!
    }

    func nextDayDate(_ day: Int) -> Date {
        let nowt = Date().timeIntervalSince1970
        let dt = self.timeIntervalSince1970
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day], from: self)
        let ncoms = cal.dateComponents([.year, .month, .day], from: Date())
        if dt < nowt {
            coms.day = ncoms.day! + day
        } else {
            coms.day = coms.day! + day
        }
        return cal.date(from: coms)!
    }
    
    func nextMonthDayDate(_ month: Int, _ day: Int = 0) -> Date {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day], from: self)
        coms.month = coms.month! + month
        coms.day = coms.day! + day
        return cal.date(from: coms)!
    }
    
    func setDay( _ day: Int = 0) -> Date {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day], from: self)
        coms.day = day
        return cal.date(from: coms)!
    }
    
    func setHour( _ hour: Int = 0) -> Date {
        let cal = Calendar.current
        var coms = cal.dateComponents([.hour, .minute], from: self)
        coms.hour = coms.hour! + hour
        return cal.date(from: coms)!
    }
    
    func nextYearDate() -> Date {
        let nowt = Date().timeIntervalSince1970
        let dt = self.timeIntervalSince1970
        if dt - nowt > 0 {
            return self
        } else {
            let cal = Calendar.current
            var coms = cal.dateComponents([.year, .month, .day], from: self)
            let now = cal.dateComponents([.year, .month, .day], from: Date())
            coms.year = now.year! + 1
            return cal.date(from: coms)!
        }
    }
    
    func nextYear(_ year: Int) -> Date {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day], from: self)
        coms.year = coms.year! + year
        return cal.date(from: coms)!
    }
    
    func maxDate() -> Date {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day], from: self)
        coms.year = coms.year! + 100
        coms.month = 12
        coms.day = 31
        return cal.date(from: coms)!
    }
    
    func monthMaxDays() -> Int {
        let cal = Calendar.current
        let coms = cal.dateComponents([.year, .month, .day], from: self)
        switch coms.month! {
        case 1,3,5,7,8,10,12:
            return 31
        case 2:
            if (coms.year! % 4 == 0 && coms.year! % 100 != 0) || coms.year! % 400 == 0 {
                return 29
            } else {
                return 20
            }
        default:
           return 20
        }
    }
    func compareCurrentDate() -> String {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let coms = calendar.dateComponents([.day], from: nowComponents, to: selfComponents)
        if self.dateString() == Date().dateString() {
            return "今天"
        }
        if coms.day! == 1 {
            return "明天"
        }
        if coms.day! == 2 {
            return "后天"
        }
        if coms.day! > 365 {
            return "\(Int(coms.day!/365))年后"
        }
        if coms.day! < 0 {
            return "\(abs(coms.day!))天前"
        }
        return "\(calendar.dateComponents([.day], from: Date(), to: self).day!)天后"
    }
    
    func timeHMDiff() -> Bool {
        let coms = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
        return coms.hour! >= 0 && coms.hour! < 8
    }
    
    func timeDiff(_ time: Date) -> Bool {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let cc = cal.dateComponents([.hour, .minute], from: time)
        coms.hour = cc.hour!
        coms.minute = cc.minute!
        let now = Date().timeIntervalSince1970
        let di = cal.date(from: coms)!.timeIntervalSince1970
        return di > now
    }
    
    
    func compareCurrentTime(_ time: Date) -> String {
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let cc = cal.dateComponents([.hour, .minute], from: time)
        coms.hour = cc.hour!
        coms.minute = cc.minute!
        let now = Date().timeIntervalSince1970
        let di = cal.date(from: coms)!.timeIntervalSince1970
        let diffTT = di - now
        if diffTT < 0 {
            return "已过期"
        }
        if diffTT/60 < 60 {
            return "\(Int(diffTT/60) + 1)分钟后"
        }
        if diffTT/(60 * 60) <= 24 {
            return "\(Int(diffTT/(60 * 60)) + 1)小时后"
        }
        if diffTT/(60 * 60)/24 > 24 && diffTT/(60 * 60)/24 <= 365 {
            return "\(Int(diffTT/(60 * 60)/24) + 1)天后"
        }
        if diffTT/(60 * 60)/24 > 365 {
            return "\(Int(diffTT/(60 * 60)/24/365))年后"
        }
        return ""
    }
    
    func dateString() -> String {
        let ma = DateFormatter()
        ma.dateFormat = "yyyy-MM-dd"
        return ma.string(from: self)
    }
    func mdString() -> String {
        let ma = DateFormatter()
        ma.dateFormat = "MM-dd"
        return ma.string(from: self)
    }
    func completeDate() -> String {
        let ma = DateFormatter()
        ma.dateFormat = "yyyy-MM-dd HH:mm"
        return ma.string(from: self)
    }
    func weekString() -> String {
        let ma = DateFormatter()
        ma.dateFormat = "EEEE"
        return ma.string(from: self)
    }
    func timeString() -> String {
        let ma = DateFormatter()
        ma.dateFormat = "HH:mm"
        return ma.string(from: self)
    }
    func year() -> Int {
        let cal = Calendar.current
        let coms = cal.dateComponents([.year], from: self)
        return coms.year!
    }
    func day() -> Int {
        let cal = Calendar.current
        let coms = cal.dateComponents([.day], from: self)
        return coms.day!
    }
    
    func month() -> Int {
        let cal = Calendar.current
        let coms = cal.dateComponents([.month], from: self)
        return coms.month!
    }
    
    func hour() -> Int {
        let cal = Calendar.current
        let coms = cal.dateComponents([.hour, .minute], from: self)
        return coms.hour!
    }
    
    func week() -> Int {
        let cal = Calendar.current
        let coms = cal.dateComponents([.weekday], from: self)
        if coms.weekday! == 1 {
            return 7
        }
        return coms.weekday! - 1
    }
    
    func weekSString() -> String {
        let cal = Calendar.current
        let coms = cal.dateComponents([.weekday], from: self)
        switch coms.weekday! {
        case 1:
            return "周日"
        case 2:
            return "周一"
        case 3:
            return "周二"
        case 4:
            return "周三"
        case 5:
            return "周四"
        case 6:
            return "周五"
        case 7:
            return "周六"
        default:
            return "周日"
        }
    }
}

extension String {
    func timeDate() -> Date {
        let ma = DateFormatter()
        ma.dateFormat = "HH:mm"
        return ma.date(from: self)!
    }
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func LunarToDate(_ noRepeat: Bool = false) -> Date {
        let year = noRepeat ? Int(self.substring(with: 0..<4)) : Date().year()
        let month = lunarMonths.firstIndex(where: {$0 == self.substring(with: noRepeat ? 5..<7 : 0..<2)})
        let day = lunarDays.firstIndex(where: {$0 == self.substring(with: noRepeat ? 7..<9 : 2..<4)})
        let solar = LunarToSolar.convert(year: year!, month: month! + 1, day: day! + 1)
        let cal = Calendar.current
        var coms = cal.dateComponents([.year, .month, .day], from: Date())
        coms.year = solar.0
        coms.month = solar.1
        coms.day = solar.2
        return cal.date(from: coms)!
    }
}

