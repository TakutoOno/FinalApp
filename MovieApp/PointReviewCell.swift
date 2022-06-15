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
        
        self.pointLabel.textColor = UIColor.white
        self.pointLabel.backgroundColor = UIColor.blue
        self.timeLabel.textColor = UIColor.white
        self.timeLabel.backgroundColor = UIColor.blue
        self.commentLabel.textColor = UIColor.white
        self.commentLabel.layer.borderColor = UIColor.blue.cgColor
        self.commentLabel.layer.borderWidth = 1
        self.commentLabel.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.contentView.backgroundColor = UIColor.black
    }
}
