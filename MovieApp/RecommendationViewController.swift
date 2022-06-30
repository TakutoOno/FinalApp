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
    @IBOutlet weak var oneGenreCollectionView: UICollectionView!
    @IBOutlet weak var oneGenreLabel: UILabel!
    @IBOutlet weak var twoGenreLabel: UILabel!
    @IBOutlet weak var twoGenreCollectionView: UICollectionView!
    @IBOutlet weak var threeGenreLabel: UILabel!
    @IBOutlet weak var threeGenreCollectionView: UICollectionView!
    @IBOutlet weak var fourGenreLabel: UILabel!
    @IBOutlet weak var fourGenreCollectionView: UICollectionView!
    
    var realm: Realm? = nil
    
    let genreNumber = [12,14,16,18,27,28,35,53,80,99,878,9648,10402,10749,10751]
    let genreName = ["アドベンチャー", "ファンタジー", "アニメーション", "ドラマ", "ホラー", "アクション", "コメディ", "スリラー", "犯罪", "ドキュメンタリー", "サイエンスフィクション", "謎", "音楽", "ロマンス", "ファミリー"]
    
    var registeredMovieInfoList = try? Realm().objects(MovieInfo.self)
    
    var oneGenreMovieInfoList: Results<MovieInfo>?
    var twoGenreMovieInfoList: Results<MovieInfo>?
    var threeGenreMovieInfoList: Results<MovieInfo>?
    var fourGenreMovieInfoList: Results<MovieInfo>?
    
    var random: [MovieInfo] = []
    var randomOneGenre: [MovieInfo] = []
    var randomTwoGenre: [MovieInfo] = []
    var randomThreeGenre: [MovieInfo] = []
    var randomFourGenre: [MovieInfo] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        realm = try? Realm()
        
        let nibTop = UINib(nibName: "TopRecommendationMovieCell", bundle: nil)
        self.collectionView.register(nibTop, forCellWithReuseIdentifier: "TopRecommendationMovieCell")
        let nib = UINib(nibName: "RecommendationMovieCell", bundle: nil)
        self.oneGenreCollectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        self.twoGenreCollectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        self.threeGenreCollectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        self.fourGenreCollectionView.register(nib, forCellWithReuseIdentifier: "RecommendationMovieCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.oneGenreCollectionView.dataSource = self
        self.oneGenreCollectionView.delegate = self
        self.twoGenreCollectionView.dataSource = self
        self.twoGenreCollectionView.delegate = self
        self.threeGenreCollectionView.dataSource = self
        self.threeGenreCollectionView.delegate = self
        self.fourGenreCollectionView.dataSource = self
        self.fourGenreCollectionView.delegate = self
        
        self.collectionView.tag = 0
        self.oneGenreCollectionView.tag = 1
        self.twoGenreCollectionView.tag = 2
        self.threeGenreCollectionView.tag = 3
        self.fourGenreCollectionView.tag = 4
        
        self.view.backgroundColor = UIColor.black
        self.topLabel.textColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.collectionView.backgroundColor = UIColor.black
        self.oneGenreLabel.textColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.oneGenreCollectionView.backgroundColor = UIColor.black
        self.twoGenreLabel.textColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.twoGenreCollectionView.backgroundColor = UIColor.black
        self.threeGenreLabel.textColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.threeGenreCollectionView.backgroundColor = UIColor.black
        self.fourGenreLabel.textColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.fourGenreCollectionView.backgroundColor = UIColor.black
        
        let oneGenreNumber = self.genreNumber.randomElement()!
        let oneIndex = self.genreNumber.firstIndex(of: oneGenreNumber )
        let oneGenreName = self.genreName[oneIndex!]
        
        let twoGenreNumber = self.genreNumber.randomElement()!
        let twoIndex = self.genreNumber.firstIndex(of: twoGenreNumber )
        let twoGenreName = self.genreName[twoIndex!]
        
        let threeGenreNumber = self.genreNumber.randomElement()!
        let threeIndex = self.genreNumber.firstIndex(of: threeGenreNumber )
        let threeGenreName = self.genreName[threeIndex!]
        
        let fourGenreNumber = self.genreNumber.randomElement()!
        let fourIndex = self.genreNumber.firstIndex(of: fourGenreNumber )
        let fourGenreName = self.genreName[fourIndex!]
        
        self.oneGenreLabel.text = oneGenreName
        self.oneGenreMovieInfoList = try? Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", oneGenreNumber, oneGenreNumber, oneGenreNumber, oneGenreNumber)
        
        self.twoGenreLabel.text = twoGenreName
        self.twoGenreMovieInfoList = try? Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", twoGenreNumber, twoGenreNumber, twoGenreNumber, twoGenreNumber)
        
        self.threeGenreLabel.text = threeGenreName
        self.threeGenreMovieInfoList = try? Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", threeGenreNumber, threeGenreNumber, threeGenreNumber, threeGenreNumber)
        
        self.fourGenreLabel.text = fourGenreName
        self.fourGenreMovieInfoList = try? Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", fourGenreNumber, fourGenreNumber, fourGenreNumber, fourGenreNumber)
        
        guard let registeredMovieInfoList = registeredMovieInfoList,
              let oneGenreMovieInfoList = oneGenreMovieInfoList,
              let twoGenreMovieInfoList = twoGenreMovieInfoList,
              let threeGenreMovieInfoList = threeGenreMovieInfoList,
              let fourGenreMovieInfoList = fourGenreMovieInfoList else { return }
        self.random = Array(registeredMovieInfoList).shuffled()
        self.randomOneGenre = Array(oneGenreMovieInfoList).shuffled()
        self.randomTwoGenre = Array(twoGenreMovieInfoList).shuffled()
        self.randomThreeGenre = Array(threeGenreMovieInfoList).shuffled()
        self.randomFourGenre = Array(fourGenreMovieInfoList).shuffled()
        
        self.collectionView.reloadData()
        self.oneGenreCollectionView.reloadData()
        self.twoGenreCollectionView.reloadData()
        self.threeGenreCollectionView.reloadData()
        self.fourGenreCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - collectionView

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if self.random.count >= 10 {
                return 10
            } else {
                return self.random.count
            }
        } else if collectionView.tag == 1 {
            if self.randomOneGenre.count >= 10 {
                return 10
            } else {
                return self.randomOneGenre.count
            }
        }  else if collectionView.tag == 2 {
            if self.randomTwoGenre.count >= 10 {
                return 10
            } else {
                return self.randomTwoGenre.count
            }
        }  else if collectionView.tag == 3 {
            if self.randomThreeGenre.count >= 10 {
                return 10
            } else {
                return self.randomThreeGenre.count
            }
        } else {
            if self.randomFourGenre.count >= 10 {
                return 10
            } else {
                return self.randomFourGenre.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRecommendationMovieCell", for: indexPath) as! TopRecommendationMovieCell
            cell.setTopMovie(search: self.random[indexPath.row])
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: self.randomOneGenre[indexPath.row])
            return cell
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: self.randomTwoGenre[indexPath.row])
            return cell
        } else if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: self.randomThreeGenre[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: self.randomFourGenre[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: MovieInfo
        if collectionView.tag == 0 {
            movie = self.random[indexPath.row]
        } else if collectionView.tag == 1 {
            movie = self.randomOneGenre[indexPath.row]
        } else if collectionView.tag == 2 {
            movie = self.randomTwoGenre[indexPath.row]
        } else if collectionView.tag == 3 {
            movie = self.randomThreeGenre[indexPath.row]
        } else {
            movie = self.randomFourGenre[indexPath.row]
        }
        
        let movieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToMovieDetail") as! MovieDetailViewController
        
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
