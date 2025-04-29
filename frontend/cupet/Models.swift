//
//  Models.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import Foundation

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case owner = "owner"
    case sitter = "sitter"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .owner: return "I have a pet"
        case .sitter: return "I want to pet sit"
        }
    }
}

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var role: UserRole
    var petsPosted: [String] = []
    var petsSitting: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case role
        case petsPosted = "pets_posted"
        case petsSitting = "pets_sitting"
    }
}

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

struct DateRange: Codable {
    var startDate: Date
    var endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}

struct Pet: Identifiable, Codable {
    var id: String
    var ownerId: String
    var name: String
    var type: PetType
    var activeness: Activeness
    var description: String
    var availableDates: DateRange
    var location: DropOffLocation
    var emailContact: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case name
        case type
        case activeness
        case description
        case availableDates = "available_dates"
        case location
        case emailContact = "email_contact"
    }
}
