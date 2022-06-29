//
//  CreateHouse.swift
//  part1
//
//  Created by 賴冠宏 on 2022/6/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct GameData: Codable, Identifiable {
    @DocumentID var id: String?
    var roomNum: String
    var dice: Int
    var player1: String
    var player2: String
    var player3: String
    var player4: String
    var money1: Int
    var money2: Int
    var money3: Int
    var money4: Int
    var nowP: Int
}

struct CreateHouse: View {
    @Binding var roomNumIn: String
    @Binding var emailIn:String
    @State private var name1 = "wait..."
    @State private var money1 = 0
    @State private var name2 = "wait..."
    @State private var money2 = 0
    @State private var name3 = "wait..."
    @State private var money3 = 0
    @State private var name4 = "wait..."
    @State private var money4 = 0
    @State private var nowPlayer = 0
    @State private var gos = false
    @State private var key = 0
    
    
    func create() {
        let db = Firestore.firestore()
        let data = GameData(roomNum:"\(roomNumIn)", dice: 0, player1:"\(name1)", player2:"\(name2)", player3:"\(name3)",  player4: "\(name4)", money1: 2000, money2: 2000, money3: 2000, money4: 2000, nowP:0)
        do {
            print("in create")
            try db.collection("GameData").document("\(roomNumIn)").setData(from: data)
        } catch {
            print(error)
        }
    }
    
    func fetchData(roomNum: String){
        let db = Firestore.firestore()
        db.collection("House").whereField("roomNum", isEqualTo: "\(roomNumIn)").getDocuments { snapshot, error in

            snapshot!.documents.forEach { snapshot in
                name1 = snapshot.data()["player1"] as! String
                money1 = snapshot.data()["money1"] as! Int
                name2 = snapshot.data()["player2"] as! String
                money2 = snapshot.data()["money2"] as! Int
                name3 = snapshot.data()["player3"] as! String
                money3 = snapshot.data()["money3"] as! Int
                name4 = snapshot.data()["player4"] as! String
                money4 = snapshot.data()["money4"] as! Int
                nowPlayer = snapshot.data()["nowP"] as! Int
                //roomNumIn = snapshot.data()["room"] as! String
                gos = snapshot.data()["go"] as! Bool
                
            }
        }
    }
    
    func checkSongChange() {
            let db = Firestore.firestore()
            db.collection("House").whereField("roomNum", isEqualTo: "\(roomNumIn)").addSnapshotListener { snapshot, error in
                snapshot!.documents.forEach { snapshot in
                    name1 = snapshot.data()["player1"] as! String
                    money1 = snapshot.data()["money1"] as! Int
                    name2 = snapshot.data()["player2"] as! String
                    money2 = snapshot.data()["money2"] as! Int
                    name3 = snapshot.data()["player3"] as! String
                    money3 = snapshot.data()["money3"] as! Int
                    name4 = snapshot.data()["player4"] as! String
                    money4 = snapshot.data()["money4"] as! Int
                    nowPlayer = snapshot.data()["nowP"] as! Int
                    //roomNums = snapshot.data()["room"] as! String
                    gos = snapshot.data()["go"] as! Bool
                }
            }
    }
    
    func modifyHouse() {
            let db = Firestore.firestore()
            let documentReference =
                db.collection("House").document("\(roomNumIn)")
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var house = try? document.data(as: House.self)
              else {
                        return
              }
                //print("123")
                house.go = true
              do {
                 try documentReference.setData(from: house)
              } catch {
                 print(error)
              }
                            
            }
    }
    
    func modifySong() {
            let db = Firestore.firestore()
            let documentReference =
                db.collection("RoleDatas").document("\(emailIn)")
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var song = try? document.data(as: RoleData.self)
              else {
                        return
              }
                //print("123")
                song.money -= 2000
              do {
                 try documentReference.setData(from: song)
              } catch {
                 print(error)
              }
                            
            }
    }
    var body: some View {
        VStack{
            Text("房號：\(roomNumIn)")
            Text(" ")
            HStack{
                VStack{
                    Text("玩家 1")
                    Text("\(name1)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(money1)")
                }
                .frame(width:170, height:170)
                .background(Color.white)
                .cornerRadius(10)
                
                VStack{
                    Text("玩家 2")
                    Text("\(name2)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(money2)")
                    
                }
                .frame(width:170, height:170)
                .background(Color.white)
                .cornerRadius(10)
            }
            ZStack{
                Button {
                    //print("follow")
                    
                    if(nowPlayer > 1){
                        print("Let's go")
                        //Game()
                        //gos = true
                        modifyHouse()
                        modifySong()
                        create()
                        key=1
                    }
                    else{
                        print("no enought")
                    }
                } label: {
                    Text("START")
                        .foregroundColor(.white)
                        .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(20)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                .fullScreenCover(isPresented: $gos) {
                    Game(roomNumIn: $roomNumIn, emailIn: $emailIn, playerNum: $key)
                    
                }
            }
            HStack{
                VStack{
                    Text("玩家 3")
                    Text("\(name3)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(money3)")
                }
                .frame(width:170, height:170)
                .background(Color.white)
                .cornerRadius(10)
                
                VStack{
                    Text("玩家 4")
                    Text("\(name4)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(money4)")
                }
                .frame(width:170, height:170)
                .background(Color.white)
                .cornerRadius(10)
            }
            
        }
        .onAppear{
            fetchData(roomNum: "\(roomNumIn)")
            checkSongChange()
            key = nowPlayer
        }
        .navigationTitle("遊戲房")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct CreateHouse_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateHouse()
//    }
//}
