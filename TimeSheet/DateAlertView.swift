//
//  DateAlertView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/25.
//

import SwiftUI

struct DateAlertView: View {
    @Binding var date: Date
    @Binding var alertDate: Bool
    @State var d = Date()
    @State var later = false
    @State var item = Item(context: context)
    var body: some View {
        VStack(spacing: 0) {
            Text("选择\(later ? "推后" : "日程")日期")
            DatePicker("", selection: $d, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
            HStack {
                Button(action: { shock()
                        self.alertDate.toggle()}, label: {
                    Text("取消").frame(maxWidth: .infinity)
                })
                Button(action: {
                    shock()
                    if later {
                        item.date = d
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else {
                        self.date = d
                    }
                    self.alertDate.toggle()
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
