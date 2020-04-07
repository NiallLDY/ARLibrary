//
//  CollectionViewCell.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionCellImage: UIImageView! {
        didSet {
            collectionCellImage.layer.cornerRadius = 10
            collectionCellImage.clipsToBounds = true
            collectionCellImage.layer.borderColor = CGColor.init(srgbRed: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            collectionCellImage.layer.borderWidth = 1
        }
    }
    
}
