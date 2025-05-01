//
//  RoleSelectionView.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import SwiftUI

struct RoleSelectionView: View {
    // MARK: - Properties
    @State private var selectedRole: UserRole?
    @State private var navigateNext = false
    @Environment(\.presentationMode) var presentationMode
    
    private let primaryRed = Color(hex: "B31B1B")
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(hex: "FFFAF5").ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("I am a...")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(primaryRed)
                    .padding(.top, 70)
                
                Spacer()
                
                roleButtons
                
                Spacer()
                
                NavigationLink(
                    destination: getDestinationView(),
                    isActive: $navigateNext,
                    label: { EmptyView() }
                )
            }
            .padding(.horizontal, 25)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(primaryRed)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - UI Components
    private var roleButtons: some View {
        VStack(spacing: 25) {
            Button(action: {
                selectedRole = .owner
                navigateNext = true
            }) {
                RoleCardView(
                    title: "Pet Owner",
                    description: "Find a reliable sitter for your pet",
                    iconName: "pawprint.fill",
                    isSelected: selectedRole == .owner
                )
            }
            
            Button(action: {
                selectedRole = .sitter
                navigateNext = true
            }) {
                RoleCardView(
                    title: "Pet Sitter",
                    description: "Connect with pets needing care",
                    iconName: "person.fill",
                    isSelected: selectedRole == .sitter
                )
            }
        }
    }
    
    // MARK: - Navigation
    @ViewBuilder
    private func getDestinationView() -> some View {
        if selectedRole == .owner {
            OwnerHomeView()
        } else {
            PetSitterRegistrationView()
        }
    }
}

// MARK: - RoleCardView
struct RoleCardView: View {
    // MARK: - Properties
    let title: String
    let description: String
    let iconName: String
    let isSelected: Bool
    
    private let primaryRed = Color(hex: "B31B1B")
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : primaryRed)
                .frame(width: 50)
                .padding(.leading, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(description)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
            }
            .padding(.vertical, 15)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(isSelected ? .white.opacity(0.7) : .gray)
                .padding(.trailing, 15)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? primaryRed : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(primaryRed, lineWidth: isSelected ? 0 : 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    RoleSelectionView()
}
