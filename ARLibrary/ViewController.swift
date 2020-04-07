//
//  ViewController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/3/31.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bookTableView: UITableView!
    
    
    var booksArray: [Book] = loadjson("books.json")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        booksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "bookcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookTableCell
        cell.nameLabel?.text = booksArray[indexPath.row].name
        cell.autherLabel?.text = booksArray[indexPath.row].auther
        cell.typeLabel?.text = booksArray[indexPath.row].type
        cell.bookImageView?.image = UIImage(named: booksArray[indexPath.row].id)
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookDetail" {
            if let indexPath = bookTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! BookDetailViewController
                destinationController.selectBook = booksArray[indexPath.row]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}



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


