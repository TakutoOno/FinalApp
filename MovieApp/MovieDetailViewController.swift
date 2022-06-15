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
    @IBOutlet weak var pointPickerTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    var realm = try? Realm()
    
    var movie: MovieModel.Result?
    
    var movieInfo: MovieInfo?
    
    var pickerView: UIPickerView = UIPickerView()
    
    var pointArray: [String] = []
    
    var pickerRow: Int = 0
    
    let pointList: [String] = [
        "鳥肌ポイント",
        "感動ポイント",
        "役者ポイント",
        "惜しいポイント"
    ]
    
    var imageURL: URL?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     realm = try? Realm()
        
        self.pointPickerTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(MovieDetailViewController.tappedDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MovieDetailViewController.cancelPicker))
        toolbar.items = [cancelButton, space, doneButton]
        toolbar.sizeToFit()
        self.pointPickerTextField.inputAccessoryView = toolbar
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib: UINib = UINib(nibName: "PointReviewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "pointReviewCell")
        
        self.view.backgroundColor = UIColor.black
        self.titleLabel.textColor = UIColor.white
        self.overviewTitle.textColor = UIColor.white
        self.overviewLabel.textColor = UIColor.white
        self.tableView.backgroundColor = UIColor.black
        self.registerButton.backgroundColor = UIColor.gray
        self.registerButton.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movieInfo = movieInfo else { return }
        if let movie = movie {
            self.movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (movie.poster_path ?? ""))
            self.movieImageView.sd_setImage(with: imageURL)
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
        } else {
            self.movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (movieInfo.poster_path ?? ""))
            self.movieImageView.sd_setImage(with: imageURL)
            self.titleLabel.text = movieInfo.title
            self.overviewLabel.text = movieInfo.overview
        }
        self.pickerView.reloadAllComponents()
        self.tableView.reloadData()
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
                    movieInfo.firstGenreId = movie.genre_ids[3]
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
        return movieInfo?.pointReviewList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell: PointReviewCell = tableView.dequeueReusableCell(withIdentifier: "pointReviewCell", for: indexPath) as! PointReviewCell
        guard let movieInfo = movieInfo else { return cell }
        cell.setPointReview(movieInfo.pointReviewList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            guard let realm = realm, let movieInfo = movieInfo else { return }
                try? realm.write {
                    realm.delete(movieInfo.pointReviewList[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
}

//MARK: - UIPickerView

extension MovieDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        return self.pointList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return self.pointList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerRow = row
    }
    
    @objc func tappedDone(){
        self.pointPickerTextField.text = self.pointList[self.pickerRow]
        self.pointPickerTextField.resignFirstResponder()
    }
    
    @objc func cancelPicker(){
        view.endEditing(true)
    }
}

