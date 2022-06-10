//
//  MovieCell.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/03.
//

import UIKit
import Moya
import SDWebImage

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setMovie(search: MovieModel.Result) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w200" + (search.poster_path ?? ""))
        imageView.sd_setImage(with: imageURL)
        titleLabel.text = search.title

    
}
}
