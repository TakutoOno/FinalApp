//
//  MovieInfo.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import Foundation
import RealmSwift

class MovieInfo: Object {
    
    @objc dynamic var id:Int = 0
    
    @objc dynamic var title: String = ""
    
    @objc dynamic var poster_path: String?
    
    @objc dynamic var overview: String = ""
    
    @objc dynamic var firstGenreId: Int = 0
    
    @objc dynamic var secondGenreId: Int = 0
    
    @objc dynamic var thirdGenreId: Int = 0
    
    @objc dynamic var forthGenreId: Int = 0
    
    @objc dynamic var vote_average: String!
    
    @objc dynamic var score: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var pointReviewList = List<PointReview>()
    
}

class PointReview: Object {
    
    @objc dynamic var movieInfoId: Int = 0
    
    @objc dynamic var point: String = ""
    
    @objc dynamic var time: String = ""
    
    @objc dynamic var comment: String = ""
    
}
