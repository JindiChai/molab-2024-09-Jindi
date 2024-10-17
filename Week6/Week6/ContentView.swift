//
//  ContentView.swift
//  Week6
//
//  Created by Jindi Chai on 10/17/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @EnvironmentObject var document:Document
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
                            get: { document.model.items[lastItemIndex].selectedTime }, // Getter
                            set: { document.model.items[lastItemIndex].selectedTime = $0 }   // Setter
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
                    
                    // start button
                    NavigationLink(destination: TimerView(selectedTime:( document.model.items.last?.selectedTime ?? 60))) {
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
                            document.updateItems();
                        }
                    })
                }
                .navigationTitle("Focus Timer")
            }
        }
    }
}

struct TimerView: View {
    @EnvironmentObject var document:Document
    let selectedTime: Int
    @State private var timeRemaining: Int
    @State private var timer: Timer? = nil
    @State private var showAlert = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var progress: Double = 1.0  // percentage of remaining time
    
    // New state for selected background image
    @State private var showBackgroundPicker = false // State to show the picker sheet
    
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedTime: Int) {
        self.selectedTime = selectedTime
        _timeRemaining = State(initialValue: selectedTime)
    }
    
    var body: some View {
        ZStack {
            // Conditional background based on selected image
            if document.model.items.last?.selectedBackground == "Default" {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            } else if document.model.items.last?.selectedBackground == "Background 1" {
                Image("background1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else if document.model.items.last?.selectedBackground == "Background 2" {
                Image("background2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
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
                    .padding()
                
                // Button to show the background picker
                Button("Choose Background") {
                    showBackgroundPicker = true // Show the sheet when button is tapped
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Stop Timer") {
                    stopTimer()
                    presentationMode.wrappedValue.dismiss() // Dismiss the view manually
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
            presentationMode.wrappedValue.dismiss() // Manually dismiss when tapping back
        }) {
            Text("Back")
        })
        .sheet(isPresented: $showBackgroundPicker) {
            BackgroundPicker(onClose: {
                showBackgroundPicker = false // Close the sheet
            })
        }
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
        
        //start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = Double(timeRemaining) / Double(selectedTime)  // update time bar
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
    
    // trans time to min:sec
    func timeString(from time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Background picker view displayed in a sheet
struct BackgroundPicker: View {
    @EnvironmentObject var document:Document
    var onClose: () -> Void // A callback to close the sheet
    
    var body: some View {
        VStack {
            Text("Choose a Background")
                .font(.headline)
                .padding()

            // Display background options as thumbnails
            HStack {
                if let lastItemIndex = document.model.items.indices.last {
                    Button(action: {
                        document.model.items[lastItemIndex].selectedBackground = "Default"
                        document.updateItems();
                        onClose() // Call the onClose callback to close the sheet
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        document.model.items[lastItemIndex].selectedBackground = "Background 1"
                        document.updateItems();
                        onClose() // Call the onClose callback to close the sheet
                    }) {
                        Image("background1")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        document.model.items[lastItemIndex].selectedBackground = "Background 2"
                        document.updateItems();
                        onClose() // Call the onClose callback to close the sheet
                    }) {
                        Image("background2")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            Button("Close") {
                onClose() // Close the sheet when button is pressed
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
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
