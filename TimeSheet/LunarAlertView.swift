//
//  LunarAlertView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/30.
//

import SwiftUI

struct LunarAlertView: View {
    @Binding var lunarCalendar: String
    @Binding var alertLunar: Bool
    @State var showYear = false
    @State var lunarYear = Date().solarToLunar().substring(with: 0..<5)
    @State var lunarMonth = Date().solarToLunar().substring(with: 5..<7)
    @State var lunarDay = Date().solarToLunar().substring(with: 7..<9)
    var body: some View {
        VStack(spacing: 0) {
            Text("选择农历日期")
            HStack(spacing: 0) {
                if showYear {
                    VStack {
                        Picker(selection: $lunarYear,
                               label: Text(lunarYear)
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(Color("BlueColor"))
                                        .frame(height: 40),
                               content: {
                                ForEach(0...30, id: \.self) { l in
                                    Text(Date().nextYear(l).solarToLunar().substring(with: 0..<5))
                                        .tag(Date().nextYear(l).solarToLunar().substring(with: 0..<5))
                                        .frame(width: 100)
                            }
                           })
                            .frame(width: 100)
                            .clipped()
                            .pickerStyle(WheelPickerStyle())
                    }
                }
                VStack {
                    Picker(selection: $lunarMonth,
                           label: Text(lunarMonth)
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("BlueColor"))
                                    .frame(height: 40),
                           content: {
                        ForEach(lunarMonths, id: \.self) { l in
                            Text(l).tag(l).frame(width: 100)
                        }
                       })
                        .frame(width: 100)
                        .clipped()
                        .pickerStyle(WheelPickerStyle())
                }
                VStack {
                    Picker(selection: $lunarDay,
                           label: Text(lunarDay)
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("BlueColor"))
                                    .frame(height: 40),
                           content: {
                            ForEach(lunarMonthDays(String(lunarMonth)),
                                    id: \.self) { l in
                            Text(l).tag(l).frame(width: 100)
                        }
                    })
                    .frame(width: 100)
                    .clipped()
                    .pickerStyle(WheelPickerStyle())
                }
            }
            HStack {
                Button(action: { shock()
                        self.alertLunar.toggle()}, label: {
                    Text("取消").frame(maxWidth: .infinity)
                })
                Button(action: {
                    shock()
                    self.lunarCalendar = String((showYear ? lunarYear : "")+lunarMonth+lunarDay)
                    self.alertLunar.toggle()
                }, label: {
                    Text("确认").frame(maxWidth: .infinity)
                })
            }
        }
        .frame(width: size.width - 100)
        .padding(.vertical)
        .background(Blur(style: .systemUltraThinMaterial))
        .cornerRadius(15)
        .onAppear {
            if !lunarCalendar.isEmpty {
                if showYear {
                    lunarYear = lunarCalendar.substring(with: 0..<5)
                    lunarMonth = lunarCalendar.substring(with: 5..<7)
                    lunarDay = lunarCalendar.substring(with: 7..<9)
                } else {
                    lunarMonth = lunarCalendar.substring(with: 0..<2)
                    lunarDay = lunarCalendar.substring(with: 2..<4)
                }
            }
        }
    }
}

struct LunarAlertView_Previews: PreviewProvider {
    static var previews: some View {
        LunarAlertView(lunarCalendar: .constant(""), alertLunar: .constant(false))
    }
}
