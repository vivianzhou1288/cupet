//
//  PetSitterViewController.swift
//  cupet
//
//  Created by Shreya Majumdar on 4/30/25.
//

//import UIKit
//
//class PetSitterViewController: UIViewController {
//    // MARK: - Properties (view)
//
//    private var collectionView: UICollectionView!
//    private let refreshControl = UIRefreshControl()
//
//    // MARK: - Properties (data)
//    
//    private var petSittingAppointments: [Pet] = []
//
//    // MARK: - viewDidLoad
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "Pet Sitting Requests"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        view.backgroundColor = UIColor.white
//        
//        setupCollectionView()
//        // fetchPetSittingRequests()
//    }
//    
//    // MARK: - Set Up Views
//
//    private func setupCollectionView() {
//
//        let padding: CGFloat = 24   // Use this constant when configuring constraints
//
//        // TODO: Set Up CollectionView
//        // Create a FlowLayout
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 16
//        
//        // Initialize CollectionView with the layout
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.white
//        
//        collectionView.register(PetSittingRequestCollectionViewCell.self, forCellWithReuseIdentifier: PetSittingRequestCollectionViewCell.reuse)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        
//        // refreshControl.addTarget(self, action: #selector(fetchPetSittingRequests()), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
//        
//        view.addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
//        ])
//    }
//    
//    // MARK: - Networking
////    @objc private func fetchPetSittingRequests() {
////        NetworkManager.shared.fetchPosts { [weak self] posts in
////            guard let self = self else { return }
////            self.posts = posts
////
////            // Perform UI update on main queue
////            DispatchQueue.main.async {
////                self.collectionView.reloadData()
////                self.refreshControl.endRefreshing()
////            }
////        }
////    }
//    
////    @objc private func addNewPost() {
////        // WHAT IS THIS SUPPOSED TO BE?
////       let postie = Post(id: "blah", likes: [], message: "hi", time: Date())
////
////        NetworkManager.shared.addNewPost(post: postie) { post in
////            // Do something with the member if needed
////        }
////    }
//
//}
//
//// MARK: - UICollectionViewDelegate
//
//extension PetSitterViewController: UICollectionViewDelegate { }
//
//// MARK: - UICollectionViewDataSource
//
//extension PetSitterViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // TODO: Return the cells for each section
//        // HINT: Use `indexPath.section` with an if statement
//        // USE THE CONFIGURE FUNCTION HERE
//        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetSittingRequestCollectionViewCell.reuse, for: indexPath) as? PetSittingRequestCollectionViewCell else { return UICollectionViewCell() }
//        
//        //             cell.configure(post: posts[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // TODO: Return the number of rows for each section
//        // HINT: Use `section` with an if statement
//
//        return petSittingAppointments.count // Replace this line
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // TODO: Return the number of sections in this table view
//        // Is this two for two types of cells?
//        return 2 // Replace this line
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        // TODO: Return the inset for the spacing between the two sections
//
//        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0) // Replace this line
//    }
//
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension PetSitterViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // TODO: Return the size for each cell per section
//        // HINT: Use `indexPath.section` with an if statement
//        let screenSize = collectionView.frame.width
//        
//        if (indexPath.section == 0) {
//            return CGSize(width: screenSize, height: 150)
//        }
//        return CGSize(width: screenSize, height: 200)
//    }
//
//}

import SwiftUI

struct PetSitterView: View {
    // MARK: - Properties
    @State private var petSittingRequests: [Pet] = []
    @State private var isLoading = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // First section
                    Section {
                        ForEach(petSittingRequests) { pet in
                            PetSittingRequestCell(pet: pet)
                                .frame(height: 150) // HEIGHT OF THE CELL IN PET REQUESTS
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            .refreshable {
                await fetchPetSittingRequests()
            }
            .navigationTitle("Pet Sitting Requests")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            Task {
                await fetchPetSittingRequests()
            }
        }
    }
    
    // MARK: - Methods
    @Sendable private func fetchPetSittingRequests() async {
        isLoading = true
        
        // Replace with actual networking code
        // Example:
        // do {
        //     petSittingRequests = try await NetworkManager.shared.fetchPetSittingRequests()
        // } catch {
        //     print("Error fetching pet sitting requests: \(error)")
        // }
        
        // For demo purposes, populate with sample data
        let dummyPet = Pet(
            id: 1,
            ownerId: 1,
            name: "Buddy",
            petType: PetType.dog.rawValue,
            activeness: Activeness.medium.rawValue,
            description: "Friendly golden retriever",
            startDate: Date(),
            endDate: Date(),
            location: DropOffLocation.north.rawValue,
            emailContact: "sample@cornell.edu"
        )
        
        let petunia = Pet(
            id: 3,
            ownerId: 2,
            name: "Petunia",
            petType: "Stuffed Toy",
            activeness: Activeness.low.rawValue,
            description: "This is my childhood stuffed toy",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 3), // 3 days later
            location: DropOffLocation.west.rawValue,
            emailContact: "sm2435@cornell.edu"
        )
        
        let max = Pet(
            id: 7,
            ownerId: 2,
            name: "Max",
            petType: "Dog",
            activeness: Activeness.high.rawValue,
            description: "Max is a friendly Golden Retriever who loves to play fetch and go for long walks.",
            startDate: Date().addingTimeInterval(86400 * 5), // 5 days later
            endDate: Date().addingTimeInterval(86400 * 8), // 8 days later
            location: DropOffLocation.west.rawValue,
            emailContact: "dog_lover@cornell.edu"
        )
        
        petSittingRequests = [dummyPet, petunia, max]
        
        isLoading = false
    }
}

// MARK: - Pet Sitting Request Cell
struct PetSittingRequestCell: View {
    let pet: Pet
    private let primaryRed = Color(hex: "B31B1B")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Name
            Text(pet.name)
                .font(.system(size: 18, weight: .semibold))
                .padding(.top)
                .padding(.leading, 10)
            
            // Type and Activeness row
            HStack {
                Text("Pet Type: \(pet.petType)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Activeness: \(pet.activeness)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 10)
            
            // Description
            Text(pet.description)
                .font(.system(size: 12).italic())
                .foregroundColor(.gray)
                .lineLimit(3)
                .padding(.horizontal, 10)
            
            // Date and Location
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = "MMM d, h:mm a"
//            let startTime = timeFormatter.string(from: pet.startDate)
//            let endTime = timeFormatter.string(from: pet.endDate)
//
            // FIX LATER
            // \(setDate(pet))
            Text("7AM - 7PM at \(pet.location)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
                .lineLimit(1)
                .padding(.horizontal, 10)
            
            // Contact button
            Button(action: {
                // Show contact information
                // For demo, we'll just print to console
                print("Contact: \(pet.emailContact)")
            }) {
                Text("Contact")
                    .font(.system(size: 14))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundColor(.white)
                    .background(Color(red: 202/255, green: 66/255, blue: 56/255))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(primaryRed.opacity(0.3), lineWidth: 1)
        )
    }
}

extension PetSitterView {
    
    static func setDate(pet:Pet) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM d, h:mm a"
        let startTime = timeFormatter.string(from: pet.startDate)
        let endTime = timeFormatter.string(from: pet.endDate)
        
        return "\(startTime) - \(endTime)"
    }
}

// MARK: - Preview
struct PetSitterView_Previews: PreviewProvider {
    static var previews: some View {
        PetSitterView()
    }
}
