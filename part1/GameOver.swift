//
//  GameOver.swift
//  part1
//
//  Created by 賴冠宏 on 2022/6/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct GameOver: View {
    @Binding var roomNumIn:String
    @Binding var emailIn:String
    @State private var name1 = "wait..."
    @State private var money1 = 0
    @State private var name2 = "wait..."
    @State private var money2 = 0
    @State private var name3 = "wait..."
    @State private var money3 = 0
    @State private var name4 = "wait..."
    @State private var money4 = 0
    @State private var diceSum = 0
    @State private var names = "wait..."
    @State private var nowp = 0
    @State private var gos = false
    
    func fetchData(roomNum: String){
        let db = Firestore.firestore()
        db.collection("GameData").whereField("roomNum", isEqualTo: "\(roomNumIn)").getDocuments { snapshot, error in
            snapshot!.documents.forEach { snapshot in
                name1 = snapshot.data()["player1"] as! String
                money1 = snapshot.data()["money1"] as! Int
                name2 = snapshot.data()["player2"] as! String
                money2 = snapshot.data()["money2"] as! Int
                name3 = snapshot.data()["player3"] as! String
                money3 = snapshot.data()["money3"] as! Int
                name4 = snapshot.data()["player4"] as! String
                money4 = snapshot.data()["money4"] as! Int
                diceSum = snapshot.data()["dice"] as! Int
                nowp = snapshot.data()["nowP"] as! Int
                
            }
        }
    }
    
    var body: some View {
        VStack{
            VStack{
            Text("G A M E    O V E R !")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.red)
                .offset(x:0, y:-150)
            }
            VStack{
                Text("1:\(name1) $\(money1)")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("2:\(name2) $\(money2)")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("3:\(name3) $\(money3)")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("4:\(name4) $\(money4)")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            Button("back"){
                //CreatorJoin(emailIn: $emailIn)
                gos = true
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.gray)
            .cornerRadius(20)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .offset(x:0, y:200)
            .fullScreenCover(isPresented: $gos) {
                Home(emailIn: $emailIn)
                
            }
            
        }
        .onAppear{
            fetchData(roomNum: "\(roomNumIn)")
        }
    }
}

//struct GameOver_Previews: PreviewProvider {
//    static var previews: some View {
//        GameOver()
//    }
//}
