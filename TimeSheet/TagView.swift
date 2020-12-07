//
//  TagView.swift
//  TimeSheet
//
//  Created by 李伟 on 2020/11/26.
//

import SwiftUI

struct TagView: View {
    
    @State var title = "生活"
    @State var color = Color("BlueColor")
    @State var textcolor = Color.primary
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title).font(.system(size: 10, weight: .regular, design: .rounded))
                .frame(height: 16)
                .foregroundColor(textcolor)
            Rectangle()
                .fill(color)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }.frame(width: (title.count > 4 ? 12 : 13) * CGFloat(title.count))
        .background(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color("GrayColor"))
        )
        .cornerRadius(2)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
