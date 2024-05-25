//
//  ViewController.swift
//  TodoTaskApp
//
//  Created by Surya Vummadi on 25/05/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    var currentPage = 1
    let pageSize = 10  // Adjust the page size as needed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch initial data
        fetchData(page: currentPage)
    }
    
    func fetchData(page: Int) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(pageSize)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let newPosts = try decoder.decode([Post].self, from: data)
                    self.posts.append(contentsOf: newPosts)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = "ID: \(post.id) - \(post.title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 {
            currentPage += 1
            fetchData(page: currentPage)
        }
    }
}

struct Post: Codable {
    let id: Int
    let title: String
}
