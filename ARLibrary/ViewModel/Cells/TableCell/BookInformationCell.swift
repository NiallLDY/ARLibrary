//
//  BookInformationCell.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

class BookInformationCell: UITableViewCell {
    
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
            isFavourite.setImage(UIImage(systemName: "star.fill"), for: .normal)
            isFavourite.tintColor = UIColor(named: "yellow")
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
