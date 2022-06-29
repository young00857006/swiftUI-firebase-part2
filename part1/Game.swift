
import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Game: View {
    @Binding var roomNumIn: String
    @Binding var emailIn:String
    @Binding var playerNum:Int
    struct mapData{
        var color = Color.clear
    }
        
    @State var map:[[mapData]] = Array(repeating: Array(repeating: mapData(), count: 5), count: 5)
    @State var nowplayer = 0
    
    @State var p1Site:[Int] = [135, 135, 0, 0]
    @State var p2Site:[Int] = [165, 135, 0, 0]
    @State var p3Site:[Int] = [135, 165, 0, 0]
    @State var p4Site:[Int] = [165, 165, 0, 0]
    @State var house: [[Int]] = [[9, 0, 0, 0, 7], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [6, 0, 0, 0, 5]] //a b 1~4
    @State private var dice1 = 6
    @State private var dice2 = 4
    
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
    func fetchNameData(email: String){
        let db = Firestore.firestore()
        db.collection("RoleDatas").whereField("email", isEqualTo: "\(emailIn)").getDocuments { snapshot, error in

            snapshot!.documents.forEach { snapshot in
                names = snapshot.data()["name"] as! String
                print("fetch", names)
                
            }
        }
    }
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
    
    func checkGameDataChange() {
            let db = Firestore.firestore()
            db.collection("GameData").whereField("roomNum", isEqualTo: "\(roomNumIn)").addSnapshotListener { snapshot, error in
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
    
    func modifyGameData() {
            let db = Firestore.firestore()
            let documentReference =
                db.collection("GameData").document("\(roomNumIn)")
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var gameData = try? document.data(as: GameData.self)
              else {
                        return
              }
                //print("123")
                gameData.dice = diceSum
                gameData.nowP = nowplayer
              do {
                 try documentReference.setData(from: gameData)
              } catch {
                 print(error)
              }
                            
            }
    }
    
    func modifyGameDataMoney() {
            let db = Firestore.firestore()
            let documentReference =
                db.collection("GameData").document("\(roomNumIn)")
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var gameData = try? document.data(as: GameData.self)
              else {
                        return
              }
                //print("123")
                gameData.money1 = m1
                gameData.money2 = m2
                gameData.money3 = m3
                gameData.money4 = m4
              do {
                 try documentReference.setData(from: gameData)
              } catch {
                 print(error)
              }
                            
            }
    }
    func SiteColor(i:Int, j:Int, color:Color)->Color{
        if(color == Color.clear){
            //中間清空
            if(i != 0 && i != 4 && j != 0 && j != 4){
                return Color.clear
            }
            //４個角
            if(i == 0 && j == 0) || (i == 0 && j == 4) || (i == 4 && j == 0) || (i == 4 && j == 4){
                return color
            }
            else{
                return Color.gray
            }
        }
        else{
            return color
        }
    }
        
    func work(step:Int, nowP:Int){
        //print("in")
        var stepp = step
        if(nowP == 0){
            //print("in if")
            //for _ in stride(from:0, to: step, by:1){
            if(step>0){
            //print("???")
                //print("\(p1Site[0]):\(p1Site[1]):\(p1Site[2]):\(p1Site[3])")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if p1Site[3] == 0 && p1Site[2] != 4{
                        p1Site[2] += 1
                        stepp-=1
                        //work(step:step, nowP:nowP)
                    }
                    else if p1Site[2] == 4 && p1Site[3] != 4{
                        p1Site[3] += 1
                        stepp-=1
                        //work(step:step, nowP:nowP)
                    }
                    else if p1Site[3] == 4 && p1Site[2] != 0{
                        p1Site[2] -= 1
                        stepp-=1
                        //work(step:step, nowP:nowP)
                    }
                    else if p1Site[2] == 0 && p1Site[3] != 0{
                        p1Site[3] -= 1
                        stepp-=1
                        //work(step:step, nowP:nowP)
                    }
                    work(step:stepp, nowP:nowP)
                }
                
            }
            //buyorPay(a: p1Site[2], b: p1Site[3], nowplayer: 1)
            a_site = p1Site[2]
            b_site = p1Site[3]
            
        }
        else if(nowP == 1){
            if(step>0){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if p2Site[3] == 0 && p2Site[2] != 4{
                        p2Site[2] += 1
                        stepp-=1
                    }
                    else if p2Site[2] == 4 && p2Site[3] != 4{
                        p2Site[3] += 1
                        stepp-=1
                    }
                    else if p2Site[3] == 4 && p2Site[2] != 0{
                        p2Site[2] -= 1
                        stepp-=1
                    }
                    else if p2Site[2] == 0 && p2Site[3] != 0{
                        p2Site[3] -= 1
                        stepp-=1
                    }
                    work(step:stepp, nowP:nowP)
                }
            }
            //buyorPay(a: p2Site[2], b: p2Site[3], nowplayer: 2)
            a_site = p2Site[2]
            b_site = p2Site[3]
        }
        else if nowP == 2{
            if(step>0){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if p3Site[3] == 0 && p3Site[2] != 4{
                        p3Site[2] += 1
                        stepp-=1
                    }
                    else if p3Site[2] == 4 && p3Site[3] != 4{
                        p3Site[3] += 1
                        stepp-=1
                    }
                    else if p3Site[3] == 4 && p3Site[2] != 0{
                        p3Site[2] -= 1
                        stepp-=1
                    }
                    else if p3Site[2] == 0 && p3Site[3] != 0{
                        p3Site[3] -= 1
                        stepp-=1
                    }
                    work(step:stepp, nowP:nowP)
                }
            }
            //buyorPay(a: p3Site[2], b: p3Site[3], nowplayer: 3)
            a_site = p3Site[2]
            b_site = p3Site[3]
        }
        else{
            if(step>0){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if p4Site[3] == 0 && p4Site[2] != 4{
                        p4Site[2] += 1
                        stepp-=1
                    }
                    else if p4Site[2] == 4 && p4Site[3] != 4{
                        p4Site[3] += 1
                        stepp-=1
                    }
                    else if p4Site[3] == 4 && p4Site[2] != 0{
                        p4Site[2] -= 1
                        stepp-=1
                    }
                    else if p4Site[2] == 0 && p4Site[3] != 0{
                        p4Site[3] -= 1
                        stepp-=1
                    }
                    work(step:stepp, nowP:nowP)
                }
            }
            //buyorPay(a: p4Site[2], b: p4Site[3], nowplayer: 4)
            a_site = p4Site[2]
            b_site = p4Site[3]
        }
        
        if(step==0){
            buyorPay(a: a_site, b: b_site, nowplayer: nowplayer)
            //print("wp1:\(p1Site[2]):\(p1Site[3])")
            //print("wp2:",p2Site[2],p2Site[3])
            //print("wp3:",p3Site[2],p3Site[3])
            //print("wp4:",p4Site[2],p4Site[3])
        }
    }
    
    func corner(i: Int, j: Int, nowplayer: Int)->String{
        if(i == 0 && j == 0){
            return "ladybug.fill"
        }
        else if(i == 0 && j == 4){
            return "questionmark.square"
        }
        else if(i == 4 && j == 0){
            return "exclamationmark.square"
        }
        else if(i == 4 && j == 4){
            return "leaf"
        }
        else{
            return ""
        }
    }
    
    func cornerC(i: Int, j: Int, nowplayer: Int)->Color{
        if(i == 0 && j == 0){
            return Color.black
        }
        else if(i == 0 && j == 4){
            return Color.red
        }
        else if(i == 4 && j == 0){
            return Color.yellow
        }
        else if(i == 4 && j == 4){
            return Color.purple
        }
        else{
            return Color.clear
        }
    }
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    
    @State var canseeDice = false
    @State var cansee = false
    @State var cansee2 = false
    @State private var a_site = 4
    @State private var b_site = 4
    @State private var aa_site = 4
    @State private var bb_site = 4
    @State private var n = 0
    @State private var whoin = 0
    @State private var m1 = 2000
    @State private var m2 = 2000
    @State private var m3 = 2000
    @State private var m4 = 2000
    func buyorPay(a: Int, b: Int, nowplayer: Int){
        //print(nowplayer)
        if(house[a][b]==0){
            //money -= 500
            cansee = true
        }
        else if(a==4 && b==4){
            showAlert1 = true
            kidnap(nowplayer: nowplayer)
        }
        else if((a==0 && b==4) || (a==4 && b==0)){
            cansee2 = true
        }
        else if(a==0 && b==0){
            //showAlert1 = true
        }
        else{
            showAlert1 = false
            cansee2 = false
            cansee = false
            if(house[a][b]==1){
                if(nowplayer==1){
                }
                else{
                    if(nowplayer==2){
                        m2-=500
                    }
                    else if(nowplayer==3){
                        m3-=500
                    }
                    else{
                        m4-=500
                    }
                }
            }
            else if(house[a][b]==2){
                if(nowplayer==2){
                }
                else{
                    if(nowplayer==1){
                        m1-=500
                    }
                    else if(nowplayer==3){
                        m3-=500
                    }
                    else{
                        m4-=500
                    }
                }
            }
            else if(house[a][b]==3){
                if(nowplayer==3){
                }
                else{
                    if(nowplayer==1){
                        m1-=500
                    }
                    else if(nowplayer==2){
                        m2-=500
                    }
                    else{
                        m4-=500
                    }
                }
            }
            else{
                if(nowplayer==0){
                }
                else{
                    if(nowplayer==1){
                        m1-=500
                    }
                    else if(nowplayer==2){
                        m2-=500
                    }
                    else{
                        m3-=500
                    }
                }
            }
        }
        gameover(money:m1)
        gameover(money:m2)
        gameover(money:m3)
        gameover(money:m4)
    }
    
    func buy(a: Int, b: Int, nowplayer: Int){
        if(nowplayer==0 && m1>=1000){
            //print(nowplayer+1,"buy",a,b)
            house[a][b] = 1
            //print(house[a][b])
            m1 -= 1000
        }
        else if(nowplayer==1 && m2>=1000){
            //print(nowplayer+1,"buy",a,b)
            house[a][b] = nowplayer+1
            //print(house[a][b])
            m2 -= 1000
        }
        else if(nowplayer==2 && m3>=1000){
            //print(nowplayer+1,"buy",a,b)
            house[a][b] = nowplayer+1
            //print(house[a][b])
            m3 -= 1000
        }
        else if(nowplayer==3 && m4>=1000){
            //print(nowplayer+1,"buy",a,b)
            house[a][b] = nowplayer+1
            //print(house[a][b])
            m4 -= 1000
        }
        else{
            cansee = false
        }
        
    }
    
    func cf(nowplayer: Int){
        let x = Int.random(in: 1...4)
        if(x==1){
            if(nowplayer==1){
                m1-=500
            }
            else if(nowplayer==2){
                m2-=500
            }
            else if(nowplayer==3){
                m3-=500
            }
            else{
                m4-=500
            }
        }
        else if(x==2){
            if(nowplayer==1){
                m1-=2000
            }
            else if(nowplayer==2){
                m2-=2000
            }
            else if(nowplayer==3){
                m3-=2000
            }
            else{
                m4-=2000
            }
        }
        else if(x==3){
            if(nowplayer==1){
                m1+=1000
            }
            else if(nowplayer==2){
                m2+=1000
            }
            else if(nowplayer==3){
                m3+=1000
            }
            else{
                m4+=1000
            }
        }
        else{
            if(nowplayer==1){
                m1+=1500
            }
            else if(nowplayer==2){
                m2+=1500
            }
            else if(nowplayer==3){
                m3+=1500
            }
            else{
                m4+=1500
            }
        }
        gameover(money:m1)
        gameover(money:m2)
        gameover(money:m3)
        gameover(money:m4)
    }
    
    func gameover(money:Int){
        if(money<0){
            if(nowplayer==1){
                print(nowplayer, "lose")
            }
            else if(nowplayer==2){
                //m2+=1500
                print(nowplayer, "lose")
            }
            else if(nowplayer==3){
                //m3+=1500
                print(nowplayer, "lose")
            }
            else{
                //m4+=1500
                print(nowplayer, "lose")
            }
            gos = true
        }
    }
    func kidnap(nowplayer: Int){
        if(nowplayer==1){
            m1-=1000
        }
        else if(nowplayer==2){
            m2-=1000
        }
        else if(nowplayer==3){
            m3-=1000
        }
        else{
            m4-=1000
        }
    }
    
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    Text("玩家 1")
                    Text("\(name1)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(m1)")
                }
                .frame(width:170, height:90)
                .background(Color.)
                .cornerRadius(10)
                .offset(x: -10, y: -260)
                VStack{
                    Text("玩家 2")
                    Text("\(name2)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(m2)")
                    
                }
                .frame(width:170, height:90)
                .background(Color.blue)
                .cornerRadius(10)
                .offset(x: 10, y: -260)
            }
            HStack{
                VStack{
                    Text("玩家 3")
                    Text("\(name3)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(m3)")
                }
                .frame(width:170, height:90)
                .background(Color.green)
                .cornerRadius(10)
                .offset(x: -10, y: 260)
                VStack{
                    Text("玩家 4")
                    Text("\(name4)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text("money:\(m4)")
                    
                }
                .frame(width:170, height:90)
                .background(Color.yellow)
                .cornerRadius(10)
                .offset(x: 10, y: 260)
            }
            VStack(alignment: .center, spacing: 5.0) {
                ForEach(0..<5) { i in
                    HStack(spacing: 5.0) {
                        ForEach(0..<5) { j in
                            Rectangle()
                                .frame(width: 70, height: 70)
                                .foregroundColor(SiteColor(i: i, j: j, color: map[i][j].color))
                                .overlay(
                                    Image(systemName: corner(i: i, j: j, nowplayer: nowplayer))
                                        .resizable()
                                        .foregroundColor(cornerC(i: i, j: j, nowplayer: nowplayer))
                                )
                        }
                    }
                }
            }
            Image(systemName: "ladybug.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
                .offset(x:CGFloat(Float(p1Site[0]-p1Site[2]*75)), y:CGFloat(Float(p1Site[1]-p1Site[3]*75)))
                .animation(.default)
            Image(systemName: "ladybug.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .offset(x:CGFloat(p2Site[0]-p2Site[2]*75), y:CGFloat(p2Site[1]-p2Site[3]*75))
                .animation(.default)
            Image(systemName: "ladybug.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
                .offset(x:CGFloat(p3Site[0]-p3Site[2]*75), y:CGFloat(p3Site[1]-p3Site[3]*75))
                .animation(.default)
            Image(systemName: "ladybug.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.yellow)
                .offset(x:CGFloat(p4Site[0]-p4Site[2]*75), y:CGFloat(p4Site[1]-p4Site[3]*75))
                .animation(.default)
            ZStack{
                if(cansee){
                Button("買"){
                    buy(a: a_site, b: b_site, nowplayer: n)
                    cansee = false
                    modifyGameDataMoney()
                    checkGameDataChange()
                }
                .foregroundColor(.white)
                .frame(width: 30, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .offset(x:0, y:-70)
                }
                HStack{
                    Image("\(dice1)")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Image("\(dice2)")
                        .resizable()
                        .frame(width: 70, height: 70)
                    }
                //-----------
                //if(canseeDice){
                    Button("擲骰子"){
                        //checkGameDataChange()
                        cansee = false
                        showAlert1 = false
                        cansee2 = false
                        dice1 = Int.random(in: 1...6)
                        dice2 = Int.random(in: 1...6)
                        //print("\(dice1):\(dice2)")
                        diceSum = dice1+dice2
                        work(step: dice1+dice2, nowP: nowplayer)
                        n = nowplayer
                        
                        
                        
                        //print("np:\(n)")
                        if(dice1==dice2){
                            //same again
                        }
                        else{
                            if(nowplayer != 3 ){
                                nowplayer += 1
                            }
                            else{
                                nowplayer = 0
                            }
                        modifyGameDataMoney()
                        checkGameDataChange()
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 90, height: 20, alignment: .center)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .font(.title)
                    .offset(x:0, y:70)
                    .alert(isPresented: $showAlert1) { // close
                        Alert(
                            title: Text("被壞瓢蟲綁架了！"),
                            message: Text("繳交１０００元贖金")
                        )
                    }
                    .fullScreenCover(isPresented: $gos) {
                        GameOver(roomNumIn: $roomNumIn, emailIn: $emailIn)
                        
                    }
                //}
                //-----------------
                if(cansee2){
                Button("機會/命運"){
                    //print(nowplayer)
                    cf(nowplayer: nowplayer)
                    cansee2 = false
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color.purple)
                .cornerRadius(20)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .offset(x:0, y:350)
                }
            }
            ZStack{
                if(house[1][0] != 0){
                    Image("l1")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:75, y:150)
                        .opacity(0.3)
                }
                if(house[2][0] != 0){
                    Image("l1")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:0, y:150)
                        .opacity(0.3)
                }
                if(house[3][0] != 0){
                    Image("l1")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:-75, y:150)
                        .opacity(0.3)
                }
                if(house[4][1] != 0){
                    Image("l2")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:-150, y:75)
                        .opacity(0.3)
                
                }
                if(house[4][2] != 0){
                    Image("l2")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:-150, y:0)
                        .opacity(0.3)
                }
                if(house[4][3] != 0){
                    Image("l2")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:-150, y:-75)
                        .opacity(0.3)
                }
                //
            }
            ZStack{
                if(house[1][4] != 0){
                    Image("l3")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:75, y:-150)
                        .opacity(0.3)
                }
                if(house[2][4] != 0){
                    Image("l3")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:0, y:-150)
                        .opacity(0.3)
                }
                if(house[3][4] != 0){
                    Image("l3")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:-75, y:-150)
                        .opacity(0.3)
                }
                if(house[0][1] != 0){
                    Image("l4")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:150, y:75)
                        .opacity(0.3)
                }
                if(house[0][2] != 0){
                    Image("l4")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:150, y:0)
                        .opacity(0.3)
                }
                if(house[0][3] != 0){
                    Image("l4")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x:150, y:-75)
                        .opacity(0.3)
                }
            }
        }
        .onAppear{
            fetchData(roomNum: "\(roomNumIn)")
            fetchNameData(email: emailIn)
            checkGameDataChange()
        }
        
        
    }
}

//struct Game_Previews: PreviewProvider {
//    static var previews: some View {
//        Game()
//    }
//}
