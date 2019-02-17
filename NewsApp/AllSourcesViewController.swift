//
//  AllSourcesViewController.swift
//  NewsApp
//
//  Created by Yash Nayak on 14/02/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit
import NewsAPI

class AllSourcesViewController: UIViewController {

    // MARK: - Instance Vars
    @IBOutlet weak var allSourcesTableView: UITableView!
    
    var mainVC: ViewController?
    var sources = [NewsAPISource]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calling function at start instant
        setUpSourcesTableView()
        loadSources()
    }
    
    // Load the list of all the Sources from newsapi.org
    func loadSources() {
        NewsAPI.getAllSources { (sources, error) in
            if error == nil && sources != nil {
                self.sources = sources!
                DispatchQueue.main.async {
                    // Print all the source with ID and Name in TableView
                    self.allSourcesTableView.reloadData()
                }
            } else {
                // Print error if there is error in fetching data from newsapi.org
                print(error?.localizedDescription ?? "Unkown Error")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source
extension AllSourcesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUpSourcesTableView() {
        // Set the dataSource and delegate to self
        allSourcesTableView.delegate = self
        allSourcesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the total number of source to TableView
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Initializing identifier for TableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSource", for: indexPath)
        
        let currentSource = sources[indexPath.section]
        
        // Showing ID of source in TableView
        let idLabel = cell.viewWithTag(1) as! UILabel
        idLabel.text = currentSource.id
        
         // Showing Name of source in TableView
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = (currentSource.name != nil) ? currentSource.name!:"No Source Name"
        
        // Return cell with information
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Saving current source ID in currentSource
        let currentSource = sources[indexPath.section]
        print(currentSource.id!)
        
        // Declaring Variable to pass to ViewController
        let selectSource = (currentSource.id!)
        print(selectSource)
        
        // Instantiate ViewController
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        // Set "Name of source" as a value to source
        secondViewController.source = selectSource
        
        // Take user to ViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
}
