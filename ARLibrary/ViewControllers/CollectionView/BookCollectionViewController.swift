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
    
    let spinnerView = SpinnerViewController()
    
    let userDefalts = SettingStore()
    
    var haslogin = false {
        didSet {
            // 登录状态发生变化
            if oldValue != haslogin {
                setData()
                self.collectionView.reloadData()
            }
        }
    }
    
    
    var bookEntity = [
        BookEntity(title: "推荐(登录后获取更准确的推荐)", books: []),
        BookEntity(title: "新书上架", books: []),
        BookEntity(title: "热门图书", books: [])
        ] {
        didSet {
            // if oldValue[0].books != bookEntity[0].books {
                
                self.collectionView.reloadData()
           //  }
            
        }
    }
    
    
    private func getbooks(ids: [String], completion: @escaping ([Book]) -> ()) {
        var books =  [Book]()
        for id in ids {
            // 49.234.211.136:8080/searchBook?id=
            loadData(urlString: "http://49.234.211.136:8080/searchBook?id=" + id) { loadedbook in
                for book in loadedbook {
                    books.append(book)
                }
                completion(books)
            }
        }
    }
    private func setData() {
        
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
        
        
        if userDefalts.hasLogin {
            self.bookEntity[0].title = "我的推荐"
            Login(username: userDefalts.username, password: userDefalts.password, completion: { _ in
                loadData(urlString: "http://49.234.211.136:8080/recommend?User=" + self.userDefalts.username, completion: { books in
                    self.bookEntity[0].books = books
                })
            })
        } else {
            self.bookEntity[0].title = "推荐(登录后获取更准确的推荐)"
            getbooks(ids: ["10002", "10003", "10005"], completion: { books in
                self.bookEntity[0].books = books
            })
        }
        getbooks(ids: ["10004", "10006", "10008", "10009", "10020"], completion: { books in
            self.bookEntity[1].books = books
        })
        getbooks(ids: ["10001", "10014", "10015", "10018", "10023"], completion: { books in
            self.bookEntity[2].books = books
            
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // MyProfile View
        setupMyUI()
        
        
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
        self.haslogin = userDefalts.hasLogin
        // 更新数据
        setData()
    }
    
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.bookEntity[section].books.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "CollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        // Configure the cell
        // cell.collectionCellImage.image = UIImage(named: booksinIndexView[indexPath.section].images[indexPath.item])
        // Set the placeholder's contentMode to scaleAspectFit
        cell.collectionCellImage.contentMode = .scaleAspectFit
        
        let urlString = bookEntity[indexPath.section].books[indexPath.item].image
        
        // let urlString = loadImageURL + booksinIndexView[indexPath.section].images[indexPath.item] + ".png"
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
            label.text = bookEntity[indexPath.section].title
        } else {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFooter", for: indexPath)
        }
        return reusableview
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectbook = bookEntity[indexPath.section].books[indexPath.item]
        // Set up the detail view controller to push.
        let detailViewController = BookDetailViewController.detailViewControllerForBook(selectbook)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
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
struct BookEntity {
    var title: String
    var books: [Book]
}
extension BookCollectionViewController {
    @IBAction func action(_ sender: AnyObject) {
        let loginView = LoginView(dismissAction: {
            self.dismiss(animated: true, completion: nil) }).environmentObject(SettingStore())
        let LoginViewController = UIHostingController(rootView: loginView)
        LoginViewController.modalPresentationStyle = .fullScreen
        self.present(LoginViewController, animated: true, completion: nil)
    }
    
    private func setupMyUI() {
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle")!,
                                          style: .plain,
                                          target: self,
                                          action: #selector(action(_:)))
        navigationItem.rightBarButtonItem = profile
    }
}
class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.systemBackground

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
