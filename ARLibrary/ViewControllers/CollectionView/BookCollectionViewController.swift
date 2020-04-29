//
//  BookCollectionViewController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/2.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit
import SwiftUI



class BookCollectionViewController: UICollectionViewController, UITableViewDelegate, UISearchControllerDelegate {
    
    /// Search results table view.
    var resultsTableController: BookListViewController!
    
    var searchController: UISearchController!
    
    let booksinIndexView = [
        BookPreview(title: "今日推荐", images: ["10002", "10003", "10005"]),
        BookPreview(title: "新书上架", images: ["10004", "10006", "10008", "10009", "10020"]),
        BookPreview(title: "热门图书", images: ["10001", "10014", "10015", "10018", "10023"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MyProfile View
        setupUI()
        
        
        resultsTableController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableController") as? BookListViewController
        
        // This view controller is interested in table view row selections.
        resultsTableController.tableView.delegate = self
        // 去除多余横线
        resultsTableController.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.setValue("取消", forKey: "cancelButtonText")
        self.navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.booksinIndexView[section].images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "CollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        // Configure the cell
        // cell.collectionCellImage.image = UIImage(named: booksinIndexView[indexPath.section].images[indexPath.item])
        // Set the placeholder's contentMode to scaleAspectFit
        cell.collectionCellImage.contentMode = .scaleAspectFit
        
        let urlString = loadImageURL + booksinIndexView[indexPath.section].images[indexPath.item] + ".png"
        let url = URL(string: urlString)
        cell.collectionCellImage?.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), completed: {(image, error, cache, url) in
            // Set the image's contentMode to scaleAspectFill
            cell.collectionCellImage.contentMode = .scaleAspectFill
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView!
        if kind == UICollectionView.elementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath)
            let label = reusableview.viewWithTag(1) as! UILabel
            label.text = booksinIndexView[indexPath.section].title
        } else {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFooter", for: indexPath)
        }
        return reusableview
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
struct BookPreview {
    var title: String
    var images: [String]
}
extension BookCollectionViewController {
    @IBAction func action(_ sender: AnyObject) {
        let loginView = LoginView(dismissAction: { self.dismiss( animated: true, completion: nil) })
        let LoginViewController = UIHostingController(rootView: loginView)
        self.present(LoginViewController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle")!,
                                          style: .plain,
                                          target: self,
                                          action: #selector(action(_:)))
        navigationItem.rightBarButtonItem = profile
        
        
    }
    
}
