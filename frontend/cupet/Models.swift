//
//  Models.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import Foundation

// MARK: - UserRole
enum UserRole: String, Codable, CaseIterable, Identifiable {
    case owner = "owner"
    case sitter = "sitter"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .owner: return "Pet Owner"
        case .sitter: return "Pet Sitter"
        }
    }
}

// MARK: - User
struct User: Identifiable, Codable {
    var id: Int
    var name: String
    var email: String
    var role: UserRole
    var petsPosted: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case role
        case petsPosted = "pets_posting"
    }
}

// MARK: - PetType
enum PetType: String, Codable, CaseIterable, Identifiable {
    case dog = "Dog"
    case cat = "Cat"
    case bird = "Bird"
    case hamster = "Hamster"
    case rabbit = "Rabbit"
    case fish = "Fish"
    case reptile = "Reptile"
    case other = "Other"
    
    var id: String { self.rawValue }
}

// MARK: - Activeness
enum Activeness: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .low: return "Chill - Relaxed, low energy"
        case .medium: return "Medium - Some activity needed"
        case .high: return "Energetic - Very active"
        }
    }
}

// MARK: - DropOffLocation
enum DropOffLocation: String, Codable, CaseIterable, Identifiable {
    case north = "North: RPCC"
    case west = "West: Noyes"
    case collegetown = "Ctown: in front of Schwartz"
    case central = "Central: WSH"
    
    var id: String { self.rawValue }
    
    var shortName: String {
        switch self {
        case .north: return "North"
        case .west: return "West"
        case .collegetown: return "Ctown"
        case .central: return "Central"
        }
    }
}

// MARK: - Pet
struct Pet: Identifiable, Codable {
    var id: Int
    var ownerId: Int
    var name: String
    var petType: String
    var activeness: String
    var description: String
    var startDate: Date
    var endDate: Date
    var location: String
    var emailContact: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case name
        case petType = "pet_type"
        case activeness
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case location
        case emailContact = "email_contact"
    }
}
