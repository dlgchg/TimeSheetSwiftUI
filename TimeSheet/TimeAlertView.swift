//
//  TimeAlertView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct TimeAlertView: View {
    @Binding var time: Date
    @Binding var alertTime: Bool
    @State var d = Date()
    var body: some View {
        VStack(spacing: 0) {
            Text("选择提醒时间")
            DatePicker("", selection: $d, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
            HStack {
                Button(action: {
                        shock()
                        self.alertTime.toggle()}, label: {
                    Text("取消").frame(maxWidth: .infinity)
                })
                Button(action: {
                    shock()
                    self.time = d
                    self.alertTime.toggle()
                }, label: {
                    Text("确认").frame(maxWidth: .infinity)
                })
            }
        }
        .frame(width: size.width - 100)
        .padding(.vertical)
        .background(Blur(style: .systemUltraThinMaterial))
        .cornerRadius(15)
    }
}
