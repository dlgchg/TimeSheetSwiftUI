//
//  GearView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/24.
//

import SwiftUI

struct GearView: View {
    
    @AppStorage("showTodoInHome") var showTodoInHome = true
    @AppStorage("showEnded") var showEnded = true
    @AppStorage("newAllDay") var newAllDay = true
    @AppStorage("everyTime") var everyTime = "08:00"
    @AppStorage("openEveryTime") var openEveryTime = true
    @AppStorage("openAlldayTime") var openAlldayTime = true
    @AppStorage("everyTimeUUID") var everyTimeUUID = ""
    @AppStorage("alldayTime") var alldayTime = "15:00"
    @AppStorage("alldayTimeUUID") var alldayTimeUUID = ""
    @AppStorage("endSound") var endSound = "默认"
   
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    @State var time = "08:00".timeDate()
    @State var alltime = "08:00".timeDate()
    @State var alertTime = false
    @State var alertAllTime = false
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                List {
                    HStack {
                        Label("主页显示待办", systemImage: "house")
                        Toggle("", isOn: $showTodoInHome)
                    }
                    HStack {
                        Label("主页显示已结束", systemImage: "square.slash")
                        Toggle("", isOn: $showEnded)
                    }
                    HStack {
                        Label("新建全天", systemImage: "sun.min")
                        Toggle("", isOn: $newAllDay)
                    }
                   
                    Section {
                        NavigationLink(
                            destination: BackgroundView(),
                            label: {
                                Label("背景图片", systemImage: "photo")
                            })
//                        HStack {
//                            Label("每天8点问候", systemImage: "bell.badge")
//                            Toggle("", isOn: $openEveryTime)
//                        }
//                        if openEveryTime {
//                            HStack {
//                                Label("每天问候", systemImage: "bell")
//                                Spacer()
//                                Text(time.timeString())
//                                    .font(.system(size: 17, weight: .medium, design: .rounded))
//                                    .foregroundColor(Color("BlueColor"))
//                            }.onTapGesture {
//                                self.alertTime.toggle()
//                            }
//                        }
//                        HStack {
//                            Label("开启全天提醒", systemImage: "speaker.zzz")
//                            Toggle("", isOn: $openAlldayTime)
//                        }
//                        if openAlldayTime {
//                            HStack {
//                                Label("全天提醒", systemImage: "speaker.wave.1")
//                                Spacer()
//                                Text(alltime.timeString())
//                                    .font(.system(size: 17, weight: .medium, design: .rounded))
//                                    .foregroundColor(Color("BlueColor"))
//                            }.onTapGesture {
//                                self.alertAllTime.toggle()
//                            }
//                        }
                        Picker(selection: $endSound, label: Label("结束音效", systemImage: "music.note")) {
                            Text("默认").tag("默认")
                            Text("打卡").tag("打卡")
                            Text("键盘").tag("键盘")
                            Text("响指").tag("响指")
                        }
                    }
                    Section(footer: HStack {
                        VStack {
                            Text(NSLocalizedString("CFBundleDisplayName", comment: ""))
                                .bold()
                            Text("V \(appVersion!)")
                        }.frame(maxWidth: .infinity)
                        .padding(.top)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color("GrayColor"))
                    }) {
                        Button(action: {
                            shock()
                            fiveStar(id: "1540691610")
                        }, label: {
                            Label("给个好评", systemImage: "hand.thumbsup")
                        })
                    }
                }
                .foregroundColor(.primary)
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("设置", displayMode: .inline)
                
                TimeAlertView(time: $time, alertTime: $alertTime)
                    .zIndex(self.alertTime ? 10 : -10)
                    .opacity(self.alertTime ? 1 : 0)
                    .scaleEffect(self.alertTime ? 1 : 0.7)
                    .animation(.easeInOut(duration: 0.2))
                
                TimeAlertView(time: $alltime, alertTime: $alertAllTime)
                    .zIndex(self.alertAllTime ? 10 : -10)
                    .opacity(self.alertAllTime ? 1 : 0)
                    .scaleEffect(self.alertAllTime ? 1 : 0.7)
                    .animation(.easeInOut(duration: 0.2))
            }
        }
        .onAppear {
            time = everyTime.timeDate()
            alltime = alldayTime.timeDate()
        }
        .onDisappear {
            everyTime = time.timeString()
            alldayTime = alltime.timeString()
          
            if openEveryTime {
                setTomorrowNotification(date: everyTime.timeDate(), uuidString: everyTimeUUID)
            } else {
                removeNotification(everyTimeUUID)
            }
            if openAlldayTime {
                addNotification(content: "请打开时间表，看看今天有什么待办需要完成", date: alldayTime.timeDate(), uuidString: alldayTimeUUID, eventRepeat: "每天重复", notification: "", isbadge: false)
            } else {
                removeNotification(alldayTimeUUID)
            }
        }
    }
}

struct GearView_Previews: PreviewProvider {
    static var previews: some View {
        GearView()
    }
}
