//
//  PetDetailView.swift
//  cupet
//
//  Created by Ashley Huang on 5/1/25.
//

import SwiftUI

struct PetDetailView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    var pet: Pet
    var onDelete: (Int) -> Void
    
    @State private var showingDeleteAlert = false
    @State private var showingFoundSitterAlert = false
    
    private let primaryRed = Color(hex: "B31B1B")
    private let bgColor = Color(hex: "FFFAF5")
    private let iconGreen = Color(hex: "4CAF50")
    
    // MARK: - Body
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    petHeader
                    petDetails
                    actionButtons
                }
                .padding()
            }
        }
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(primaryRed)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        //https://developer.apple.com/documentation/swiftui/alert
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Pet Listing"),
                message: Text("Are you sure you want to delete this pet listing?"),
                primaryButton: .destructive(Text("Delete")) {
                    onDelete(pet.id)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
                }
        .alert("I Found a Sitter", isPresented: $showingFoundSitterAlert) {
            Button("Yes, Remove Listing", role: .destructive) {
                onDelete(pet.id)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Great! This will remove your pet from the listings. Is this correct?")
        }
        }
    
    // MARK: - UI Components
    private var petHeader: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(primaryRed.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(primaryRed)
            }
            
            Text(pet.name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .padding(.top, 10)
            
            Text(pet.petType)
                .font(.system(size: 18, design: .rounded))
                .foregroundColor(primaryRed)
        }
        .padding(.vertical)
}
    
    private var petDetails: some View {
        VStack(spacing: 20) {
            infoCard(title: "Care Period", icon: "calendar") {
                let formatter = DateFormatter()
                
                Text("\(formatter.string(from: pet.startDate)) - \(formatter.string(from: pet.endDate))")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.black)
            }
            
            infoCard(title: "Location", icon: "location.fill") {
                Text(pet.location)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.black)
        }
            
            infoCard(title: "Activity Level", icon: "figure.walk") {
                Text(pet.activeness)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.black)
            }
            
            infoCard(title: "Description", icon: "text.alignleft") {
                Text(pet.description)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
            
            infoCard(title: "Contact", icon: "envelope.fill") {
                Text(pet.emailContact)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.black)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            Button(action: {
                showingFoundSitterAlert = true
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("I Found a Sitter")
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(iconGreen)
                .cornerRadius(15)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Listing")
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryRed)
                .cornerRadius(15)
            }
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Helper Components
    private func infoCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(primaryRed)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(primaryRed)
            }
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(primaryRed, lineWidth: 1)
        )
    }
}
