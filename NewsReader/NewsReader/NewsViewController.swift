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
private var newsData = [News]()
private var arrFilter = [News]()
private var isSearch = false
private let refresher = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!
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

    private func updateNews () {
        NewsRequest.shared.newsRequest(complition: { (results:([News]?)) in
            if let dataOfNews = results {
                self.newsData = dataOfNews
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    )}
    private func showWebsite(url: String) {
        if let urlWebsite = URL(string: url) {
            let webVC = SFSafariViewController(url: urlWebsite)
            self.present(webVC, animated: true, completion: nil)
        }
    }
    private func getFormatedDate(date_string:String,dateFormat:String)-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateFormat
        
        let dateFromInputString = dateFormatter.date(from: date_string)
        dateFormatter.dateFormat = "HH:mm" // Here you can use any dateformate for output date
        if(dateFromInputString != nil){
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            debugPrint("could not convert date")
            return "N/A"
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearch ? arrFilter.count : newsData.count

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearch ? arrFilter[0].articles.count : newsData[0].articles.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell {
            let dataArr = isSearch ? arrFilter : newsData
            cell.accessoryType = .detailDisclosureButton
            let newsObject = dataArr[0].articles[indexPath.row]
            cell.urlToImage.downloaded(from: newsObject.urlToImage)
            cell.sourceLabel.text = newsObject.source.name
            cell.titleLabel.text = newsObject.title
            cell.descriptionLabel.text = newsObject.description
            cell.publishedLabel.text = getFormatedDate(date_string: newsObject.publishedAt, dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ") 
            return cell
        }
return UITableViewCell()
}
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let newsObject = newsData[0].articles[indexPath.row]
        let url = newsObject.url
        showWebsite(url: url)
        
        
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let newsObject = newsData[0].articles[indexPath.row]
//        let url = newsObject.url
//        showWebsite(url: url)
//    }
}

extension NewsTableViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension NewsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearch = false
        }else {
            arrFilter = newsData.filter({ (news) -> Bool in
                guard let text = searchBar.text else  {return false}
                return (news.articles[0].description?.contains(text))!
            })
        tableView.reloadData()
        }
    }
}

