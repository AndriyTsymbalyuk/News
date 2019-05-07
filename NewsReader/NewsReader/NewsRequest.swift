//
//  NewsRequest.swift
//  NewsReader
//
//  Created by Andriy Tsymbalyuk on 4/17/19.
//  Copyright © 2019 Andriy Tsymbalyuk. All rights reserved.
//

import Foundation

class NewsRequest {
    static let shared = NewsRequest()
    private init() {}
    
    fileprivate let basePath = "https://newsapi.org/v2/top-headlines?country=ua&apiKey=5150f32130fb439e97f5be00a0eb433d"
    func newsRequest (complition: @escaping([News]?) ->()) {
        guard let url = URL(string: basePath) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response , error) in
            var newsArray:[News] = []
            guard let data = data else {return}
            do {
                guard let api = try? JSONDecoder().decode(News.self, from: data) else {return}
                newsArray.append(api)
            }catch {
                print(error)
            }
            complition(newsArray)
            }.resume()
    }
}
