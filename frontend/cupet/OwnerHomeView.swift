//
//  OwnerHomeView.swift
//  cupet
//
//  Created by Ashley Huang on 5/1/25.
//

import SwiftUI

struct OwnerHomeView: View {
    // MARK: - Properties
    @State private var showingAddPet = false
    @State private var pets: [Pet] = []
    @State private var isLoading = false
    
    private let primaryRed = Color(hex: "B31B1B")
    private let bgColor = Color(hex: "FFFAF5")
    
    // MARK: - Body
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading...")
                    .foregroundColor(primaryRed)
            } else if pets.isEmpty {
                emptyState
            } else {
                petsList
            }
        }
        .navigationTitle("My Pets")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddPet = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(primaryRed)
                }
            }
        }
        .sheet(isPresented: $showingAddPet) {
            AddPetView(onAddPet: { pet in
                pets.append(pet)
            })
        }
        .onAppear {
            loadPets()
        }
    }
    
    // MARK: - UI Components
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "pawprint.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(primaryRed.opacity(0.7))
            
            Text("No pets posted yet")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.black)
            
            Text("Add a pet using the + button")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(primaryRed)
            
            Button(action: { showingAddPet = true }) {
                Text("Add Pet")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(primaryRed)
                    .cornerRadius(20)
            }
            .padding(.top, 10)
        }
    }
    
    private var petsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(pets) { pet in
                    NavigationLink(destination: PetDetailView(pet: pet, onDelete: deletePet)) {
                        PetCardView(pet: pet)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    // MARK: - Data Methods
    private func loadPets() {
        isLoading = true
        
        if let currentUser = UserManager.shared.currentUser {
            NetworkManager.shared.fetchPets { result in
                DispatchQueue.main.async {
                    isLoading = false
                    
                    switch result {
                    case .success(let allPets):
                        let ownerPets = allPets.filter { $0.ownerId == currentUser.id }
                        self.pets = ownerPets
                        
                    case .failure(let error):
                        print("Error loading pets: \(error.localizedDescription)")
                        self.pets = []
                    }
                }
            }
        } else {
            isLoading = false
            pets = []
        }
    }
    
    private func deletePet(id: Int) {
        NetworkManager.shared.deletePet(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.pets.removeAll { $0.id == id }
                case .failure(let error):
                    print("Error deleting pet: \(error.localizedDescription)")
                    self.pets.removeAll { $0.id == id }
                }
            }
        }
    }
}


struct PetCardView: View {
    // MARK: - Properties
    let pet: Pet
    
    private let primaryRed = Color(hex: "B31B1B")
    private let cardBg = Color.white
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(primaryRed)
                
                Text(pet.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(pet.petType)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(primaryRed.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Divider()
                .background(primaryRed.opacity(0.5))
            
            HStack {
                Label(
                    title: {
                        Text(formatDateRange())
                            .foregroundColor(primaryRed)
                    },
                    icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(primaryRed)
                    }
                )
                .font(.system(size: 14))
                
                Spacer()
                
                Label(
                    title: {
                        Text(getLocationShort())
                            .foregroundColor(primaryRed)
                    },
                    icon: {
                        Image(systemName: "location.fill")
                            .foregroundColor(primaryRed)
                    }
                )
                .font(.system(size: 14))
            }
            
            if !pet.description.isEmpty {
                Text(pet.description)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(cardBg)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(primaryRed.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Helper Methods
    private func formatDateRange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return "\(dateFormatter.string(from: pet.startDate)) - \(dateFormatter.string(from: pet.endDate))"
    }
    
    private func getLocationShort() -> String {
        if let location = DropOffLocation(rawValue: pet.location) {
            return location.shortName
        }
        return pet.location
    }
}
