//
//  PointReviewViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/03.
//

import UIKit
import RealmSwift

class PointReviewViewController: UIViewController {
    
    @IBOutlet weak var pointSelectTextField: UITextField!
    @IBOutlet weak var timeSelectTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
    var pointSelectPickerView: UIPickerView = UIPickerView()
    var timeSelectPickerView: UIPickerView = UIPickerView()
    
    let realm = try! Realm()
    var movie: MovieModel.Result!
    var movieInfo: MovieInfo!
    
    var pointSelectPickerRow: Int = 0
    var timeSelectPickerRow: Int = 0
    var pickerbuttonNumber : Int = 0
    
    var pointList: [String] = [
    "鳥肌ポイント",
    "感動ポイント",
    "役者ポイント",
    "惜しいポイント"
    ]
    
    var timeList: [String] = [
    "起",
    "承",
    "転",
    "結"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pointSelectTextField.inputView = pointSelectPickerView
        timeSelectTextField.inputView = timeSelectPickerView
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(MovieDetailViewController.tappedDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PointReviewViewController.cancelPicker))
        toolbar.items = [cancelButton, space, doneButton]
        toolbar.sizeToFit()
        pointSelectTextField.inputAccessoryView = toolbar
        timeSelectTextField.inputAccessoryView = toolbar

        pointSelectPickerView.delegate = self
        pointSelectPickerView.dataSource = self
        timeSelectPickerView.delegate = self
        timeSelectPickerView.dataSource = self
        pointSelectPickerView.tag = 1
        timeSelectPickerView.tag = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pointSelectPickerView.reloadAllComponents()
        timeSelectPickerView.reloadAllComponents()
    }
    
    
    @IBAction func pointReviewRegisterButton(_ sender: Any) {
        let pointReview = PointReview()
//        let pointList: [String: Any] =
//        [
//        "pointReview": ["point": self.pointSelectTextField.text!,
//                         "time": self.timeSelectTextField.text!,
//                         "comment": self.commentTextField.text!]
//        ]
//
//        let pointReview = MovieInfo(value: pointList)
//        try! realm.write{
//            self.realm.add(pointReview)
//        }
        
        try! realm.write {
//            let allPointReview = realm.objects(PointReview.self)
//            if allPointReview.count != 0 {
//                pointReview.id = allPointReview.max(ofProperty: "id")! + 1
//            }
//            guard let movieId = movieId else { return }
//            pointReview.movieInfoId = movieId
            pointReview.point = self.pointSelectTextField.text!
            pointReview.time = self.timeSelectTextField.text!
            pointReview.comment = self.commentTextField.text!
            self.realm.add(pointReview)
            movieInfo.pointReviewList.append(pointReview)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIPickerView

extension PointReviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        if (pickerView.tag == 1)  {
        return pointList.count
        } else {
            return timeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        if (pickerView.tag == 1) {
            pickerbuttonNumber = 1
        return pointList[row]
        } else {
            pickerbuttonNumber = 2
            return timeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
        pointSelectPickerRow = row
        } else {
            timeSelectPickerRow = row
        }
    }
    
    @objc func tappedDone(){
        if pickerbuttonNumber == 1 {
        pointSelectTextField.text = pointList[pointSelectPickerRow]
        pointSelectTextField.resignFirstResponder()
        } else {
            timeSelectTextField.text = timeList[timeSelectPickerRow]
            timeSelectTextField.resignFirstResponder()
       }

    }
    @objc func cancelPicker(){
        view.endEditing(true)
    }

}
