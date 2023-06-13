//
//  ContentView.swift
//  dramatic rehab
//
//  Created by Jaemin Lee on 2023/06/13.
//

import SwiftUI


struct ContentView: View {
    @State var name = ""
    @State var touchedCount = 0
    var body: some View {
        NavigationView{
            Form{
                TextField("이름를 입력해주세요", text: $name)
                Text("입력한 이름은 \(name)")
                Text("클릭수 \(touchedCount)")
                Button("눌러보시오"){
                    self.touchedCount += 1
                }
                
                Group{
                    Text("Hi! jaemin")
                    Text("Hi! jaemin")
                    Text("Hi! jaemin")
                    Text("Hi! jaemin")
                    Text("Hi! jaemin")
                    Text("Hi! jaemin")
                }
                
            }.navigationTitle("Dramatic Rehab")
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
