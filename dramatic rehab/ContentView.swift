//
//  ContentView.swift
//  dramatic rehab
//
//  Created by Jaemin Lee on 2023/06/13.
//


import SwiftUI
import Combine
import AVFoundation
import UserNotifications

struct Page1: View {
    let genderType = ["남성", "여성", "비밀"]
    
    @State var name = ""
    @State var age = ""
    @State var touchedCount = 0
    @State var bornIn = 0
    @State var gender = 0
    
    var resultScript:String{
        if(name.isEmpty){
            return "이름을 입력해주세요"
        }else{
            return "\(name)의 나이는 \(age) 성별은 \(genderType[gender])"
        }
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("이름")){
                    TextField("이름를 입력해주세요", text: $name).keyboardType(.default)
                }
                Section(header: Text("나이")){
                    TextField("나이를 입력해줘요", text: $age).keyboardType(.numberPad)
                }
                Section(header:Text("생년월일")){
                    Picker("출생년도", selection: $bornIn){
                        ForEach(1900 ..< 2023){
                            Text("\(String($0))년생")
                        }
                    }
                }
                Section(header: Text("성별")){
                    Picker("성별", selection: $gender){
                        ForEach(0 ..< genderType.count){
                            Text("\(self.genderType[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Text("\(resultScript)")
                
                Text("클릭수 \(touchedCount)")
                Button("눌러보시오"){
                    self.touchedCount += 1
                }
                
                Group{
                    Text("Hi! jaemin")
                    Text("Hi! jaemin")
                }
                
            }.navigationTitle("Dramatic Rehab")
        }
    }
}

struct Page2: View {
    @State private var timerCount = 0
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("Timer Count: \(timerCount)").font(.title)
            
            Button(action: {
                if isTimerRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            }) {
                Text(isTimerRunning ? "Stop Timer" : "Start Timer").font(.headline).padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
        }
    }
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in timerCount += 1
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
}

struct Page3: View {
    @State private var workoutTime = ""
    @State private var restTime = ""
    @State private var prepareTime = ""
    @State private var repeatNumber = ""
    @State private var setNumber = ""
    @State private var remainingTime = 0
    @State private var remainingSets = 0
    @State private var remainingReps = 0
    @State private var isTimerRunning = false
    @State private var fontColor = Color.black
    @State private var timerStatus = 0
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let soundPlayer = SoundPlayer()
    let timeType = ["Ready 😊", "GO HARD! 🔥", "TAKE A REST 😎", "PREPARE NEXT SET 🥴"]
    
    var body: some View {
        VStack {
            Text("Jaeminiman's First Step").font(.largeTitle)
            Spacer()
            Text("\(timeType[timerStatus])").font(.title)
            Spacer()
            Text("Remaining Time: \(remainingTime)")
                .font(.title2).foregroundColor(fontColor)
            Spacer()
            HStack{
                Text("Remaining Reps: \(remainingReps)")
                Text("Remaining Sets: \(remainingSets)")
            }
            Form{
                Section(header: Text("Reps")){
                    TextField("Enter Reps", text: $repeatNumber)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Sets")){
                    TextField("Enter Sets", text: $setNumber)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Workout Time")){
                    TextField("Enter Time (in seconds)", text: $workoutTime)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Rest Time Between Reps ")){
                    TextField("Enter Time (in seconds)", text: $restTime)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Rest Time Between Sets")){
                    TextField("Enter Time (in seconds)", text: $prepareTime)
                        .keyboardType(.numberPad)
                }
            }

            HStack{
                Button(action: {
                    startTimer()
                }) {
                    Text(" Start ")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isTimerRunning)
                Button(action: {
                    stopTimer()
                    remainingReps = 0
                    remainingTime = 0
                    remainingSets = 0
                    fontColor = Color.black
                }) {
                    Text("Reset")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if remainingSets > -1 {
                    if remainingReps > -1 {
                        if remainingTime > 0 {
                            remainingTime -= 1
                        } else {
                            changeTimer()
                            playSound()
                        }
                    }
                } else {
                    stopTimer()
                }
            }
        }.padding(.bottom, 10)
    }
    
    func startTimer() {
        guard let woTime = Int(workoutTime) else {
            return
        }
        guard let rNumber = Int(repeatNumber) else {
            return
        }
        guard let sNumber = Int(setNumber) else {
            return
        }
        timerStatus = 1
        fontColor = Color.red
        
        if woTime > 0 {
            remainingTime = woTime
            remainingReps = rNumber-1
            remainingSets = sNumber-1
            isTimerRunning = true
        }
    }
    
    func changeTimer() {
        guard let woTime = Int(workoutTime) else {
            return
        }
        guard let pTime = Int(prepareTime) else {
            return
        }
        guard let reTime = Int(restTime) else {
            return
        }
        guard let reReps = Int(repeatNumber) else {
            return
        }
        if timerStatus == 1 {
            if remainingSets <= 0 && remainingReps <= 0 {
                fontColor = Color.black
                stopTimer()
            } else {
                timerStatus = 2
                fontColor = Color.blue
                remainingTime = reTime
            }
        } else if remainingReps <= 0 && timerStatus == 2{
            timerStatus = 3
            fontColor = Color.green
            remainingTime = pTime
            remainingReps = reReps
            remainingSets -= 1
        } else {
            timerStatus = 1
            fontColor = Color.red
            remainingTime = woTime
            remainingReps -= 1
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timerStatus = 0
    }
    
    func playSound() {
        soundPlayer.playSound(named: "beap") // "sound"는 프로젝트 내에 추가한 사운드 파일의 이름입니다.
    }
}

class SoundPlayer {
    var audioPlayer: AVAudioPlayer?

    func playSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Page1()) {
                    Text("dummy1")
                }
                NavigationLink(destination: Page2()) {
                    Text("dummy2")
                }
                NavigationLink(destination: Page3()) {
                    Text("첫 번째 재활앱")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
