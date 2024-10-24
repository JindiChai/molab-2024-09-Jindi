//
//  ContentView.swift
//  Week7
//
//  Created by Jindi Chai on 10/24/24.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct ContentView: View {
    @EnvironmentObject var document: Document
    @State private var isTimerActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.purple.opacity(0.15).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Choose Focus Time")
                        .font(.headline)
                        .padding()
                    
                    if let lastItemIndex = document.model.items.indices.last {
                        Picker("Time", selection: Binding(
                            get: { document.model.items[lastItemIndex].selectedTime },
                            set: { document.model.items[lastItemIndex].selectedTime = $0 }
                        )) {
                            Text("1 min").tag(60)
                            Text("5 min").tag(300)
                            Text("10 min").tag(600)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    } else {
                        Text("No items available")
                    }
                    
                    Text("You have started \((document.model.items.last?.meditationCount ?? 0)) focus sessions")
                        .font(.headline)
                        .padding()
                    
                    NavigationLink(destination: TimerView(selectedTime: (document.model.items.last?.selectedTime ?? 60))) {
                        Text("Start Focus Session")
                            .font(.title3)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        if let lastItemIndex = document.model.items.indices.last {
                            document.model.items[lastItemIndex].meditationCount += 1
                            document.updateItems()
                        }
                    })
                }
                .navigationTitle("Focus Timer")
            }
        }
    }
}

import SwiftUI
import AVFoundation
import PhotosUI

struct TimerView: View {
    @EnvironmentObject var document: Document
    let selectedTime: Int
    @State private var timeRemaining: Int
    @State private var timer: Timer? = nil
    @State private var showAlert = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var progress: Double = 1.0
    @State private var showBackgroundPicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var processedImage: Image?
    @Environment(\.presentationMode) var presentationMode
    
    // 获取屏幕的宽度
    let screenWidth = UIScreen.main.bounds.width
    
    init(selectedTime: Int) {
        self.selectedTime = selectedTime
        _timeRemaining = State(initialValue: selectedTime)
    }
    
    var body: some View {
        ZStack {
            if let lastItemIndex = document.model.items.indices.last {
                let background = document.model.items[lastItemIndex].selectedBackground
                if background == "Default" {
                    Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                } else if let customImage = loadImageFromDocuments(imageName: background) {
                    Image(uiImage: customImage)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                } else if let processedImage {
                    processedImage
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                }
            }
            
            VStack {
                Text("Time Remaining")
                    .font(.headline)
                    .padding()
                
                Text("\(timeString(from: timeRemaining))")
                    .font(.system(size: 60, weight: .bold))
                    .padding()

                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: screenWidth * 0.9)
                    .padding(.horizontal, screenWidth * 0.1)

                
                // background select
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                    Text("Choose Background")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .onChange(of: selectedItems) {
                    if let item = selectedItems.first {
                        loadImage(from: item)
                    }
                }

                Button("Stop Timer") {
                    stopTimer()
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.title)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .onAppear(perform: startTimer)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Time's Up!"), message: Text("Your focus time is over"), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            stopTimer()
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Back")
        })
        
    }
    
    func startTimer() {
        if let path = Bundle.main.path(forResource: "focus_music", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("audio play error")
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = Double(timeRemaining) / Double(selectedTime)
            } else {
                stopTimer()
                showAlert = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        audioPlayer?.stop()
        timer = nil
    }
    
    func timeString(from time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func loadImage(from item: PhotosPickerItem) {
        Task {
            guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            processedImage = Image(uiImage: inputImage)
            saveImageToDocuments(data: imageData)
        }
    }

    func saveImageToDocuments(data: Data) {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            if let lastItemIndex = document.model.items.indices.last {
                document.model.items[lastItemIndex].selectedBackground = fileName
                document.updateItems()
            }
        } catch {
            print("Error saving image: \(error)")
        }
    }

    func loadImageFromDocuments(imageName: String) -> UIImage? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        } else {
            print("Error loading image: \(imageName)")
            return nil
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = Document()
        ContentView()
            .environmentObject(model)
    }
}
