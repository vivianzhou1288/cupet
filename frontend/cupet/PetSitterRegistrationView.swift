//
//  PetSitterRegistrationView.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import SwiftUI

struct PetSitterRegistrationView: View {
    @State private var preferredPetTypes: [PetType] = []
    @State private var selectedActiveness: [Activeness] = []
    @State private var availableLocations: [DropOffLocation] = []
    @State private var navigateToBrowse = false
    @Environment(\.presentationMode) var presentationMode
    
    let cornellRed = Color(hex: "B31B1B")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                SectionView(title: "What pets are you comfortable with?") {
                    ForEach(PetType.allCases) { petType in
                        CheckboxRow(
                            title: petType.rawValue,
                            isSelected: preferredPetTypes.contains(petType),
                            action: { toggleSelection(petType, in: &preferredPetTypes) }
                        )
                    }
                }
                
                SectionView(title: "What energy levels of the pet do you prefer?") {
                    ForEach(Activeness.allCases) { level in
                        CheckboxRow(
                            title: level.rawValue,
                            isSelected: selectedActiveness.contains(level),
                            action: { toggleSelection(level, in: &selectedActiveness) }
                        )
                    }
                }
                
                SectionView(title: "Where do you prefer to pick-up/drop-off pets?") {
                    ForEach(DropOffLocation.allCases) { location in
                        CheckboxRow(
                            title: location.rawValue,
                            isSelected: availableLocations.contains(location),
                            action: { toggleSelection(location, in: &availableLocations) }
                        )
                    }
                }
                
                Button(action: {
                    navigateToBrowse = true
                }) {
                    Text("Start Browsing Pets")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isFormComplete() ? cornellRed : Color.gray)
                        )
                }
                .disabled(!isFormComplete())
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                NavigationLink(
                    destination: Text("Pet Browse Screen")
                        .navigationTitle("Browse Pets"),
                    isActive: $navigateToBrowse,
                    label: { EmptyView() }
                )
            }
            .padding()
        }
        .background(Color(hex: "FFFAF5"))
        .navigationTitle("Pet Sitter Signup")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(cornellRed)
                }
            }
        }
    }
    
    private func toggleSelection<T: Identifiable & Equatable>(_ item: T, in array: inout [T]) {
        if let index = array.firstIndex(of: item) {
            array.remove(at: index)
        } else {
            array.append(item)
        }
    }
    
    private func isFormComplete() -> Bool {
        return !preferredPetTypes.isEmpty && !availableLocations.isEmpty && !selectedActiveness.isEmpty
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(hex: "B31B1B"))
            
            content
        }
    }
}

struct CheckboxRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? Color(hex: "B31B1B") : .gray)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
