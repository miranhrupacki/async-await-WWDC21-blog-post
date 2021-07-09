//
//  ViewController.swift
//  async-await-WWDC21
//
//  Created by Miran Hrupacki on 08.07.2021..
//

import UIKit


struct Todo: Codable {
    let title: String
}

class ViewController: UIViewController {
        
    private var todos = [Todo]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
//        MARK: call this function for first and second example
//        getTodos()
        
//    MARK: 3. example of async await without Result type
        async {
            let todos = await self.getTodos()
            guard let todos = todos else { return }
            self.todos = todos
            tableView.reloadData()
        }
    }
    
//MARK: 1. example with completion handlers
//    private func getTodos() {
//        NetworkManager.shared.fetchTodos { [weak self] result in
//            guard let weakself = self else { return }
//
//            switch result {
//            case .success(let todos):
//                DispatchQueue.main.async {
//                    weakself.todos = todos
//                    weakself.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
    
//MARK: 2. example async/await with Result type
//    private func getTodos() {
//        async {
//            let result = await NetworkManager.shared.fetchTodos()
//
//            switch result {
//            case .success(let todos):
//                DispatchQueue.main.async {
//                    self.todos = todos
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
    
//MARK: async/await without Result type
    private func getTodos() async -> [Todo]? {
        do {
            let result = try await NetworkManager.shared.fetchTodos()
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
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1). " + todos[indexPath.row].title
        return cell
    }
}
