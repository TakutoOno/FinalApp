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
    
    
    func setPointReview(_ pointReview: PointReview) {
        self.pointLabel.text = pointReview.point
        self.timeLabel.text = pointReview.time
        self.commentLabel.text = pointReview.comment
    }
}
