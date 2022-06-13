//
//  RecommendationViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import RealmSwift

class RecommendationViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var viewWidth: CGFloat!
//    var viewHeight: CGFloat!
//    var cellWitdh: CGFloat!
//    var cellHeight: CGFloat!
//    var cellOffset: CGFloat!
//    var navHeight: CGFloat!

    
    var realm: Realm? = nil
    
    var registeredMovieInfoList = try! Realm().objects(MovieInfo.self)
    
    var ranadom: Results<MovieInfo>!
    
    private let sideMarginRatio: CGFloat = 0.06
    // セル同士の余白
    private let itemSpacing: CGFloat = 16
    // 1列に表示するセルの数
    private let itemPerWidth: CGFloat = 2
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        realm = try? Realm()
        
        let nib = UINib(nibName: "RecommendationMovieCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
//        viewWidth = view.frame.width
//               viewHeight = view.frame.height
//               //ナビゲーションバーの高さ
//               navHeight = self.navigationController?.navigationBar.frame.size.height

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let randomA = registeredMovieInfoList.randomElement()!
//        for _ in 0...10 {
//            random.append(randomA)
//        }
//        let q = registeredMovieInfoList.randomElement()?.id
//        let e = realm?.object(ofType: MovieInfo.self, forPrimaryKey: q)
//        registeredMovieInfoList.shuffled()
        
        collectionView.reloadData()
        
//        let layout = UICollectionViewFlowLayout()
//        collectionView.collectionViewLayout = layout

    }
    
}
    //MARK: - collectionView
    
extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registeredMovieInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
        cell.setMovie(search: registeredMovieInfoList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = registeredMovieInfoList[indexPath.row]
  //      var movieInfo:MovieInfo = MovieInfo()
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

extension RecommendationViewController: UICollectionViewDelegateFlowLayout {
//    /// セルのサイズ指定
//    ///
//    /// - Parameters:
//    ///   - collectionView: UICollectionView
//    ///   - collectionViewLayout: UICollectionViewLayout
//    ///   - indexPath: IndexPath
//    /// - Returns: セルのサイズ
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSpace = self.collectionView.frame.width / (self.collectionView.frame.width * self.sideMarginRatio) * (self.itemPerWidth + 1)
//        let itemSizeWidth = self.collectionView.frame.width - itemSpace
//        let width = itemSizeWidth / 2
//        // XDの比率に合わせるため(height = width - 7)になるように設定
//        return CGSize(width: width, height: width * 1.5)
//    }
//    /// 各カスタムセル外枠の余白
//    ///
//    /// - Parameters:
//    ///   - collectionView: UICollectionView
//    ///   - collectionViewLayout: UICollectionViewLayout
//    ///   - section: Int
//    /// - Returns: UIEdgeInsets
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let space = self.collectionView.frame.width / (self.collectionView.frame.width * self.sideMarginRatio)
//        return UIEdgeInsets(top: 15, left: space * 1.2, bottom: 16, right: space * 1.2)
//    }
//}
    
    //セル間の間隔を指定
private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimunLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

//    //セルのサイズ(CGSize)
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        cellWitdh = viewWidth-75
//        cellHeight = viewHeight-300
//        cellOffset = viewWidth-cellWitdh
//        return CGSize(width: cellWitdh, height: cellHeight)
//    }

//    //余白の調整（UIImageを拡大、縮小している）
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        //top:ナビゲーションバーの高さ分上に移動
//        return UIEdgeInsets(top: -navHeight,left: cellOffset/2,bottom: 0,right: cellOffset/2)
//    }
}
