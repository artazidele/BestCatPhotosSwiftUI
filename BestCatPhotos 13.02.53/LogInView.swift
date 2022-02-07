//
//  LogInView.swift
//  BestCatPhotos
//
//  Created by arta.zidele on 03/02/2022.
//

import SwiftUI
import FirebaseAuth

struct UnderlineTextFieldView: View {
    @Binding var text: String

     var body: some View {
          VStack {
               ZStack {
                   TextField("", text: $text)
                       .autocapitalization(.none)
               }

               Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
          }
          .padding()
     }
}
struct UnderlineSecureFieldView: View {
    @Binding var text: String

     var body: some View {
          VStack {
               ZStack {
                   SecureField("", text: $text)
                       .autocapitalization(.none)
               }

               Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
          }
          .padding()
     }
}
struct LogInView: View {
    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack {
            ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red, lineWidth: 2)
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.red, lineWidth: 2)
                VStack {
                    VStack(alignment: .leading, spacing: 2) {
                    Text("Email:")
                            .padding()
//
//                        UnderlineTextFieldView(text: $email)
//                                             .padding(.top, 30)
//                    UnderlineTextField("", text: $email)
//                        .autocapitalization(.none)
//                        .padding()
                    UnderlineTextFieldView(text: $email)
                    Text("Password:")
                            .padding()
                    UnderlineSecureFieldView(text: $password)
//                    SecureField("", text: $password)
//                        .autocapitalization(.none)
//                        .padding()
                    }
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                    }, label: {
                        Text("Log In")
                            .padding()
                            .background(Color.red)
                            .tint(Color.white)
                            .cornerRadius(4)
                    })
                }
            }
            .padding(4)
        }
        .frame(width: 280, height: 320, alignment: .center)
        .padding()
            
            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
            }, label: {
                Text("HAVE NOT GOT ACCOUNT?")
                    .tint(Color.red)
            })
                .padding()
            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
            }, label: {
                Text("FORGOT PASSWORD?")
                    .tint(Color.red)
            })
                .padding()
        }
        .onAppear {
            
        }
    }
}
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}


