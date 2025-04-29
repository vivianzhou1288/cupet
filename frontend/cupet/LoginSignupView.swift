//
//  LoginSignupView.swift
//  cupet
//
//  Created by Ashley Huang on 4/28/25.
//

import SwiftUI

struct LoginSignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isNewUser = false
    @State private var showingRoleSelection = false
    
    let cornellRed = Color(hex: "B31B1B")
    let skyBlue = Color(hex: "8ECAE6")
    let leafGreen = Color(hex: "95D5B2")
    let pawOrange = Color(hex: "FFB766")
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FFFAF5")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(cornellRed.opacity(0.1))
                                .frame(width: 110, height: 110)
                            
                            Image(systemName: "pawprint.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(cornellRed)
                        }
                        
                        Text("CU Pet")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(cornellRed)
                        
                        Text("We got your paws covered!")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 20)
                    
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
                                    .stroke(skyBlue, lineWidth: 1)
                            )
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(skyBlue, lineWidth: 1)
                            )
                        
                        Button(action: {
                            showingRoleSelection = true
                        }) {
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
                                    gradient: Gradient(colors: [cornellRed, cornellRed.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: cornellRed.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.top, 10)
                        
                        Button(action: {
                            withAnimation {
                                isNewUser.toggle()
                            }
                        }) {
                            Text(isNewUser ? "Already have an account? Log In" : "New user? Sign Up")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(pawOrange)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.horizontal, 25)
                    
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
    
    private func campusIcon(symbol: String, color: Color) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
            
            Image(systemName: symbol)
                .font(.system(size: 22))
                .foregroundColor(color)
        }
    }
}

#Preview {
    LoginSignupView()
}
