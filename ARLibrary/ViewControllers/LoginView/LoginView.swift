//
//  LoginView.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/18.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var name = ""
    @State var password = ""
    var body: some View {
        Form {
            Section(header: Text("登录"), footer: EmptyView()) {
                TextField("用户名", text: self.$name)
                SecureField("密码", text: self.$password, onCommit: {
                    print("好起来了")
                })
            }
            Section {
                Button(action: {
                    
                }) {
                    Text("登录")
                }
            }
            Section(header: Text("我的收藏")) {
                BookRowView()
            }
        }
    }
}

struct BookRowView: View {
    @State var selectbook: Book = testBookContent[0]
    var body: some View {
        Text(selectbook.name)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
