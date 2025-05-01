//
//  UserManager.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import Foundation

class UserManager {
    // MARK: - Singleton
    static let shared = UserManager()
    private init() {}
    
    // MARK: - Properties
    private let currentUserKey = "currentUser"
    
    // MARK: - User Management
    var currentUser: User? {
        get {
            if let userData = UserDefaults.standard.data(forKey: currentUserKey),
               let user = try? JSONDecoder().decode(User.self, from: userData) {
                return user
            }
            return nil
        }
        set {
            if let newValue = newValue,
               let userData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(userData, forKey: currentUserKey)
            } else {
                UserDefaults.standard.removeObject(forKey: currentUserKey)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Mock implementation for demo
        let dummyUser = User(id: 1, name: "Cornell Student", email: email, role: .sitter)
        self.currentUser = dummyUser
        completion(.success(dummyUser))
    }
    
    func isUserLoggedIn() -> Bool {
        return currentUser != nil
    }

    func registerUser(name: String, email: String, role: UserRole) -> User {
        let newUser = User(id: Int.random(in: 1...1000), name: name, email: email, role: role)
        currentUser = newUser
        return newUser
    }
    
    func signOut() {
        currentUser = nil
    }
}
