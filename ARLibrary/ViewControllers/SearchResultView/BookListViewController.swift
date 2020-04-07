//
//  ViewController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/3/31.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

class BookListViewController: UITableViewController {
    
    var booksArray: [Book] = []
    
    // Clear the result view before next time of searching.
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.booksArray = []
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        booksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "bookcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookTableCell
        cell.nameLabel?.text = booksArray[indexPath.row].name
        cell.autherLabel?.text = booksArray[indexPath.row].auther
        cell.typeLabel?.text = booksArray[indexPath.row].type
        
        // Set the placeholder's contentMode to scaleAspectFit
        cell.bookImageView.contentMode = .scaleAspectFit
        
        let urlString = loadImageURL + booksArray[indexPath.row].id + ".png"
        let url = URL(string: urlString)
        cell.bookImageView?.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), completed: {(image, error, cache, url) in
            // Set the image's contentMode to scaleAspectFill
            cell.bookImageView.contentMode = .scaleAspectFill
        })
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    /*
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") {(action, sourceView, completionHandle) in
            self.booksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandle(true)
        }
        deleteAction.backgroundColor = UIColor(named: "deleteColor")
        deleteAction.image = UIImage(systemName: "trash")
        let shareAction = UIContextualAction(style: .normal, title: "分享") {(action, sourceView, completionHandle) in
            var shareItems: [Any] = []
            let shareText = "来看看这本书：" + self.booksArray[indexPath.row].name
            let shareImage = UIImage(named: self.booksArray[indexPath.row].id)
            shareItems.append(shareText)
            if shareImage != nil {
                shareItems.append(shareImage!)
            }
            let activityController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            completionHandle(true)
        }
        shareAction.backgroundColor = UIColor(named: "shareBlue")
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
 */
    
}




