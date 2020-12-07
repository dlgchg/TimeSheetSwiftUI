//
//  CoreDataUtil.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/26.
//

import SwiftUI
import CoreData

func deleteRepeatChildItem(repeatItem: RepeatItem) {
    let request = NSFetchRequest<Item>(entityName: "Item")
    request.predicate = NSPredicate(format: "repeatId == %@", repeatItem.id! as CVarArg)
    do {
        let items = try context.fetch(request)
        items.forEach(context.delete)
        try context.save()
    } catch {
        print(error.localizedDescription)
    }
}

func updateRepeatChildItem(repeatItem: RepeatItem) {
    if repeatItem.type == 1 {
        for i in (repeatItem.date!.timeDiff(repeatItem.time!) ? 0 : 1)...((repeatItem.date!.timeDiff(repeatItem.time!) ? 6 : 7)) {
            let item = Item(context: context)
            item.date = repeatItem.date!.nextDayDate(i).date()
            item.time = repeatItem.time
            item.allday = repeatItem.allday
            item.postpone = repeatItem.postpone
            item.content = repeatItem.content
            item.create = Date()
            item.end = false
            item.id = UUID()
            item.recycle = false
            item.repeatType = Int16(repeatItem.type)
            item.repeatTime = repeatItem.time
            item.repeatDate = repeatItem.date!.date()
            item.repeatId = repeatItem.id
            item.categoryName = repeatItem.categoryName
            item.categoryId = repeatItem.categoryId
            item.important = repeatItem.important
            item.sound = repeatItem.sound
            item.lunarCalendar = repeatItem.lunarCalendar
        }
    }
    if repeatItem.type == 2 {
        for i in 0..<5 {
            let item = Item(context: context)
            let week = repeatInt(repeatItem.ttype!)
            let nowWeek = Date().week()
            if week > nowWeek {
                let nweek = week - nowWeek
                item.date = Date().nextDayDate(i * 7 + nweek).date()
            } else if week < nowWeek {
                let nweek = week - nowWeek
                item.date = Date().nextDayDate((i + 1) * 7 + abs(nweek)).date()
            } else {
                item.date = Date().nextDayDate(i * 7).date()
            }
            print(item.date!.dateString())
            item.time = repeatItem.time
            item.allday = repeatItem.allday
            item.postpone = repeatItem.postpone
            item.content = repeatItem.content
            item.create = Date()
            item.end = false
            item.id = UUID()
            item.recycle = false
            item.repeatType = Int16(repeatItem.type)
            item.repeatTime = repeatItem.time
            item.repeatDate = repeatItem.date!.date()
            item.repeatId = repeatItem.id
            item.categoryName = repeatItem.categoryName
            item.categoryId = repeatItem.categoryId
            item.important = repeatItem.important
            item.sound = repeatItem.sound
            item.lunarCalendar = repeatItem.lunarCalendar
        }
    }
    if repeatItem.type == 3 {
        for i in 0..<5 {
            let item = Item(context: context)
            let day = Int(String(repeatItem.ttype!.prefix(1)))
            let nowDay = Date().day()
            var nextMonthDate: Date
            if day! >= nowDay {
                nextMonthDate = Date().nextMonthDayDate(i)
            } else {
                nextMonthDate = Date().nextMonthDayDate(i + 1)
            }
            let nextMonthMaxDays = nextMonthDate.monthMaxDays()
            print("\(day!)")
            item.date = nextMonthDate.setDay(day! > nextMonthMaxDays ? nextMonthMaxDays : day!).date()
            print(item.date!.dateString())
            item.time = repeatItem.time
            item.allday = repeatItem.allday
            item.postpone = repeatItem.postpone
            item.content = repeatItem.content
            item.create = Date()
            item.end = false
            item.id = UUID()
            item.recycle = false
            item.repeatType = Int16(repeatItem.type)
            item.repeatTime = repeatItem.time
            item.repeatDate = repeatItem.date!.date()
            item.repeatId = repeatItem.id
            item.categoryName = repeatItem.categoryName
            item.categoryId = repeatItem.categoryId
            item.important = repeatItem.important
            item.sound = repeatItem.sound
            item.lunarCalendar = repeatItem.lunarCalendar
            if !repeatItem.allday {
                addItemNotification(item: item, eventRepeat: "每月重复", notification: "")
            }
        }
    }
    
    if repeatItem.type == 4 || repeatItem.type == 5 {
        let item = Item(context: context)
        item.date = repeatItem.date!.nextYearDate().date()
        item.time = repeatItem.time
        item.allday = repeatItem.allday
        item.postpone = repeatItem.postpone
        item.content = repeatItem.content
        item.create = Date()
        item.end = false
        item.id = UUID()
        item.recycle = false
        item.repeatType = Int16(repeatItem.type)
        item.repeatTime = repeatItem.time
        item.repeatDate = repeatItem.date!.date()
        item.repeatId = repeatItem.id
        item.categoryName = repeatItem.categoryName
        item.categoryId = repeatItem.categoryId
        item.important = repeatItem.important
        item.sound = repeatItem.sound
        item.lunarCalendar = repeatItem.lunarCalendar
    }
    if repeatItem.type != 3 && !repeatItem.allday {
        addIRepeattemNotification(item: repeatItem)
    }
    do {
        try context.save()
    } catch {
        print(error.localizedDescription)
    }
}
