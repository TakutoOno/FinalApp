//
//  PointReviewCell.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/06.
//

import UIKit

class PointReviewCell: UITableViewCell {
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //映画レビューはMovieInfoのpointReviewListから取得
    func setPointReview(_ pointReview: PointReview) {
        self.pointLabel.text = pointReview.point
        self.timeLabel.text = pointReview.time
        self.commentLabel.text = pointReview.comment
        
        switch timeLabel.text {
        case "起" :
            self.timeLabel.textColor = UIColor.red
        case "承":
            self.timeLabel.textColor = UIColor.white
        case "転":
            self.timeLabel.textColor = UIColor(hex: "11b0e9", alpha: 1.0)
        case "結":
            self.timeLabel.textColor = UIColor.yellow
        default:
            self.timeLabel.textColor = UIColor.black
        }
        
        self.pointLabel.textColor = UIColor.white
        self.timeLabelView.layer.borderColor = UIColor(hex: "eeff1f", alpha: 1.0).cgColor
        self.timeLabelView.layer.borderWidth = 2
        self.timeLabelView.layer.cornerRadius = 10
        self.timeLabel.layer.cornerRadius = 10
        self.timeLabel.clipsToBounds = true
        self.commentLabel.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.black
    }
}
