//
//  BookCollectionView+ResultTableController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/3.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

extension BookCollectionViewController {
   
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectBook: Book!
        selectBook = resultsTableController.booksArray[indexPath.row]
        
        // Set up the detail view controller to push.
        let detailViewController = BookDetailViewController.detailViewControllerForBook(selectBook)
        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") {(action, sourceView, completionHandle) in
            self.resultsTableController.booksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandle(true)
        }
        deleteAction.backgroundColor = UIColor(named: "deleteColor")
        deleteAction.image = UIImage(systemName: "trash")
        let shareAction = UIContextualAction(style: .normal, title: "分享") {(action, sourceView, completionHandle) in
            var shareItems: [Any] = []
            let shareText = "来看看这本书：" + self.resultsTableController.booksArray[indexPath.row].name
            let shareImage = UIImage(named: self.resultsTableController.booksArray[indexPath.row].id)
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
}
