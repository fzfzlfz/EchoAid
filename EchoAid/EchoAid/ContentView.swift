//
//  ContentView.swift
//  EchoAid
//
//  Created by fzfzlfz on 2/3/24.
//

import SwiftUI
import AVFoundation
import CoreData

struct ContentView: View {
    let audioRecorderManager = AudioRecorderManager()
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isRecording = false
    @State private var showSaveButton = false
    @State private var showSaveMessage = false
    @State private var showRecordMessage = false
    @State private var recordingMessage: String = ""
    @State private var audioPlayer: AVAudioPlayer?
    @State private var scannedUID: String = ""
    @State private var audioName: String = ""
    @State private var testMessage: String = "" // Add this line

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RecordedAudio.uid, ascending: true)],
        animation: .default)
    private var recordedAudios: FetchedResults<RecordedAudio>

    var body: some View {
        VStack {
            scanButton
            Spacer()
            messageDisplay
            actionButtons
            Text(testMessage)
                .foregroundColor(.red)
        }
        .padding()
    }

    private var scanButton: some View {
        Button(action: scanButtonTapped) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .padding(60)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }

    private var messageDisplay: some View {
        Group {
            if showSaveMessage {
                Text("Recording Saved")
                    .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.showSaveMessage = false
                    }
                }
            }
            
            if showRecordMessage{
                Text(recordingMessage)
                    .foregroundColor(Color.purple)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 20) {
            if showSaveButton {
                actionButton(title: "Save", color: .black, action: saveButtonTapped)
            }
            actionButton(title: isRecording ? "Stop" : "Record", color: .orange, action: recordButtonTapped)
            actionButton(title: "Play", color: .green, action: playButtonTapped)
            actionButton(title: "Delete", color: .red, action: deleteButtonTapped)
        }
    }

    private func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(40)
        }
    }

    // Functions for button actions
    func scanButtonTapped() {
        self.testMessage = "Scan trigger"
        self.scannedUID = "Test123"
            
    }

    
    // Core Data Interaction
    func findAudioByUID(_ uid: String) -> RecordedAudio? {
        recordedAudios.first { $0.uid == uid }
    }
    
    func recordButtonTapped() {
        showRecordMessage = true

        if isRecording {
            audioRecorderManager.stopRecording()
            isRecording = false
            showSaveButton = true
            recordingMessage = "Recording stopped."
            self.testMessage = recordingMessage // Update here
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showRecordMessage = false
            }
        } else {
            recordingMessage = "Recording started..."
            self.testMessage = recordingMessage // Update here
            audioRecorderManager.startRecording()
            isRecording = true
        }
    }

    
    func saveButtonTapped() {
        self.testMessage = "Saving..."
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }


    func playButtonTapped() {
        playRecording()
    }

    func playRecording() {
        let audioFilename: URL
        if showSaveButton {
            audioFilename = audioRecorderManager.tempAudioFilename
        } else {
            audioFilename = getDocumentsDirectory().appendingPathComponent(audioName)
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            guard let player = audioPlayer else {
                self.testMessage = "Failed to initialize AVAudioPlayer" // Update here
                return
            }

            if player.prepareToPlay() {
                player.play()
            } else {
                self.testMessage = "Player is not ready to play audio" // Update here
            }
        } catch {
            self.testMessage = "Could not load file for playback: \(error.localizedDescription)" // Update here
        }
    }

    func deleteButtonTapped() {
        self.testMessage = "deleting..."
    }
    

    func saveUIDAndAudioFilename(_ uid: String, filename: String) {}
}

// If you have a Preview provider, it remains as it is.
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
