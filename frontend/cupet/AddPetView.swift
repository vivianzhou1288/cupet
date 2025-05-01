//
//  AddPetView.swift
//  cupet
//
//  Created by Ashley Huang on 5/1/25.
//

import SwiftUI

struct AddPetView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    var onAddPet: (Pet) -> Void
    
    @State private var petName = ""
    @State private var selectedType = PetType.dog
    @State private var selectedActiveness = Activeness.medium
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400)
    @State private var selectedLocation = DropOffLocation.north
    @State private var email = ""
    
    private let primaryRed = Color(hex: "B31B1B")
    private let bgColor = Color(hex: "FFFAF5")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                bgColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        petBasicInfoSection
                        petDatesSection
                        petLocationSection
                        petDescriptionSection
                        petContactSection
                        
                        submitButton
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(primaryRed)
                }
            }
        }
    }
    
    // MARK: - UI Components
    private var petBasicInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What is your pet's name?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
            
            TextField("Pet Name", text: $petName)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(primaryRed.opacity(0.3), lineWidth: 1)
                )
            
            Text("What type of pet do you have?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
                .padding(.top, 12)
            
            VStack(spacing: 8) {
                ForEach(PetType.allCases) { type in
                    Button(action: { selectedType = type }) {
                        HStack {
                            Image(systemName: selectedType == type ? "circle.fill" : "circle")
                                .foregroundColor(primaryRed)
                            
                            Text(type.rawValue)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(selectedType == type ? primaryRed.opacity(0.1) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 5)
            
            Text("How active is your pet?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
                .padding(.top, 12)
            
            VStack(spacing: 8) {
                ForEach(Activeness.allCases) { level in
                    Button(action: { selectedActiveness = level }) {
                        HStack {
                            Image(systemName: selectedActiveness == level ? "circle.fill" : "circle")
                                .foregroundColor(primaryRed)
                            
                            Text(level.description)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(selectedActiveness == level ? primaryRed.opacity(0.1) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(primaryRed.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var petDatesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("When do you need pet sitting services?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.vertical, 5)
            
            DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(primaryRed.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var petLocationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Where would you like to drop-off/pick-up your pet?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
            
            VStack(spacing: 8) {
                ForEach(DropOffLocation.allCases) { location in
                    Button(action: { selectedLocation = location }) {
                        HStack {
                            Image(systemName: selectedLocation == location ? "circle.fill" : "circle")
                                .foregroundColor(primaryRed)
                            
                            Text(location.rawValue)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(selectedLocation == location ? primaryRed.opacity(0.1) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(primaryRed.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var petDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Please describe your pet and any special care instructions:")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
            
            TextEditor(text: $description)
                .frame(height: 100)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(primaryRed.opacity(0.3), lineWidth: 1)
                )
                .background(Color.white)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(primaryRed.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var petContactSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What is your Cornell email for interested sitters to contact you?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(primaryRed)
            
            TextField("Cornell Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(primaryRed.opacity(0.3), lineWidth: 1)
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(primaryRed.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var submitButton: some View {
        Button(action: submitPet) {
            Text("Submit")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryRed)
                .cornerRadius(15)
                .shadow(color: primaryRed.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Actions
    private func submitPet() {
        let newPet = Pet(
            id: Int.random(in: 1...10000),
            ownerId: 1,
            name: petName.isEmpty ? "Unnamed Pet" : petName,
            petType: selectedType.rawValue,
            activeness: selectedActiveness.rawValue,
            description: description.isEmpty ? "No description provided" : description,
            startDate: startDate,
            endDate: endDate,
            location: selectedLocation.rawValue,
            emailContact: email.isEmpty ? "example@cornell.edu" : email
        )
        
        onAddPet(newPet)
        presentationMode.wrappedValue.dismiss()
    }
}
