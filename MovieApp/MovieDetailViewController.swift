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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var pointPickerTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var movie: MovieModel.Result!
    var movieInfo: MovieInfo!
    
    var pickerView: UIPickerView = UIPickerView()
    
    var pointArray: [String] = []
    
    var pointReviewList = try! Realm().objects(PointReview.self)
    
    var pickerRow: Int = 0
    
    let pointList: [String] = [
        "鳥肌ポイント",
        "感動ポイント",
        "役者ポイント",
        "惜しいポイント"
    ]
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointPickerTextField.inputView = pickerView
        
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
        //  self.pointArray = [pointReviewList]
        
        //        tableView.estimatedRowHeight = 66
        //        tableView.rowHeight = UITableView.automaticDimension
        
        //        observation = tableView.observe(\.contentSize, options: [.new]) { [weak self] (_, _) in
        //                guard let self = self else { return }
        //                self.tableViewHeight.constant = self.tableView.contentSize.height
        //            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (movie.poster_path ?? ""))
        movieImageView.sd_setImage(with: imageURL)
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        pickerView.reloadAllComponents()
        tableView.reloadData()
        //        view.layoutIfNeeded()
        //        view.updateConstraints()
        
    }
    
    // MARK: - IBAction
    
    @IBAction private func pointPlusButton(_ sender: Any) {
        let pointReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "goToPointReview") as! PointReviewViewController
        pointReviewViewController.movie = movie
        pointReviewViewController.movieInfo = movieInfo
        self.navigationController?.pushViewController(pointReviewViewController, animated: true)
    }
    
    
    @IBAction func MoviePlusButton(_ sender: Any) {
        try! realm.write {
        movieInfo.id = movie.id
        movieInfo.picture = movie.poster_path
        movieInfo.overview = movie.overview
        //      movieInfo.pointReviewList = pointReviewList
        self.realm.add(movieInfo, update: .modified)
  //      self.navigationController?.popViewController(animated: true)
    }
    }
    
    
}

//MARK: - UITableView

extension MovieDetailViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointReviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell: PointReviewCell = tableView.dequeueReusableCell(withIdentifier: "pointReviewCell", for: indexPath) as! PointReviewCell
        cell.setPointReview(pointReviewList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.pointReviewList[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
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
        return pointList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return pointList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRow = row
    }
    
    @objc func tappedDone(){
        pointPickerTextField.text = pointList[pickerRow]
        pointPickerTextField.resignFirstResponder()
        
    }
    @objc func cancelPicker(){
        view.endEditing(true)
    }
    
    
}

