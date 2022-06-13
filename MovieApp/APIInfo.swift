//
//  APIInfo.swift
//  MovieApp
//
//  Created by 小野 拓人 on 2022/06/02.
//

import Foundation
import Moya

enum API {
    case search(query: String)
}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/") else { fatalError() }
        return url
    }
    var path: String {
        switch self {
        case .search:
            return "search/movie"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .search(let query):
            return .requestParameters(parameters: [
                "query" : query,
                "api_key": "f429e7ea56b47c5b30f36ecc50904e3c",
                "language": "ja",
                "page": "1"
            ], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
