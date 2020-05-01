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
    @EnvironmentObject var settingStore: SettingStore
    @State var name = ""
    @State var password = ""
    @State var loginSuccessed = false
    @State var passwordWrong = false
    @State var favouriteBooks = [Book]()
    var body: some View {
        NavigationView {
            Form {
                if loginSuccessed {
                    Section(header: Text("登录成功")) {
                        Text("欢迎你～" + self.name)
                    }
                    Section {
                        Button("注销") {
                            // 49.234.211.136:8080/logout
                            self.loginSuccessed = false
                            self.settingStore.hasLogin = false
                        }
                    }
                    Section(header: Text("我的收藏")) {
                        BookListView(favouriteBooks: self.favouriteBooks)
                    }
                } else {
                    Section(header: Text("登录")) {
                        TextField("用户名", text: self.$name)
                        SecureField("密码", text: self.$password, onCommit: { })
                    }
                    Section {
                        Button("登录") {
                            Login(username: self.name, password: self.password) { valid in
                                if (valid) {
                                    loadData(urlString: "http://49.234.211.136:8080/jsonCollect") { books in
                                        self.favouriteBooks = books
                                        self.loginSuccessed = true
                                    }
                                    self.settingStore.hasLogin = true
                                    self.settingStore.username = self.name
                                    self.settingStore.password = self.password
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
            .navigationBarItems(trailing: Button(action: {
                    self.dismissAction()
                }, label: {
                    Text("完成")
                        .foregroundColor(.primary)
                }))
        }
        .onAppear() {
            // 如果之前登录了
            if (self.settingStore.hasLogin) {
                self.name = self.settingStore.username
                Login(username: self.settingStore.username, password: self.settingStore.password) {_ in
                    loadData(urlString: "http://49.234.211.136:8080/jsonCollect") { books in
                        self.favouriteBooks = books
                        self.loginSuccessed = true
                    }
                }
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(dismissAction: {}).environmentObject(SettingStore())
    }
}
