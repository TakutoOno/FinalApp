//
//  TopRecommendationMovieCell.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/15.
//

import UIKit
import SDWebImage

class TopRecommendationMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var topPointLabel: UILabel!
    @IBOutlet weak var topCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTopMovie(search: MovieInfo) {
        self.topImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (search.poster_path ?? ""))
        self.topImageView.sd_setImage(with: imageURL)
        if search.pointReviewList.count >= 1 {
            let random = search.pointReviewList.randomElement()
            self.topPointLabel.text = random?.point
            self.topCommentLabel.text = random?.comment
        } else {
            self.topPointLabel.text = "-"
            self.topCommentLabel.text = "レビューなし"
        }
        
        self.topPointLabel.textColor = UIColor.white
        self.topCommentLabel.textColor = UIColor.white
        self.topCommentLabel.layer.borderColor = UIColor(hex: "eeff1f", alpha: 1.0).cgColor
        self.topCommentLabel.layer.borderWidth = 1
        self.topCommentLabel.layer.cornerRadius = 10
    }
}
