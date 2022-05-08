//
//  ViewController.swift
//  Journo
//
//  Created by Dragos Albastroiu on 04.05.2022.
//

import UIKit
import FirebaseAuth

public struct Post:Codable{
    let breeds: [String]
    let id: String
    let url: String
    let width: Int64
    let height: Int64
}

public struct UserPost {
    let username: String
    let profileUrl: String?
    let pictureUrl: String
    let imageUrl: String
    let thumbnailImage: String
}

class HomeViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: FeedPostTableViewCell.identifier)
        
        return tableView
    }()
    
    private var postData: [UserPost] = []
    
    func decodeAPI(){
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=5") else{return}

        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([Post].self, from: data)
                    tasks.forEach{ i in
                        self.postData.append(UserPost(username: i.id, profileUrl: i.url, pictureUrl: i.url, imageUrl: i.url, thumbnailImage: i.url))
                        print(self.postData.count)
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        view.backgroundColor = .systemBackground
        DatabaseManager.shared.initDatabase()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        decodeAPI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: false)
        }
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("PostDataCount \(postData.count)")
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserFollowTableViewCell.identifier, for: indexPath) as! FeedPostTableViewCell
        cell.configure(model: postData[indexPath.row])
        print(postData[indexPath.row].username)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = postData[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}
