//
//  NewRepeatTodoView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct NewRepeatTodoView: View {
    @FetchRequest(entity: CategoryItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CategoryItem.order, ascending: true)])
    var categoryItems: FetchedResults<CategoryItem>
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("newAllDay") var newAllDay = true
    @State var todo = false
    @State var date = Date().date()
    @State var time = Date()
    
    @State var postpone = false
    @State var allday = true
    
    @State var alertDate = false
    @State var alertTime = false
    @State var alertLunar = false
    @State var content = ""
    @State var repeatType = 0
    @State var weekType = Date().weekSString()
    @State var monthType = 1
    @State var categoryType = 0
    let weeks = ["周一","周二","周三","周四","周五","周六","周日"]
    @State var sound = "默认"
   
    @State var showLunar = false
    @State var lunarCalendar = Date().solarToLunar().substring(with: 5..<9)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 5) {
                        if repeatType == 4 || repeatType == 5 {
                            HStack(spacing: 0) {
                                Text("日期选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(!self.showLunar ? .primary : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            self.showLunar.toggle()
                                        }
                                    }
                                Text("/")
                                Text("农历选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(self.showLunar ? .primary : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            self.showLunar.toggle()
                                        }
                                    }
                                Spacer()
                                if !showLunar {
                                    Button(action: {self.alertDate.toggle()}, label: {
                                        Text(date.dateString())
                                            .font(.system(size: 17, weight: .medium, design: .rounded))
                                            .foregroundColor(Color("BlueColor"))
                                            .frame(height: 40)
                                    })
                                } else {
                                    Button(action: {self.alertLunar.toggle()}, label: {
                                        Text(lunarCalendar)
                                            .font(.system(size: 17, weight: .medium, design: .rounded))
                                            .foregroundColor(Color("BlueColor"))
                                            .frame(height: 40)
                                    })
                                }
                                
                            }
                        }
                        if repeatType == 2 {
                            HStack {
                                Text("每周选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Spacer()
                                Picker(selection: $weekType,
                                       label: Text(weekType)
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40), content: {
                                    ForEach(weeks, id: \.self) { week in
                                        Text(week)
                                            .font(.system(size: 17, weight: .medium, design: .rounded))
                                            .foregroundColor(Color("BlueColor"))
                                            .frame(height: 40)
                                            .tag(week)
                                    }
                                }).pickerStyle(MenuPickerStyle())
                                
                            }
                        }
                        if repeatType == 3 {
                            HStack {
                                Text("每月选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Spacer()
                                Picker(selection: $monthType, label: Text("\(monthType)日").font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40), content: {
                                    ForEach(1...31, id: \.self) { i in
                                        Text("\(i)日")
                                            .font(.system(size: 17, weight: .medium, design: .rounded))
                                            .foregroundColor(Color("BlueColor"))
                                            .frame(height: 40)
                                            .tag(i)
                                    }
                                }).pickerStyle(MenuPickerStyle())
                                
                            }
                        }
                        Toggle(isOn: $postpone, label: {
                            Text("是否顺延")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        })
                        Toggle(isOn: $allday, label: {
                            Text("全天")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        })
                        if !allday {
                            HStack {
                                Text("时间选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Spacer()
                                Button(action: {self.alertTime.toggle()}, label: {
                                    Text(time.timeString())
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40)
                                })
                                
                            }
                        }
                        if categoryItems.count > 0 {
                            HStack {
                                Text("分类选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Spacer()
                                Picker(selection: $categoryType,
                                       label:
                                        Text(categoryItems[categoryType].name!)
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40),
                                       content: {
                                        ForEach(0..<categoryItems.count, id: \.self) { i in
                                            Text(categoryItems[i].name!)
                                                .tag(i)
                                    }
                                }).pickerStyle(MenuPickerStyle())
                                
                            }
                        }
                        if !postpone || !allday {
                            HStack {
                                Text("铃声选择")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                Button(action: {
                                    let index = sounds.firstIndex(where: {$0 == sound})
                                    if index! >= 10 {
                                        Sounds.playSounds(soundfile: "\(sound).caf")
                                    } else {
                                        Sounds.playSounds(soundfile: "\(sound).mp3")
                                    }
                                }, label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40)
                                })
                                Spacer()
                                Picker(selection: $sound,
                                       label:
                                        Text(sound)
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40),
                                       content: {
                                        ForEach(sounds, id: \.self) { sound in
                                            Text(sound)
                                                .tag(sound)
                                    }
                                }).pickerStyle(MenuPickerStyle())
                            }
                        }
                        Divider()
                        ZStack(alignment: .leading) {
                            if content.isEmpty {
                                Text("请输入内容")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                            }
                            
                            TextEditor(text: $content)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                .opacity(content.isEmpty ? 0.25 : 1)
                        }
                    }.padding()
                })
                .navigationBarTitle("新建重复", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button("取消", action: {
                    shock()
                    self.presentationMode.wrappedValue.dismiss()
                }).foregroundColor(.primary), trailing: Button("保存", action: {
                    shock()
                    let repeatItem = RepeatItem(context: context)
                    repeatItem.date = date.date()
                    if showLunar {
                        repeatItem.date = lunarCalendar.LunarToDate().date()
                        repeatItem.lunarCalendar = lunarCalendar
                        repeatType = 5
                    } else {
                        if repeatType == 5 {
                            repeatType = 4
                        }
                    }
                    repeatItem.time = time
                    repeatItem.allday = allday
                    repeatItem.postpone = postpone
                    repeatItem.content = content
                    repeatItem.create = Date()
                    repeatItem.end = false
                    repeatItem.id = UUID()
                    repeatItem.recycle = false
                    repeatItem.type = Int16(repeatType)
                    repeatItem.sound = sound
                    if repeatType == 2 {
                        repeatItem.ttype = weekType
                    }
                    if repeatType == 3 {
                        repeatItem.ttype = "\(monthType)日"
                    }
                    if categoryType - 1 == -1 {
                        repeatItem.categoryName = ""
                        repeatItem.categoryId = UUID()
                    } else {
                        if categoryItems.count > 0 {
                            repeatItem.categoryName = categoryItems[categoryType].name!
                            repeatItem.categoryId = categoryItems[categoryType].id!
                        }
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    updateRepeatChildItem(repeatItem: repeatItem)
                    self.presentationMode.wrappedValue.dismiss()
                }).foregroundColor(content.isEmpty ? Color("GrayColor") : Color("BlueColor"))
                        .disabled(content.isEmpty)
                        .animation(.linear)
                )
                .onAppear {
                    if todo {
                        postpone = true
                        allday = true
                    }
                }
                
               Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Blur(style: .systemThinMaterial))
                    .zIndex((alertDate || alertTime || alertLunar) ? 9 : -10)
                    .opacity((alertDate || alertTime || alertLunar) ? 0.1 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .animation(.default)
                    .onTapGesture {
                        alertDate = false
                        alertTime = false
                        alertLunar = false
                    }
                DateAlertView(date: $date, alertDate: $alertDate)
                    .zIndex(self.alertDate ? 10 : -10)
                    .opacity(self.alertDate ? 1 : 0)
                    .scaleEffect(self.alertDate ? 1 : 0.7)
                    .shadow(radius: 30)
                    .animation(.easeInOut(duration: 0.1))
                
                TimeAlertView(time: $time, alertTime: $alertTime)
                    .zIndex(self.alertTime ? 10 : -10)
                    .opacity(self.alertTime ? 1 : 0)
                    .scaleEffect(self.alertTime ? 1 : 0.7)
                    .shadow(radius: 30)
                    .animation(.easeInOut(duration: 0.1))
                
                LunarAlertView(lunarCalendar: $lunarCalendar, alertLunar: $alertLunar)
                    .zIndex(self.alertLunar ? 10 : -10)
                    .opacity(self.alertLunar ? 1 : 0)
                    .scaleEffect(self.alertLunar ? 1 : 0.7)
                    .shadow(radius: 30)
                    .animation(.easeInOut(duration: 0.1))
            }
            .onAppear {
                allday = newAllDay
                showLunar = repeatType == 5
                removeRepeatCategory(categoryItems: categoryItems)
            }
        }
    }
}

struct NewRepeatTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NewRepeatTodoView()
    }
}
