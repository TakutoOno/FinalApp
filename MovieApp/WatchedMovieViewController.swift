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
    
    var realm: Realm? = nil
    
    var registeredMovieInfoList = try? Realm().objects(MovieInfo.self)
    
    private let sideMarginRatio: CGFloat = 0.06
    // セル同士の余白
    private let itemSpacing: CGFloat = 16
    // 1列に表示するセルの数
    private let itemPerWidth: CGFloat = 2
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MovieCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout

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
        //movie.idに一致するidがあるかをfilterで検索する
        //あればそのオブジェクトを渡す
        //nullになれば空のオブジェクトを渡す
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
        let itemSpace = self.collectionView.frame.width / (self.collectionView.frame.width * self.sideMarginRatio) * (self.itemPerWidth + 1)
        let itemSizeWidth = self.collectionView.frame.width - itemSpace
        let width = itemSizeWidth / 2
        // XDの比率に合わせるため(height = width - 7)になるように設定
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
        let space = self.collectionView.frame.width / (self.collectionView.frame.width * self.sideMarginRatio)
        return UIEdgeInsets(top: 15, left: space * 1.2, bottom: 16, right: space * 1.2)
    }
}
