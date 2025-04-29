//
//  UserManager.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//


import Foundation

class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    private let currentUserKey = "currentUser"
    
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
    
    func isUserLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    func registerUser(name: String, email: String, role: UserRole) -> User {
        let newUser = User(id: UUID().uuidString, name: name, email: email, role: role)
        currentUser = newUser
        return newUser
    }
    
    func signOut() {
        currentUser = nil
    }
}
