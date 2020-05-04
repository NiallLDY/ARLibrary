//
//  BookInformationCell.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit
import AudioToolbox

class BookInformationCell: UITableViewCell {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .default)
    var bookid: String = "" {
        // 一开始打开页面显示是否被收藏
        didSet {
            findifFavourite(bookid: bookid)
        }
    }
    let userDefalts = SettingStore()
    var isfavourite = false {
        // 更改收藏之后，更新收藏星星
        didSet {
            if isfavourite {
                isFavourite.setImage(UIImage(systemName: "star.fill", withConfiguration: largeConfig), for: .normal)
            } else {
                isFavourite.setImage(UIImage(systemName: "star", withConfiguration: largeConfig), for: .normal)
            }
            isFavourite.tintColor = UIColor(named: "yellow")
        }
    }
    
    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.layer.cornerRadius = 10
            bookImage.clipsToBounds = true
            bookImage.layer.borderColor = CGColor.init(srgbRed: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            bookImage.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuther: UILabel!
    @IBOutlet weak var bookType: UILabel!
    @IBOutlet weak var isFavourite: UIButton! {
        didSet {
            if (!userDefalts.hasLogin) {
                isFavourite.isHidden = true
                return
            }
        }
    }
    
    @IBAction func changeFavourite(_ sender: Any) {
        Login(username: userDefalts.username, password: userDefalts.password, completion: { _ in
            makeUnFavourite(id: self.bookid, favourite: self.isfavourite ,completion: { success in
                if (success) {
                    self.isfavourite.toggle()
                    let soundShort = SystemSoundID(1519)
                    AudioServicesPlaySystemSound(soundShort)
                }
            })
        })
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    private func findifFavourite(bookid: String) {
        guard userDefalts.hasLogin == true else {
            return
        }
        Login(username: userDefalts.username, password: userDefalts.password, completion: { _ in
            // 增加一条浏览记录
            addRecord(name: self.userDefalts.username, bookid: self.bookid)
            // 判断这本书是不是收藏的
            loadData(urlString: "http://49.234.211.136:8080/jsonCollect") { books in
                self.isfavourite = false
                for book in books {
                    if (book.id == bookid) {
                        self.isfavourite = true
                        break
                    }
                }
            }
        })
    }
}
func addRecord(name: String, bookid: String) {
    
    let urlString = "http://49.234.211.136:8080/updateRecord?User=" + name + "&bid=" + bookid
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
    }
    task.resume()
}

