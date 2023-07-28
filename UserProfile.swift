//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Dakota Shively on 7/17/23.
//

import SwiftUI




struct UserProfile: View {
    var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @Environment(\.presentationMode) var presentation
    @State private var isLoggedIn = false
    
    var body: some View {
        VStack {
            Text("Personal Information")
                .font(.title)
                .padding()
            Image("profile-image-placeholder")
            Text(firstName)
            Text(lastName)
            Text(email)

            Button(action: {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            })
            {
                Text("Logout")
                    
            }
            .padding()
            .foregroundColor(.red)
            Spacer()
        }
}
                   }

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
