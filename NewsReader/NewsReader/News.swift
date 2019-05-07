//
//  NewsReader.swift
//  NewsReader
//
//  Created by Andriy Tsymbalyuk on 4/17/19.
//  Copyright © 2019 Andriy Tsymbalyuk. All rights reserved.
//

import Foundation

struct News: Decodable {
    let articles: [Elements]
    }
struct Elements: Decodable {
    let source: SourceElements
    let title: String?
    let description: String?
    let url: String
    let publishedAt: String
    let urlToImage: String
}
struct SourceElements: Decodable {
    let name: String
}
    
    

