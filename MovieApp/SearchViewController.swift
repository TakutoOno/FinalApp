//
//  SearchViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var search: MovieModel?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.searchButton.backgroundColor = UIColor.gray
        self.searchButton.tintColor = UIColor.white
    }
    
    //MARK: - IBAction
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToSearchResult") as! SearchResultViewController
        searchResultViewController.searchText = searchTextField.text
        self.navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}

