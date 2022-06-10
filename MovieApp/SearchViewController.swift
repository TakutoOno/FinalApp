//
//  SearchViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import Foundation
import Moya

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var search: MovieModel?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBAction
    
    @IBAction func searchButton(_ sender: Any) {
        let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToSearchResult") as! SearchResultViewController
        searchResultViewController.searchText = searchTextField.text!
        self.navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}
