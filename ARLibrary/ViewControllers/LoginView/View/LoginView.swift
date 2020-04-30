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
    @State var passwordWrong = false
    var body: some View {
        NavigationView {
            Form {
                if loginSuccessed {
                    Section(header: Text("登录成功")) {
                        Text("欢迎你～" + self.name)
                    }
                    Section {
                        Button(action: {
                            self.loginSuccessed = false
                        }) {
                            Text("注销")
                        }
                    }
                    Section(header: Text("我的收藏")) {
                        BookListView()
                    }
                } else {
                    Section(header: Text("登录")) {
                        TextField("用户名", text: self.$name)
                        SecureField("密码", text: self.$password, onCommit: {
                            
                        })
                    }
                    Section {
                        Button("登录") {
                            Login(username: self.name, password: self.password) { valid in
                                if (valid) {
                                    self.loginSuccessed = true
                                }
                                else {
                                    self.passwordWrong = true
                                }
                            }
                        }
                        .disabled(self.name == "" || self.password == "")
                        .alert(isPresented: self.$passwordWrong) {
                            Alert(title: Text("登录失败"), message: Text("用户名或密码错误"), dismissButton: .default(Text("取消")))
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



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(dismissAction: {})
    }
}
