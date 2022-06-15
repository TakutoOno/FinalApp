//
//  RecommendationViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import UIKit
import Foundation
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
    var actionMovieInfoList = try! Realm().objects(MovieInfo.self).filter("firstGenreId = %@", 27)
    
    var random: [MovieInfo] = []
//
//    private let sideMarginRatio: CGFloat = 0.06
//    // セル同士の余白
//    private let itemSpacing: CGFloat = 16
//    // 1列に表示するセルの数
//    private let itemPerWidth: CGFloat = 2
//
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        realm = try? Realm()
        
        let nib = UINib(nibName: "RecommendationMovieCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        view.backgroundColor = UIColor.black
        collectionView.backgroundColor = UIColor.black
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        random = Array(registeredMovieInfoList).shuffled()
        
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
  //      10以上なら１０　１０以下ならカウント
        if random.count >= 10 {
        return 10
        } else {
            return random.count
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
    //    guard let registeredMovieInfoList = registeredMovieInfoList else { return cell}
        cell.setMovie(search: random[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  //      guard let registeredMovieInfoList = registeredMovieInfoList else { return }
        let movie = random[indexPath.row]
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
    //セル間の間隔を指定
private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimunLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
