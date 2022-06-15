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
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var actionLabel: UILabel!
    var realm: Realm? = nil
    
    var registeredMovieInfoList = try! Realm().objects(MovieInfo.self)
    var actionMovieInfoList = try! Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", 28, 28, 28, 28)
    
    //"firstGenreId = '28' OR secondGenreId = '28' OR thirdGenreId = '28' OR forthGenreId = '28'"
    var random: [MovieInfo] = []
    var randomAction: [MovieInfo] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        realm = try? Realm()
        
        let nib = UINib(nibName: "RecommendationMovieCell", bundle: nil)
        self.actionCollectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        let nibTwo = UINib(nibName: "TopRecommendationMovieCell", bundle: nil)
        self.collectionView.register(nibTwo, forCellWithReuseIdentifier: "TopRecommendationMovieCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.actionCollectionView.dataSource = self
        self.actionCollectionView.delegate = self
        self.collectionView.tag = 1
        self.actionCollectionView.tag = 2
        
        view.backgroundColor = UIColor.black
        topLabel.textColor = UIColor.white
        collectionView.backgroundColor = UIColor.black
        actionLabel.textColor = UIColor.white
        actionCollectionView.backgroundColor = UIColor.black
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomAction = Array(actionMovieInfoList).shuffled()
        random = Array(registeredMovieInfoList).shuffled()
        
        collectionView.reloadData()
        actionCollectionView.reloadData()
    }
    
}
//MARK: - collectionView

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //      10以上なら１０　１０以下ならカウント
        if collectionView.tag == 1 {
            print(random)
            if random.count >= 10 {
                return 10
            } else {
                return random.count
            }
        } else {
            if randomAction.count >= 10 {
                return 10
            } else {
                return randomAction.count
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //    guard let registeredMovieInfoList = registeredMovieInfoList else { return cell}
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRecommendationMovieCell", for: indexPath) as! TopRecommendationMovieCell
            cell.setTopMovie(search: random[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: randomAction[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //      guard let registeredMovieInfoList = registeredMovieInfoList else { return }
        let movie: MovieInfo
        if collectionView.tag == 1 {
            movie = random[indexPath.row]
        } else {
            movie = randomAction[indexPath.row]
        }
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
