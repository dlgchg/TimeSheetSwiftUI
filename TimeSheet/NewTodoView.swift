//
//  NewTodoView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct NewTodoView: View {
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
    @State var categoryType = 0
    @State var content = ""
    @State var sound = "默认"
    @State var showLunar = false
    @State var lunarCalendar = Date().solarToLunar()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 5) {
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
                .navigationBarTitle("新建日程", displayMode: .inline)
                .navigationBarItems(leading: Button("取消", action: {
                    shock()
                    self.presentationMode.wrappedValue.dismiss()
                }).foregroundColor(.primary), trailing: Button("保存", action: {
                    shock()
                    let item = Item(context: context)
                    item.date = date.date()
                    if showLunar {
                        item.date = lunarCalendar.LunarToDate(true)
                        item.lunarCalendar = lunarCalendar
                    }
                    item.time = time
                    item.allday = allday
                    item.postpone = postpone
                    item.content = content
                    item.create = Date()
                    item.end = false
                    item.id = UUID()
                    item.recycle = false
                    item.sound = sound
                    if categoryType - 1 == -1 {
                        item.categoryName = ""
                        item.categoryId = UUID()
                    } else {
                        if categoryItems.count > 0 {
                            item.categoryName = categoryItems[categoryType].name!
                            item.categoryId = categoryItems[categoryType].id!
                        }
                    }
                    do {
                        try context.save()
                        if !allday {
                            addItemNotification(item: item, eventRepeat: "", notification: "")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
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
                
                LunarAlertView(lunarCalendar: $lunarCalendar, alertLunar: $alertLunar, showYear: true)
                    .zIndex(self.alertLunar ? 10 : -10)
                    .opacity(self.alertLunar ? 1 : 0)
                    .scaleEffect(self.alertLunar ? 1 : 0.7)
                    .shadow(radius: 30)
                    .animation(.easeInOut(duration: 0.1))
            }
        }.onAppear {
            allday = newAllDay
            removeRepeatCategory(categoryItems: categoryItems)
        }
    }
}

struct NewTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NewTodoView()
    }
}

let size = UIScreen.main.bounds
