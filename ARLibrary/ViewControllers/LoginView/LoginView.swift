//
//  LoginView.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/18.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var dismissAction: (() -> Void)
    @State var name = ""
    @State var password = ""
    @State var loginSuccessed = false
    var body: some View {
        NavigationView {
            Form {
                if loginSuccessed {
                    Section(header: Text("登录成功")) {
                       Text("欢迎你～")
                    }
                    Section {
                        Button(action: {
                            self.loginSuccessed = false
                        }) {
                            Text("注销")
                        }
                    }
                    Section(header: Text("我的收藏")) {
                        BookRowView()
                    }
                } else {
                    Section(header: Text("登录")) {
                        TextField("用户名", text: self.$name)
                        SecureField("密码", text: self.$password, onCommit: {
                            print("好起来了")
                        })
                    }
                    Section {
                        Button(action: {
                            self.loginSuccessed = true
                        }) {
                            Text("登录")
                        }
                    }
                }
                
                
            }
            .navigationBarTitle("我的主页")
            .navigationBarItems(trailing:
                Button(action: {
                    print("aaaa")
                    self.dismissAction()
                }, label: {
                    Text("完成")
                        .foregroundColor(.primary)
                }))
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
        LoginView(dismissAction: {})
    }
}
