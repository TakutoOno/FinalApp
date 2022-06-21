//
//  PointReviewViewController.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/03.
//

import UIKit
import RealmSwift
import SVProgressHUD

class PointReviewViewController: UIViewController {
    
    @IBOutlet weak var pointSelectLabel: UILabel!
    @IBOutlet weak var pointSelectTextField: UITextField!
    @IBOutlet weak var timeSelectLabel: UILabel!
    @IBOutlet weak var timeSelectTextField: UITextField!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var registerButton: UIButton!
    
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
        "戦闘ポイント",
        "面白ポイント",
        "惜しいポイント"
    ]
    
    var timeList: [String] = [
        "起",
        "承",
        "転",
        "結"
    ]
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.pointSelectTextField.inputView = self.pointSelectPickerView
        self.timeSelectTextField.inputView = self.timeSelectPickerView
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(PointReviewViewController.tappedDone))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PointReviewViewController.cancelPicker))
        toolbar.items = [cancelButton, space, doneButton]
        toolbar.sizeToFit()
        self.pointSelectTextField.inputAccessoryView = toolbar
        self.timeSelectTextField.inputAccessoryView = toolbar
        
        self.pointSelectTextField.delegate = self
        self.timeSelectTextField.delegate = self
        self.pointSelectPickerView.delegate = self
        self.pointSelectPickerView.dataSource = self
        self.timeSelectPickerView.delegate = self
        self.timeSelectPickerView.dataSource = self
        self.pointSelectPickerView.tag = 1
        self.timeSelectPickerView.tag = 2
        
        self.pointSelectLabel.textColor = UIColor.white
        self.timeSelectLabel.textColor = UIColor.white
        self.commentLabel.textColor = UIColor.white
        self.registerButton.backgroundColor = UIColor(hex: "eeff1f", alpha: 1.0)
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.tintColor = UIColor.black
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pointSelectPickerView.reloadAllComponents()
        self.timeSelectPickerView.reloadAllComponents()
        
        self.commentTextView.text = ""
    }
    
//MARK: - IBAction
    
    @IBAction func pointReviewRegisterButton(_ sender: Any) {
        if self.pointSelectTextField.text == "" || self.timeSelectTextField.text == "" || self.commentTextView.text == "" {
         //   SVProgressHUD.showError(withStatus: "全て入力して下さい")
            return
        }
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
    
    @objc func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
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

//MARK: - TextField

extension PointReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
