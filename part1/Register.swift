//
//  Register.swift
//  part1
//
//  Created by 賴冠宏 on 2022/6/1.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Register: View {
    @State private var emailR = ""
    @State private var passwordR = ""
    @State private var modR = false
    @State private var noAlert = false
    func creat(){
        Auth.auth().createUser(withEmail: "\(emailR)", password: "\(passwordR)") { result, error in
            guard let _ = result?.user,
            error == nil else {
                modR = false
                self.noAlert = true
                print(error?.localizedDescription)
                return
             }
             modR = true
             print(emailR, "register")
        }
    }
   var body: some View {
    VStack{
        TextField("帳號(email)", text: $emailR)
            .frame(width: 300, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
        SecureField("密碼", text: $passwordR)
            .frame(width: 300, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
        
        Button("確認"){
            creat()
        }
        .foregroundColor(.white)
        .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding()
        .background(Color.green)
        .cornerRadius(8)
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        .alert(isPresented: $noAlert, content: {
            Alert(title: Text("帳號或密碼錯誤！"), primaryButton: .default(Text("再試一次")), secondaryButton: .default(Text("取消")))
        })
        NavigationLink(
            destination: Setstyle(emailIn: $emailR), isActive:$modR){
            }
        }
    .navigationTitle("註冊")
   }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Register()
        }
    }
}
