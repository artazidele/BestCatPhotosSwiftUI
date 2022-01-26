//
//  ContentView.swift
//  BestCatPhotos
//
//  Created by arta.zidele on 20/01/2022.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    let auth = Auth.auth()
    @Published var signedIn = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
}

struct ContentView: View {
//    @State var email = ""
//    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn{
                VStack {
                    Text("You are signed in")
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                    })
                }
            } else {
                SignInView()
            }
            
//            VStack {
//                TextField("Email: ", text: $email)
//                SecureField("Password", text: $password)
//                Button(action: {
//                    guard !email.isEmpty, !password.isEmpty else {
//                        return
//                    }
//                    viewModel.logIn(email: email, password: password)
//                }, label: {
//                    Text("Log In")
//                })
//            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            TextField("Email: ", text: $email)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                viewModel.logIn(email: email, password: password)
            }, label: {
                Text("Log In")
            })
            NavigationLink("Have not got account?", destination: SignUpView())
        }
    }
}

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            TextField("Email: ", text: $email)
            SecureField("Password", text: $password)
            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                viewModel.signUp(email: email, password: password)
            }, label: {
                Text("Sign Up")
            })
        }
    }
}
