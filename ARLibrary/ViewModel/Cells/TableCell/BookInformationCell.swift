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
    var bookid: String = "a" {
        didSet {
            findifFavourite(bookid: bookid)
            if (self.isfavourite) {
                isFavourite.setImage(UIImage(systemName: "star.fill", withConfiguration: largeConfig), for: .normal)
            } else {
                isFavourite.setImage(UIImage(systemName: "star", withConfiguration: largeConfig), for: .normal)
            }
            
            isFavourite.tintColor = UIColor(named: "yellow")
        }
    }
    let userDefalts = SettingStore()
    var isfavourite = false {
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
        Login(username: userDefalts.username, password: userDefalts.password, completion: { _ in
            loadData(urlString: "http://49.234.211.136:8080/jsonCollect") { books in
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
