//
//  WatchedMovieViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import RealmSwift

class WatchedMovieViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var realm: Realm? = nil
    
    var registeredMovieInfoList = try? Realm().objects(MovieInfo.self)
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        realm = try? Realm()
        
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MovieCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        
        self.view.backgroundColor = UIColor.black
        self.collectionView.backgroundColor = UIColor.black
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = .clear
        self.searchBar.searchTextField.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = layout
    }
    
    @objc func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
    }
}

//MARK: - searchBar

extension WatchedMovieViewController: UISearchBarDelegate {
    
    func setupSearchBar(){
        self.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = self.searchBar.text else { return }
        if searchText == "" {
            self.registeredMovieInfoList = realm?.objects(MovieInfo.self)
        } else {
            let predicate = NSPredicate(format: "title CONTAINS %@", searchText)
            self.registeredMovieInfoList = realm?.objects(MovieInfo.self).filter(predicate)
        }
        self.collectionView.reloadData()
    }
}

//MARK: - collectionView

extension WatchedMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.registeredMovieInfoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        guard let registeredMovieInfoList = self.registeredMovieInfoList else { return cell}
        cell.setMovie(search: registeredMovieInfoList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let registeredMovieInfoList = self.registeredMovieInfoList else { return }
        let movie = registeredMovieInfoList[indexPath.row]
        let movieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToMovieDetail") as! MovieDetailViewController
        let movieInfo = realm?.object(ofType: MovieInfo.self, forPrimaryKey: movie.id)
        movieDetailViewController.movieInfo = movieInfo
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WatchedMovieViewController: UICollectionViewDelegateFlowLayout {
    /// セルのサイズ指定
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - collectionViewLayout: UICollectionViewLayout
    ///   - indexPath: IndexPath
    /// - Returns: セルのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // :親viewのwidth - 左右のマージン - セル間の水平方向の間隔 * (列数 - 1)
        let itemSpace = self.collectionView.frame.width - 10 - 10 * 2
        let width = itemSpace / 3
        return CGSize(width: width, height: width * 1.5)
    }
    /// 各カスタムセル外枠の余白
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - collectionViewLayout: UICollectionViewLayout
    ///   - section: Int
    /// - Returns: UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 5 , bottom: 16, right: 5 )
    }
}
