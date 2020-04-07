//
//  PopUpViewController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/6.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Trigerred when the "Restart Experience" button is tapped.
    var cancelHandler: () -> Void = {}
    
     // MARK: - IBOutlets
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuther: UILabel!
    @IBOutlet weak var bookType: UILabel!
    @IBOutlet weak var Introduction: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var checkOut: UIButton!
    
    // MARK: - Message Handling
    func showInformation(book: Book) {
        bookImage.sd_setImage(with: URL(string: book.image))
        bookName.text = book.name
        bookAuther.text = book.auther
        bookType.text = book.type
        Introduction.text = "本书旨在让你成为优秀的程序员，具体地说，是优秀的Python程序员。通过阅读本书，你将迅速掌握编程概念，打下坚实的基础，并养成良好的习惯。阅读本书后，你就可以开始学习Python高级技术，并能够更轻松地掌握其他编程语言。"
    }
    
    // MARK: - IBActions
    
    @IBAction private func cancelButton(_ sender: UIButton) {
        cancelHandler()
    }
    @IBAction private func checkOut(_ sender: UIButton) {
        cancelHandler()
    }
    

}
