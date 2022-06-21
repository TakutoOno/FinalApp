//
//  SearchViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import Foundation
import SVProgressHUD

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var search: MovieModel?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.backgroundColor = UIColor.black
        self.searchButton.backgroundColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.searchButton.tintColor = UIColor.black
        self.searchButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchTextField.text = ""
    }
    
    //MARK: - IBAction
    
    @IBAction func searchButton(_ sender: Any) {
        if searchTextField.text == "" {
            return
        }
        
        let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToSearchResult") as! SearchResultViewController
        searchResultViewController.searchText = searchTextField.text
        self.navigationController?.pushViewController(searchResultViewController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
    }
}
