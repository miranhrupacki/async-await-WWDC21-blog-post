//
//  ViewController.swift
//  async-await-WWDC21
//
//  Created by Miran Hrupacki on 08.07.2021..
//

import UIKit


struct User: Codable {
    let name: String
    let email: String
    let username: String
}

class ViewController: UIViewController {
        
    private var users = [User]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
//    MARK: call this functions for first example
//        getUsersFirstExample()
//    MARK: call this functions for second example
//        getUsersSecondExample()
//    MARK: 3. example of async await without Result type
        async {
            let users = await getUsersThirdExample()
            guard let users = users else { return }
                self.users = users
                self.tableView.reloadData()
        }
    }
    
//MARK: 1. example -> with completion handlers
    private func getUsersFirstExample() {
        NetworkManager.shared.fetchUsersFirstExample { [weak self] result in
            guard let weakself = self else { return }

            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    weakself.users = users
                    weakself.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
//MARK: 2. example -> async/await with Result type
    
    private func getUsersSecondExample() {
        async {
            let result = await NetworkManager.shared.fetchUsersSecondExample()

            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
//MARK: 3. example -> async/await without Result type
    private func getUsersThirdExample() async -> [User]? {
        do {
            let result = try await NetworkManager.shared.fetchUsersThirdExample()
            return result
        } catch {
            // handle errors
        }
        return nil
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text =
        "\(indexPath.row + 1). " +
        "Name: \(users[indexPath.row].name)" +
        "\n    username: \(users[indexPath.row].username)" +
        "\n    email: \(users[indexPath.row].email)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
