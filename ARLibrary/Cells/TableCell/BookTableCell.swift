//
//  BookTableCell.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/1.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

class BookTableCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView! {
        didSet {
            bookImageView.layer.cornerRadius = 10
            bookImageView.clipsToBounds = true
            bookImageView.layer.borderColor = CGColor.init(srgbRed: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            bookImageView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
