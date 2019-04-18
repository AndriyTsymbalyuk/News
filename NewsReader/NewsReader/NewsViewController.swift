//
//  ViewController.swift
//  NewsReader
//
//  Created by Andriy Tsymbalyuk on 4/16/19.
//  Copyright © 2019 Andriy Tsymbalyuk. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController {

var newsData = [News]()
private let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refresherNewsData), for: .valueChanged)
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
    updateNews()
    }
    
    @objc private func refresherNewsData () {
        refresher.attributedTitle = NSAttributedString(string: "Fetching News Data")
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.updateNews()
            self.refresher.endRefreshing()
        }
    }

    func updateNews () {
        NewsRequest.shared.newsRequest(complition: { (results:([News]?)) in
            if let dataOfNews = results {
               let newdata = dataOfNews.sorted(by: { (news1, news2) -> Bool in
                    news1.articles[0].publishedAt < news2.articles[0].publishedAt
                })
                print(dataOfNews[0].articles[0].publishedAt, newdata[0].articles[0].publishedAt)
                self.newsData = newdata
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    )}
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsData.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData[0].articles.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell {
            let newsObject = newsData[0].articles[indexPath.row]
            cell.authorLabel.text = newsObject.author
            cell.sourceLabel.text = newsObject.source.name
            cell.titleLabel.text = newsObject.publishedAt
            cell.descriptionLabel.text = newsObject.description
            return cell
        }
return UITableViewCell()
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsObject = newsData[0].articles[indexPath.row]
        let url = newsObject.url
        showWebsite(url: url)
    }
    func showWebsite(url: String) {
        if let urlWebsite = URL(string: url) {
        let webVC = SFSafariViewController(url: urlWebsite)
        self.present(webVC, animated: true, completion: nil)
    }
    }
    
    
}

extension NewsTableViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
