//
//  BookModel.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import Foundation

struct Book: Codable {
    var id: String
    var name: String
    var auther: String
    var type: String
    var image: String
    var coordinateX: String
    var coordinateY: String
    var coordinateZ: String
    // var isFavourit: Bool = false
}
func loadjson<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
    
let testBookContent: [Book] = loadjson("books.json")
