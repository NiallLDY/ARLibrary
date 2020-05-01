//
//  BookCollectionViewController+Search.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/3.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit

extension BookCollectionViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            if let resultsController = searchController.searchResultsController as? BookListViewController {
                resultsController.booksArray = []
                resultsController.tableView.reloadData()
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            loadData(urlString: loadDataURL + searchText) { books in
                if let resultsController = self.resultsTableController {
                    resultsController.booksArray = books
                    resultsController.tableView.reloadData()
                }
            }
        }
    }
    
}
