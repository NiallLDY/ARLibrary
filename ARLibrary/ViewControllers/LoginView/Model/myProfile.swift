//
//  myProfile.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/30.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import Foundation
import Combine

final class SettingStore: ObservableObject {
    @Published var defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            "view.hasLogin" : false,
            "view.username" : "",
            "view.password" : ""
        ])
    }
    var hasLogin: Bool {
        get {
            defaults.bool(forKey: "view.hasLogin")
        }
        set {
            defaults.set(newValue, forKey: "view.hasLogin")
        }
    }
    var username: String {
        get {
            defaults.string(forKey: "view.username") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "view.username")
        }
    }
    var password: String {
        get {
            defaults.string(forKey: "view.password") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "view.password")
        }
    }
    
}
