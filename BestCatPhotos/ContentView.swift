//
//  ContentView.swift
//  BestCatPhotos
//
//  Created by arta.zidele on 20/01/2022.
//

import SwiftUI
import FirebaseAuth

struct URLImage: View {
    let urlString: String
    @State var data: Data?
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 120)
                .background(Color.brown)
        } else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 120)
                .background(Color.brown)
                .onAppear {
                    fetch()
                }
        }
    }
    
    private func fetch() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}
struct CatPhoto: Hashable, Codable {
    let id: String
    let url: String
}
class PhotoViewModel: ObservableObject {
    @Published var catPhotos: [CatPhoto] = []
    func fetchData() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=20") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let catPhotos = try JSONDecoder().decode([CatPhoto].self, from: data)
                DispatchQueue.main.async {
                    self?.catPhotos = catPhotos
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
}
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
    
    @StateObject var catPhotoViewModel = PhotoViewModel()
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(catPhotoViewModel.catPhotos, id: \.self) { catPhoto in
                    HStack {
                        URLImage(urlString: catPhoto.url)
                        Text(catPhoto.id)
                    }
                }
            }
            
            
//            if viewModel.signedIn{
//                VStack {
//                    Text("You are signed in")
//                    Button(action: {
//                        viewModel.signOut()
//                    }, label: {
//                        Text("Sign Out")
//                    })
//                }
//            } else {
//                SignInView()
//            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
            catPhotoViewModel.fetchData()
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
