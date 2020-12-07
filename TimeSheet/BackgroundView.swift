//
//  BackgroundView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/26.
//

import SwiftUI

struct BackgroundView: View {
    @AppStorage("bg") var bg = ""
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20, content: {
                ForEach(1...15, id: \.self) { i in
                    Image("bg\(i)")
                        .resizable()
                        .frame(width: size.width / 3.4, height: size.width / 3.4)
                        .clipped()
                        .border(self.bg == "bg\(i)" ? Color("BlueColor") : Color.clear, width: 4)
                        .onTapGesture {
                            shock()
                            self.bg = "bg\(i)"
                        }
                }
            })
        })
        .navigationBarTitle("背景图片", displayMode: .inline)
        .navigationBarItems(trailing: Button("无背景", action: {
            shock()
            bg = ""
        }))
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
