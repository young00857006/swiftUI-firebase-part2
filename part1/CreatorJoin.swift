//
//  CreatorJoin.swift
//  part1
//
//  Created by 賴冠宏 on 2022/6/18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct House: Codable, Identifiable {
    @DocumentID var id: String?
    var roomNum: String
    let player1: String
    let money1: Int
    var player2: String
    var money2: Int
    var player3: String
    var money3: Int
    var player4: String
    var money4: Int
    var nowP: Int
    var go: Bool
}

struct CreatorJoin: View {
    @Binding var emailIn:String
    @State private var names = ""
    @State private var countrys = ""
    @State private var birthdays = ""
    @State private var sexs = ""
    @State private var moneys = 0
    @State private var images = ""
    @State private var back = false
        
    @State private var roomNums = ""
    @State private var name1 = "wait..."
    @State private var money1 = 0
    @State private var name2 = "wait..."
    @State private var money2 = 0
    @State private var name3 = "wait..."
    @State private var money3 = 0
    @State private var name4 = "wait..."
    @State private var money4 = 0
    @State private var nowPs = 0
    @State private var gos = false
    
    @State private var mod = false
    @State private var mod2 = false
    @State private var roomJoin = ""
    func create() {
        let db = Firestore.firestore()
        let data = House(roomNum:"\(roomNums)", player1:"\(names)", money1: moneys, player2:"\(name2)", money2: 0, player3:"\(name3)", money3: 0, player4: "\(name4)", money4: 0, nowP: 1, go: false)
        do {
            //try //db.collection("RoleDatas").document("\(emailIn)").setData(from: data)
            let documentReference = try db.collection("House").addDocument(from: data)
                roomNums = documentReference.documentID
                print(documentReference.documentID)
        } catch {
            print(error)
        }
    }
    
    func modifyHouse() {
            let db = Firestore.firestore()
            let documentReference =
                db.collection("House").document("\(roomNums)")
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var house = try? document.data(as: House.self)
              else {
                        return
              }
                //print("123")
                house.roomNum = roomNums
              do {
                 try documentReference.setData(from: house)
              } catch {
                 print(error)
              }
                            
            }
    }
    
    func modifyJoin() {
            let db = Firestore.firestore()
            let documentReference =
                db.collection("House").document("\(roomJoin)")
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var house = try? document.data(as: House.self)
              else {
                        return
              }
                //print("123")
                //nowPs += 1
                house.nowP += 1
                if(house.nowP==2){
                    house.player2 = "\(names)"
                    house.money2 = moneys
                    mod2 = true
                }
                else if(house.nowP==3){
                    house.player3 = "\(names)"
                    house.money3 = moneys
                    mod2 = true
                }
                else if(house.nowP==4){
                    house.player4 = "\(names)"
                    house.money4 = moneys
                    mod2 = true
                }
                else{
                    print("\(nowPs)")
                }
                
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
                song.money += 500
              do {
                 try documentReference.setData(from: song)
              } catch {
                 print(error)
              }
                            
            }
    }
    
    func checkSongChange() {
            let db = Firestore.firestore()
            db.collection("RoleDatas").whereField("email", isEqualTo: "\(emailIn)").addSnapshotListener { snapshot, error in
                snapshot!.documents.forEach { snapshot in
//                    name = snapshot.data()["name"] as! String
//                    sex = snapshot.data()["sex"] as! String
//                    country = snapshot.data()["country"] as! String
//                    birthday = snapshot.data()["birthday"] as! String
                    moneys = snapshot.data()["money"] as! Int
                    //image = snapshot.data()["image"] as! String
                    
                }
            }
    }
    
    func fetchData(email: String){
        let db = Firestore.firestore()
        db.collection("RoleDatas").whereField("email", isEqualTo: "\(emailIn)").getDocuments { snapshot, error in

            snapshot!.documents.forEach { snapshot in
                names = snapshot.data()["name"] as! String
                sexs = snapshot.data()["sex"] as! String
                countrys = snapshot.data()["country"] as! String
                birthdays = snapshot.data()["birthday"] as! String
                moneys = snapshot.data()["money"] as! Int
                images = snapshot.data()["image"] as! String
                
            }
        }
    }
    var body: some View {
            VStack{
                ZStack{
                    //Text("錢: \(money)")
                    
                    Button("創立房間"){
                        create()
                        modifyHouse()
                        mod = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .offset(x:0, y:-85)
                    NavigationLink(
                        destination: CreateHouse(roomNumIn: $roomNums,emailIn: $emailIn), isActive:$mod){
                    }
                    
                    TextField("請輸入房號:", text: $roomJoin)
                        .frame(width: 200, height: 17, alignment: .center)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                        .offset(x:0, y:-20)
                    
                    Button("加入房間"){
                        //signIn()
                        print("\(roomJoin)")
                        modifyJoin()
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .offset(x:0, y:15)
                    NavigationLink(
                        destination: CreateHouse(roomNumIn: $roomJoin,emailIn: $emailIn), isActive:$mod2){
                    }
                    
//                    Button("看廣告賺錢！"){
//                        modifySong()
//                        checkSongChange()
//                    }
//                    .foregroundColor(.white)
//                    .frame(width: 200, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .padding()
//                    .background(Color.orange)
//                    .cornerRadius(8)
//                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                    .offset(x:0, y:80)
                }
                
                .onAppear{
                    fetchData(email: "\(emailIn)")
                }
                
            }
            .navigationTitle("個人頁面")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                       
                    } label: {
                        Text("")
                    }
                }
                ToolbarItem{
                    Text("$:\(moneys)")
                    .foregroundColor(.green)
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    Spacer()
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                                        
                    } label: {
                        Image(systemName: "crown")
                    }
                }
            }
    }
}

//struct CreatorJoin_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorJoin()
//    }
//}
