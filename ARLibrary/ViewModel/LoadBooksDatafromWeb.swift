//
//  LoadBooksDatafromWeb.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import Foundation

func loadData(urlString: String, completion: @escaping ([Book]) -> ()) {
    // Create URL
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
        let books: [Book] = decodeJSON(data: data)
        DispatchQueue.main.async {
            completion(books)
        }
        
    }
    task.resume()
}
func decodeJSON<T: Decodable>(data: Data) -> T {
    let data = data
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse as \(T.self):\n\(error)")
    }
}

public let loadImageURL = "http://123.56.238.98/images/"
public let loadDataURL = "http://123.56.238.98/index.php?name="
