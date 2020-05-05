//
//  BookDetailViewController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
// 

import UIKit
import SDWebImage

class BookDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Section {
        let header: String?
        let footer: String?
    }
    var selectBook: Book!
    var sections: [Section] = []
    // MARK: - Initialization
    
    class func detailViewControllerForBook(_ book: Book) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "BookDetailViewController")
        
        if let detailViewController = viewController as? BookDetailViewController {
            detailViewController.selectBook = book
        }
        
        return viewController
    }
    
    // Number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].header
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sections[section].footer
    }
    // Number of rows in each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }
    // Cells in each section.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier: String
        
        switch indexPath.section {
        case 0:
            cellIdentifier = "bookInformation"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookInformationCell
            cell.bookid = selectBook.id
            // Load image from web if it's not loaded before. Since SDWebImage has handled the storeage already for us, we don't need manage this personally.
            let urlString = selectBook.image
            let url = URL(string: urlString)
            cell.bookImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), completed: {(image, error, cache, url) in
                cell.bookImage.contentMode = .scaleAspectFill
            })
            
            cell.bookName.text = selectBook.name
            cell.bookAuther.text = "作者：" + selectBook.auther
            cell.bookType.text = "类别：" + selectBook.type
            cell.selectionStyle = .none
            return cell
        default:
            cellIdentifier = "bookintroduction"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookIntroductionCell
            cell.bookIntroduction.text = selectBook.breifIntroduction
            
            cell.selectionStyle = .none
            return cell
        }
    }
    // The title of the header in each section.
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "书籍基本信息"
//        default:
//            return "书籍简介"
//        }
//    }
    
    
    // MARK: - Path
    var simplifiedPath = [Point]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "书籍信息"
        
        simplifiedPath.append(Point(x: 0, y: 0))
        simplifiedPath.append(Point(x: 37, y: 0))
        simplifiedPath.append(Point(x: 37, y: -294))
        simplifiedPath.append(Point(x: 1, y: -294))
        simplifiedPath.append(Point(x: 1, y: -255))
        simplifiedPath.append(Point(x: -66, y: -255))
        
        self.sections = [
            Section(header: "书籍基本信息", footer: "点击🌟即可收藏/取消收藏"),
            Section(header: "书籍简介", footer: nil)
        
        ]
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showARRoad" {
            let NavigationController = segue.destination as! UINavigationController
            let ARViewController = NavigationController.viewControllers.first as! ARViewController
            ARViewController.path = simplifiedPath
            ARViewController.selectedBook = self.selectBook
        }
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}


