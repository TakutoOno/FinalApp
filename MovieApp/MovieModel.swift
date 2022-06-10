//
//  MovieModel.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import Foundation

//struct MovieModel: Codable {
//    let results: [Result]
//}
//    struct Result: Codable {
//        let posterPath: String?
//        let id: Int
//        let overview: String
//        let title: String
//
//        enum CodingKeys: String, CodingKey {
//            case posterPath = "poster_path"
//            case id = "id"
//            case overview = "overview"
//            case title = "title"
//        }
//    }


struct MovieModel: Decodable {
    var page: Int
    var results: [Result]
    struct Result: Decodable {
        var poster_path: String?
        var adult: Bool
        var overview: String
        var release_date: String
        var genre_ids: [Int]
        var id: Int
        var original_title: String
        var original_language: String
        var title: String
        var backdrop_path: String?
        var popularity: Decimal
        var vote_count: Int
        var video: Bool
        var vote_average: Decimal
    }
    var total_results: Int
    var total_pages: Int
}

