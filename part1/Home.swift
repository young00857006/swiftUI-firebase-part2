//
//  Home.swift
//  part1
//
//  Created by 賴冠宏 on 2022/6/1.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Home: View {
    @Binding var emailIn:String
    @State private var name = ""
    @State private var country = ""
    @State private var birthday = ""
    @State private var sex = ""
    @State private var money = 0
    @State private var image = ""
    @State private var back = false
    @State private var mod = false
    
    
    func fetchData(email: String){
        let db = Firestore.firestore()
        db.collection("RoleDatas").whereField("email", isEqualTo: "\(emailIn)").getDocuments { snapshot, error in

            snapshot!.documents.forEach { snapshot in
                name = snapshot.data()["name"] as! String
                sex = snapshot.data()["sex"] as! String
                country = snapshot.data()["country"] as! String
                birthday = snapshot.data()["birthday"] as! String
                money = snapshot.data()["money"] as! Int
                image = snapshot.data()["image"] as! String
                
            }
        }
    }
    
    var body: some View {
            VStack{
                List{
                    Image("\(image)")
                        .resizable()
                        .frame(width: 300, height: 400)
                        .scaledToFill()
                    Text("玩家: \(name)")
                    Text("性別: \(sex)")
                    Text("國家: \(country)")
                    Text("E-mail: \(emailIn)")
                    Text("錢: \(money)")
                    Text("加入時間 : \(birthday)")
                    NavigationLink("開始遊戲", destination: CreatorJoin(emailIn: $emailIn))
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.blue)
                }
                .onAppear{
                    fetchData(email: "\(emailIn)")
                }
                
                
                Button{
                    do {
                        try Auth.auth().signOut()
                    } catch {
                    }
                    back = true
                    
                }
                label: {
                    Text("登出")
                        .frame(alignment: .topTrailing)
                }
                .fullScreenCover(isPresented: $back) {
                    ContentView()
                }
            }
            
            .navigationTitle("個人資訊")
            .navigationBarTitleDisplayMode(.inline)
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home(emailIn: $email)
//    }
//}
