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
    
    var registeredMovieInfoList = try! Realm().objects(MovieInfo.self)
    
    var oneGenreMovieInfoList: Results<MovieInfo>!
    var twoGenreMovieInfoList: Results<MovieInfo>!
    var threeGenreMovieInfoList: Results<MovieInfo>!
    var fourGenreMovieInfoList: Results<MovieInfo>!
    
    
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
        
        view.backgroundColor = UIColor.black
        topLabel.textColor = UIColor.white
        collectionView.backgroundColor = UIColor.black
        oneGenreLabel.textColor = UIColor.white
        oneGenreCollectionView.backgroundColor = UIColor.black
        twoGenreLabel.textColor = UIColor.white
        twoGenreCollectionView.backgroundColor = UIColor.black
        threeGenreLabel.textColor = UIColor.white
        threeGenreCollectionView.backgroundColor = UIColor.black
        fourGenreLabel.textColor = UIColor.white
        fourGenreCollectionView.backgroundColor = UIColor.black
        
        let oneGenreNumber = genreNumber.randomElement()!
        let oneIndex = genreNumber.firstIndex(of: oneGenreNumber )
        let oneGenreName = genreName[oneIndex!]
        
        let twoGenreNumber = genreNumber.randomElement()!
        let twoIndex = genreNumber.firstIndex(of: twoGenreNumber )
        let twoGenreName = genreName[twoIndex!]
        
        let threeGenreNumber = genreNumber.randomElement()!
        let threeIndex = genreNumber.firstIndex(of: threeGenreNumber )
        let threeGenreName = genreName[threeIndex!]
        
        let fourGenreNumber = genreNumber.randomElement()!
        let fourIndex = genreNumber.firstIndex(of: fourGenreNumber )
        let fourGenreName = genreName[fourIndex!]
        
        oneGenreLabel.text = oneGenreName
        oneGenreMovieInfoList = try! Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", oneGenreNumber, oneGenreNumber, oneGenreNumber, oneGenreNumber)
        
        twoGenreLabel.text = twoGenreName
        twoGenreMovieInfoList = try! Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", twoGenreNumber, twoGenreNumber, twoGenreNumber, twoGenreNumber)
        
        threeGenreLabel.text = threeGenreName
        threeGenreMovieInfoList = try! Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", threeGenreNumber, threeGenreNumber, threeGenreNumber, threeGenreNumber)
        
        fourGenreLabel.text = fourGenreName
        fourGenreMovieInfoList = try! Realm().objects(MovieInfo.self).filter("firstGenreId = %@ || secondGenreId = %@ || thirdGenreId = %@ || forthGenreId = %@", fourGenreNumber, fourGenreNumber, fourGenreNumber, fourGenreNumber)
        
        
        collectionView.reloadData()
        oneGenreCollectionView.reloadData()
        twoGenreCollectionView.reloadData()
        threeGenreCollectionView.reloadData()
        fourGenreCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        random = Array(registeredMovieInfoList).shuffled()
        randomOneGenre = Array(oneGenreMovieInfoList).shuffled()
        randomTwoGenre = Array(twoGenreMovieInfoList).shuffled()
        randomThreeGenre = Array(threeGenreMovieInfoList).shuffled()
        randomFourGenre = Array(fourGenreMovieInfoList).shuffled()
    
    }
}
//MARK: - collectionView

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //      10以上なら１０　１０以下ならカウント
        if collectionView.tag == 0 {
            if random.count >= 10 {
                return 10
            } else {
                return random.count
            }
        } else if collectionView.tag == 1 {
            if randomOneGenre.count >= 10 {
                return 10
            } else {
                return randomOneGenre.count
            }
        }  else if collectionView.tag == 2 {
            if randomTwoGenre.count >= 10 {
                return 10
            } else {
                return randomTwoGenre.count
            }
        }  else if collectionView.tag == 3 {
            if randomThreeGenre.count >= 10 {
                return 10
            } else {
                return randomThreeGenre.count
            }
        } else {
            if randomFourGenre.count >= 10 {
                return 10
            } else {
                return randomFourGenre.count
        }
    }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //    guard let registeredMovieInfoList = registeredMovieInfoList else { return cell}
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRecommendationMovieCell", for: indexPath) as! TopRecommendationMovieCell
            cell.setTopMovie(search: random[indexPath.row])
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: randomOneGenre[indexPath.row])
            return cell
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: randomTwoGenre[indexPath.row])
            return cell
        } else if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: randomThreeGenre[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as! RecommendationMovieCell
            cell.setMovie(search: randomFourGenre[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //      guard let registeredMovieInfoList = registeredMovieInfoList else { return }
        let movie: MovieInfo
        if collectionView.tag == 0 {
            movie = random[indexPath.row]
        } else if collectionView.tag == 1 {
            movie = randomOneGenre[indexPath.row]
        } else if collectionView.tag == 2 {
            movie = randomTwoGenre[indexPath.row]
        } else if collectionView.tag == 3 {
            movie = randomThreeGenre[indexPath.row]
        } else {
            movie = randomFourGenre[indexPath.row]
        }
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
