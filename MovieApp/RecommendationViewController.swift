//
//  RecommendationViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import RealmSwift

class RecommendationViewController: UIViewController {

//var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
   //     print(Realm.Configuration.defaultConfiguration.fileURL!)

    }

}
