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

    @IBOutlet weak var commentTextView: UITextView!
    
    var pointSelectPickerView: UIPickerView = UIPickerView()
    var timeSelectPickerView: UIPickerView = UIPickerView()
    
    var movie: MovieModel.Result?
    
    var movieInfo: MovieInfo?
    
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
        
        self.pointSelectTextField.inputView = self.pointSelectPickerView
        self.timeSelectTextField.inputView = self.timeSelectPickerView
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(MovieDetailViewController.tappedDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PointReviewViewController.cancelPicker))
        toolbar.items = [cancelButton, space, doneButton]
        toolbar.sizeToFit()
        self.pointSelectTextField.inputAccessoryView = toolbar
        self.timeSelectTextField.inputAccessoryView = toolbar
        
        self.pointSelectPickerView.delegate = self
        self.pointSelectPickerView.dataSource = self
        self.timeSelectPickerView.delegate = self
        self.timeSelectPickerView.dataSource = self
        self.pointSelectPickerView.tag = 1
        self.timeSelectPickerView.tag = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pointSelectPickerView.reloadAllComponents()
        self.timeSelectPickerView.reloadAllComponents()
    }
    
    @IBAction func pointReviewRegisterButton(_ sender: Any) {
        if let realm = try? Realm() {
            guard let movieInfo = movieInfo else { return }
            let pointReview = PointReview()
            do {
                try realm.write {
                    pointReview.point = self.pointSelectTextField.text!
                    pointReview.time = self.timeSelectTextField.text!
                    pointReview.comment = self.commentTextView.text!
     //               realm.add(pointReview)
                    movieInfo.pointReviewList.append(pointReview)
                }
            } catch {
                return
            }
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
        if pickerView.tag == 1 {
            return self.pointList.count
        } else {
            return self.timeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        if pickerView.tag == 1 {
            self.pickerbuttonNumber = 1
            return self.pointList[row]
        } else {
            self.pickerbuttonNumber = 2
            return self.timeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.pointSelectPickerRow = row
        } else {
            self.timeSelectPickerRow = row
        }
    }
    
    @objc func tappedDone(){
        if pickerbuttonNumber == 1 {
            self.pointSelectTextField.text = self.pointList[self.pointSelectPickerRow]
            self.pointSelectTextField.resignFirstResponder()
        } else {
            self.timeSelectTextField.text = self.timeList[self.timeSelectPickerRow]
            self.timeSelectTextField.resignFirstResponder()
        }
        
    }
    @objc func cancelPicker(){
        view.endEditing(true)
    }
}
