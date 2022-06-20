//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/03.
//

import UIKit
import RealmSwift
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet weak var overviewTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pointReviewPulsButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var borderLabel: UILabel!
    
    var realm = try? Realm()
    
    var movie: MovieModel.Result?
    
    var movieInfo: MovieInfo?
    
    var imageURL: URL?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib: UINib = UINib(nibName: "PointReviewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "pointReviewCell")
        
        tableView.separatorColor = .yellow
        
        self.view.backgroundColor = UIColor.black
        self.titleLabel.textColor = UIColor.white
        self.overviewTitle.textColor = UIColor.white
        self.overviewLabel.textColor = UIColor.white
        self.tableView.backgroundColor = UIColor.black
        self.borderLabel.layer.borderColor = UIColor(hex: "eeff1f", alpha: 1.0).cgColor
        self.borderLabel.layer.borderWidth = 1
        self.pointReviewPulsButton.backgroundColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.pointReviewPulsButton.layer.cornerRadius = 10
        self.pointReviewPulsButton.tintColor = UIColor.black
        self.registerButton.backgroundColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.registerButton.tintColor = UIColor.black
        self.registerButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movieInfo = movieInfo else { return }
        if let movie = movie {
            self.movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (movie.poster_path ?? ""))
            self.movieImageView.sd_setImage(with: self.imageURL)
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
        } else {
            self.movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (movieInfo.poster_path ?? ""))
            self.movieImageView.sd_setImage(with: self.imageURL)
            self.titleLabel.text = movieInfo.title
            self.overviewLabel.text = movieInfo.overview
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = self.tableView.tableHeaderView {
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                self.tableView.tableHeaderView = headerView
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func pointPlusButton(_ sender: Any) {
        let pointReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToPointReview") as! PointReviewViewController
        if let movie = movie {
            pointReviewViewController.movie = movie
        }
        pointReviewViewController.movieInfo = self.movieInfo
        self.navigationController?.pushViewController(pointReviewViewController, animated: true)
    }
    
    @IBAction func MoviePlusButton(_ sender: Any) {
        guard let realm = realm, let movieInfo = movieInfo else { return }
        try? realm.write {
            if let movie = movie {
                if  movieInfo.id == 0 {
                    movieInfo.id = movie.id
                }
                movieInfo.title = movie.title
                movieInfo.poster_path = movie.poster_path
                movieInfo.overview = movie.overview
                if movie.genre_ids[0] >= 1 {
                    movieInfo.firstGenreId = movie.genre_ids[0]
                }
                if movie.genre_ids.count >= 2 {
                    movieInfo.secondGenreId = movie.genre_ids[1]
                }
                if movie.genre_ids.count >= 3 {
                    movieInfo.thirdGenreId = movie.genre_ids[2]
                }
                if movie.genre_ids.count >= 4{
                    movieInfo.forthGenreId = movie.genre_ids[3]
                }
                realm.add(movieInfo, update: .modified)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableView

extension MovieDetailViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieInfo?.pointReviewList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell: PointReviewCell = tableView.dequeueReusableCell(withIdentifier: "pointReviewCell", for: indexPath) as! PointReviewCell
        guard let movieInfo = self.movieInfo else { return cell }
        cell.setPointReview(movieInfo.pointReviewList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            guard let realm = realm, let movieInfo = self.movieInfo else { return }
            try? realm.write {
                realm.delete(movieInfo.pointReviewList[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
}
