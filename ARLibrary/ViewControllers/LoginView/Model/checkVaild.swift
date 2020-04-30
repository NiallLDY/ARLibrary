//
//  checkVaild.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/30.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import Foundation

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

func Login(username: String, password: String, completion: @escaping (Bool) -> ()) {
    // Create URL
    let urlString = "http://49.234.211.136:8080/login" + "?name=" + username + "&password=" + password
    let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: encodedStr)
    guard let requestUrl = url else { fatalError() }
    
    // Create URL Request
    var request = URLRequest(url: requestUrl)
    
    // Specify HTTP Method to use
    request.httpMethod = "GET"
    
    
    // Send HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Check if Error took place
        if let error = error {
            print("Error took place \(error)")
            return
        }
        // Convert HTTP Response Data to a simple String
        guard let data = data else { return }
        print(data.html2String)
        let vaild = data.html2String == "success"
        DispatchQueue.main.async {
            completion(vaild)
        }
        
    }
    task.resume()
}

