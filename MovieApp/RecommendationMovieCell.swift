//
//  RecommendationMovieCell.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/12.
//

import UIKit
import SDWebImage

class RecommendationMovieCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setMovie(search: MovieInfo) {
        self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (search.poster_path ?? ""))
        self.imageView.sd_setImage(with: imageURL)
    }

}
