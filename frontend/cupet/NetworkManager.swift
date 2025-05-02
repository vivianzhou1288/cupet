//
//  NetworkManager.swift
//  cupet
//
//  Created by Ashley Huang on 5/2/25.
//


import Foundation

class NetworkManager {
    // MARK: - Singleton
    static let shared = NetworkManager()
    private let baseURL = "http://35.221.4.98"
    
    //https://ios-course.cornellappdev.com/chapters/networking-ii/urlsession did not use alamofire due to http vs https
    //https://stackoverflow.com/questions/49514561/swift-4-urlsession
    
    private init() { }
    
    // MARK: - User Management
    
    //used https://github.com/intro-to-ios/lec7-networking2/blob/3-refresh/lec7/Networking/NetworkManager.swift as a reference
    
    func signup(name: String, email: String, password: String, role: String, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = "\(baseURL)/signup/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "role": role
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        let customError = NSError(domain: "SignupError", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = "\(baseURL)/login/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            //https://stackoverflow.com/questions/33158462/swift-creating-nserror-object
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        let customError = NSError(domain: "LoginError", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getUserProfile(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = "\(baseURL)/users/\(userId)/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchPets(completion: @escaping (Result<[Pet], Error>) -> Void) {
        let endpoint = "\(baseURL)/pets/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "Could not convert data to string")")
            //a bunch of debugging
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let petListings = json["pet-postings"] as? [[String: Any]] {
                    
                    var pets: [Pet] = []
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    for petJSON in petListings {
                        if let id = petJSON["id"] as? Int,
                           let name = petJSON["name"] as? String,
                           let petType = petJSON["pet_type"] as? String,
                           let activeness = petJSON["activeness"] as? String,
                           let description = petJSON["description"] as? String,
                           let startDateStr = petJSON["start_date"] as? String,
                           let endDateStr = petJSON["end_date"] as? String,
                           let location = petJSON["location"] as? String,
                           let emailContact = petJSON["email_contact"] as? String,
                           let owner = petJSON["owner"] as? [String: Any],
                           let ownerId = owner["id"] as? Int {
                            
                            let startDate = dateFormatter.date(from: startDateStr) ?? Date()
                            let endDate = dateFormatter.date(from: endDateStr) ?? Date()
                            
                            let pet = Pet(
                                id: id,
                                ownerId: ownerId,
                                name: name,
                                petType: petType,
                                activeness: activeness,
                                description: description,
                                startDate: startDate,
                                endDate: endDate,
                                location: location,
                                emailContact: emailContact
                            )
                            
                            pets.append(pet)
                        }
                    }
                    
                    print("Manually parsed \(pets.count) pets")
                    completion(.success(pets))
                } else {
                    print("Could not parse response as a dictionary with pet-postings")
                    completion(.success([]))
                }
            } catch {
                print("Error parsing pets: \(error.localizedDescription)")
                completion(.success([]))
            }
        }
        
        task.resume()
    }
    
    func getPetDetails(petId: Int, completion: @escaping (Result<Pet, Error>) -> Void) {
        let endpoint = "\(baseURL)/pets/\(petId)/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let pet = try decoder.decode(Pet.self, from: data)
                completion(.success(pet))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func addPet(pet: Pet, completion: @escaping (Result<Pet, Error>) -> Void) {
        let endpoint = "\(baseURL)/pets/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let parameters: [String: Any] = [
            "owner_id": pet.ownerId,
            "name": pet.name,
            "pet_type": pet.petType,
            "activeness": pet.activeness,
            "description": pet.description,
            "start_date": dateFormatter.string(from: pet.startDate),
            "end_date": dateFormatter.string(from: pet.endDate),
            "location": pet.location,
            "email_contact": pet.emailContact
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let pet = try decoder.decode(Pet.self, from: data)
                completion(.success(pet))
            } catch {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        let customError = NSError(domain: "AddPetError", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func deletePet(id: Int, completion: @escaping (Result<Pet, Error>) -> Void) {
        let endpoint = "\(baseURL)/pets/\(id)/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let pet = try decoder.decode(Pet.self, from: data)
                completion(.success(pet))
            } catch {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        let customError = NSError(domain: "DeletePetError", code: 404, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
