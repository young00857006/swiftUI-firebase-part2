//
//  Setstyle.swift
//  part1
//
//  Created by 賴冠宏 on 2022/6/1.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
//import FirebaseStorageSwift

struct RoleData: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let sex: String
    let country: String
    let email: String
    let birthday: String
    var money: Int
    let image: String
    let year: String
}

struct Setstyle: View {
    @Binding var emailIn:String
    @State private var nameIn = ""
    //@State private var emailIn = ""
    @State private var countryIn = ""
    @State private var firstKissDay = Date()
    //@State private var ageIn: Double = 18
    let sex = ["男生", "女生"]
    @State private var selectedIndex = 0
    @State private var colorIn: Double = 1
    @State private var hairIn: Double = 1
    @State private var glassIn: Double = 1
    @State private var yearIn: Double = 1
    @State private var image = ""
    @State private var backToC = false
    func create() {
        let db = Firestore.firestore()
        image =  "\(selectedIndex)\(Int(hairIn))\(Int(glassIn))\(Int(colorIn))"
        let data = RoleData(name:"\(nameIn)", sex:"\(sex[selectedIndex])", country:"\(countryIn)", email: "\(emailIn)", birthday:"\(firstKissDay)", money: 5000, image: "\(image)", year: "\(yearIn)" )
        do {
            try db.collection("RoleDatas").document("\(emailIn)").setData(from: data)
            //let documentReference = try db.collection("RoleDatas").addDocument(from: data)
                //print(documentReference.documentID)
        } catch {
            print(error)
        }
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.9) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success(_):
                         fileReference.downloadURL(completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func upPhoto(){
        var imageName = ""
        imageName =  "\(selectedIndex)\(Int(hairIn))\(Int(glassIn))\(Int(colorIn))"
        let uiImage = UIImage(named: "\(imageName)")
        uploadPhoto(image: uiImage!) { result in
            switch result {
            case .success(let url):
                print(url)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var body: some View {
        ScrollViewReader{_ in
            Form{
                VStack{
                    Image("\(selectedIndex)\(Int(hairIn))\(Int(glassIn))\(Int(colorIn))")
                        .resizable()
                        .frame(width: 300, height: 400)
                        .scaledToFill()

                    Button("random"){
                        var number1 = Int.random(in: 0...1)
                        var number2 = Int.random(in: 1...2)
                        var number3 = Int.random(in: 1...2)
                        var number4 = Int.random(in: 1...2)
                        selectedIndex = number1
                        hairIn = Double(number2)
                        glassIn = Double(number3)
                        colorIn = Double(number4)
                    }
                }
                HStack{
                    Text("名稱:")
                    TextField("Roger", text: $nameIn)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        
                }
                HStack{
                    Text("性別:")
                    Picker(selection: $selectedIndex, label: Text("選擇角色")){
                        ForEach(sex.indices) { item in
                            Text(sex[item])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                HStack{
                    Text("髮型:\(Int(hairIn))")
                    Slider(value: $hairIn, in: 1...2, step: 1)
                }
                HStack{
                    Text("眼鏡:\(Int(glassIn))")
                    Slider(value: $glassIn, in: 1...2, step: 1)
                }
                HStack{
                    Text("衣服:\(Int(colorIn))")
                    Slider(value: $colorIn, in: 1...2, step: 1)
                }
                HStack{
                    Text("國家:")
                    TextField("Taiwan", text: $countryIn)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                HStack{
                    Text("年齡:\(Int(yearIn))")
                    Slider(value: $yearIn, in: 1...99, step: 1)
                }
                
                DatePicker("加入遊戲時間(無需調整)", selection: $firstKissDay, in: ...Date(), displayedComponents: .date)
                    
                Button("儲存"){
                    upPhoto()
                    create()
                    backToC = true
                }
                .fullScreenCover(isPresented: $backToC) {
                    ContentView()
                }
                
            }
        }
    }
}

