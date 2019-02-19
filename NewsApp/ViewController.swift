//
//  ViewController.swift
//  NewsApp
//
//  Created by Yash Nayak on 14/02/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Instance Vars
    @IBOutlet weak var tableView: UITableView!
    
    // Array for storing Article
    var articles:[Article]? = []
    
    // Default Article url
    var chosenArticleUrl = ""
    
    // Setting Default source to "TechRadar"
    var source = "TechRadar"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checking that selected source is recived in variable source
        //print("Source(ViewController):"+source)
        
        // Setting Navigation Bar Title
        self.title = "Daily Feed"
        
        // Fetching article with sources
        // Default source is "TechRadar"
        fetchArticle(fromSource: source)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenArticleUrl = (self.articles?[indexPath.item].url)!
        
        // Checking Article Url
        print("Checking Article Url: "+chosenArticleUrl)
        
        //Passing Article Url to Browser
        let application = UIApplication.shared
        let webURL = URL(string: "\(chosenArticleUrl)")!
        application.open(webURL)
        
    }
    
    
    // MARK: - fetchArticle
    func fetchArticle (fromSource provider: String){
        
       // Get live headlines, articles, images, and other article metadata from Source with JSON API.
       let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=putyourapikeyhere")!)
        
        print(urlRequest)
        let task = URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil {
                // Print error if there is error in fetching data from newsapi.org
                print("Error in fetching data")
                return
            }
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                // Taking data from database and cast it as a dictionary
                if let articlesFromWeb = json["articles"] as? [[String:AnyObject]] {
                    for articleFromJson in articlesFromWeb {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let imageUrl = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.urlImage = imageUrl
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    // Reload Data to TableView
                    self.tableView.reloadData()
                    print("reload")
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}

extension UIImageView{
    // MARK: - downloadImage
    func downloadImage(from url:String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil {
                // Print error if there is error in fetching image from newsapi.org
                print("error in downloading image")
                return
            }
            DispatchQueue.main.async {
                // Showing image featch from newsapi.org
                self.image = UIImage(data:data!)
            }
        }
        task.resume()
    }
}

// MARK: - Table View Data Source
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Initializing identifier for TableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        
        // Showing MetaData of article in TableView
        cell.titleLabel.text = self.articles?[indexPath.item].headline
        cell.descLabel.text = self.articles?[indexPath.item].desc
        cell.authorLabel.text = self.articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].urlImage) ?? "https://images.immediate.co.uk/volatile/sites/3/2017/11/imagenotavailable1-39de324.png?quality=90&resize=620,413")
        
        // Return cell with information
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the total number of articles to TableView
        return self.articles?.count ?? 0
        // if there are no article it will return as 0 instead of crashing
    }
    
}

