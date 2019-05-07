//
//  ExtansionUIImageView.swift
//  News
//
//  Created by Andriy Tsymbalyuk on 5/7/19.
//  Copyright © 2019 Andriy Tsymbalyuk. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView {
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
