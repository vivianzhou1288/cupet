//
//  LoginSignupView.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import SwiftUI

struct LoginSignupView: View {
    // MARK: - Properties
    @State private var email = ""
    @State private var password = ""
    @State private var isNewUser = false
    @State private var showingRoleSelection = false
    
    private let primaryRed = Color(hex: "B31B1B")
    private let fieldBorder = Color(hex: "8ECAE6")
    private let bgColor = Color(hex: "FFFAF5")
    private let accentColor = Color(hex: "FFB766")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                bgColor.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    logoSection
                    Spacer(minLength: 20)
                    credentialsSection
                    Spacer()
                    
                    NavigationLink(
                        destination: RoleSelectionView(),
                        isActive: $showingRoleSelection,
                        label: { EmptyView() }
                    )
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - UI Components
    private var logoSection: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(primaryRed.opacity(0.1))
                    .frame(width: 110, height: 110)
                
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(primaryRed)
            }
            
            Text("CU Pet")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(primaryRed)
            
            Text("We got your paws covered!")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.gray)
        }
        .padding(.top, 20)
    }
    
    private var credentialsSection: some View {
        VStack(spacing: 16) {
            TextField("Cornell Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(fieldBorder, lineWidth: 1)
                )
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(fieldBorder, lineWidth: 1)
                )
            
            //https://stackoverflow.com/questions/72872898/login-screen-swiftui
            //https://stackoverflow.com/questions/75531911/swiftui-firebase-authentication-persist-user-after-network-connectivity-got-los/75542103
            Button(action: {
                if isNewUser {
                    // Call signup
                    NetworkManager.shared.signup(
                        name: "Cornell User",
                        email: email,
                        password: password,
                        role: "owner") { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let user):
                                    UserManager.shared.currentUser = user
                                    self.showingRoleSelection = true
                                case .failure(let error):
                                    print("Signup error: \(error.localizedDescription)")
                                }
                            }
                        }
                } else {
                    NetworkManager.shared.login(
                        email: email,
                        password: password) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let user):
                                    UserManager.shared.currentUser = user
                                    self.showingRoleSelection = true
                                case .failure(let error):
                                    print("Login error: \(error.localizedDescription)")
                                }
                            }
                        }
                }
            })
            {
                HStack {
                    Image(systemName: isNewUser ? "person.badge.plus" : "pawprint.circle")
                        .font(.system(size: 18))
                    Text(isNewUser ? "Create Account" : "Log In")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryRed, primaryRed.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(color: primaryRed.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.top, 10)
            
            Button(action: {
                withAnimation { isNewUser.toggle() }
            }) {
                Text(isNewUser ? "Already have an account? Log In" : "New user? Sign Up")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(accentColor)
            }
            .padding(.top, 5)
        }
        .padding(.horizontal, 25)
    }
}

#Preview {
    LoginSignupView()
}
