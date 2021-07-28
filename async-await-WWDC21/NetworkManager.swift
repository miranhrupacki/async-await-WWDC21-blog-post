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
    static let url = "https://jsonplaceholder.typicode.com/users"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // MARK: fetch users with completion handler
    func fetchUsersFirstExample(completion: @escaping (Result<[User], NetworkingError>) -> Void) {

        let usersURL = URL(string: Constants.url)

        guard let url = usersURL else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    
    
    //MARK: fetch users with async/await using Result type
    func fetchUsersSecondExample() async -> Result<[User], NetworkingError> {
        let usersURL = URL(string: Constants.url)
        
        guard let url = usersURL else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let users = try JSONDecoder().decode([User].self, from: data)
            
            return .success(users)
        }
        catch {
            return .failure(.invalidData)
        }
    }
    
    
    
    //MARK: fetch users with async/await second example, without Result type
    func fetchUsersThirdExample() async throws -> [User]{
        let usersURL = URL(string: Constants.url)
        guard let url = usersURL else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }
}
