//
//  NetworkManager.swift
//  async-await-WWDC21
//
//  Created by Miran Hrupacki on 08.07.2021..
//

import Foundation

enum NetworkingError: Error {
    case unableToComplete
    case invalidData
    case invalidURL
    case invalidResponse
}

struct Constants {
    static let url = "https://jsonplaceholder.typicode.com/todos"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // MARK: fetch todos with completion handler
//    func fetchTodos(completion: @escaping (Result<[Todo], NetworkingError>) -> Void) {
//
//        let todosURL = URL(string: Constants.url)
//
//        guard let url = todosURL else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let _ = error {
//                completion(.failure(.unableToComplete))
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let todos = try JSONDecoder().decode([Todo].self, from: data)
//                completion(.success(todos))
//            } catch {
//                completion(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }

    
    
    //MARK: fetch todos with async/await using Result type
//    func fetchTodos() async -> Result<[Todo], NetworkingError> {
//        let todosURL = URL(string: Constants.url)
//        
//        guard let url = todosURL else {
//            return .failure(.invalidURL)
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let todos = try JSONDecoder().decode([Todo].self, from: data)
//            
//            return .success(todos)
//        }
//        catch {
//            return .failure(.invalidData)
//        }
//    }
    
    
    
    //MARK: fetch todos with async/await second example, without Result type
    func fetchTodos() async throws -> [Todo]{
        let todosURL = URL(string: Constants.url)
        guard let url = todosURL else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let todos = try JSONDecoder().decode([Todo].self, from: data)
        return todos
    }
}
