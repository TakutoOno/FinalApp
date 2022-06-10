//
//  TabBarController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 0.0, green: 0.90, blue: 0.90, alpha: 1)
        // タブバーの背景色を設定
        let appearance = UITabBarAppearance()
        appearance.backgroundColor =  UIColor(red: 0.34, green: 0.20, blue: 0.87, alpha: 1)
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }

    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
    }

}



