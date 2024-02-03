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
    
    // Function to ensure a UID is scanned before proceeding
    private func ensureScannedUIDExists() -> Bool {
        if !scannedUID.isEmpty {
            return true
        } else {
            self.testMessage = "No tag detected, please touch an EchoTag first" // Update here
            return false
        }
    }
    
    private func ensureScannedAudioExists() -> Bool {
        if !audioName.isEmpty {
            return true
        } else {
            self.testMessage = "No audio for this EchoTag, please record" // Update here
            return false
        }
    }
    
    func recordButtonTapped() {
        showRecordMessage = true
        guard ensureScannedUIDExists() else { return }
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
        guard ensureScannedUIDExists() else { return }
        let uniqueFileName = generateUniqueFileName()
        audioName = uniqueFileName
        self.testMessage = "Save as \(uniqueFileName)" // Update here

        audioRecorderManager.saveRecording(to: getDocumentsDirectory(), withName: uniqueFileName)
        saveUIDAndAudioFilename(scannedUID, filename: uniqueFileName)

        showSaveButton = false
        showSaveMessage = true
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func generateUniqueFileName() -> String {
        let timestamp = Date().timeIntervalSince1970
        return "recording_\(timestamp).m4a"
    }

    func playButtonTapped() {
        guard ensureScannedUIDExists() else { return }
        playRecording()
    }

    func playRecording() {
        let audioFilename: URL
        if showSaveButton {
            audioFilename = audioRecorderManager.tempAudioFilename
        } else {
            guard ensureScannedAudioExists() else { return }
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
        guard ensureScannedUIDExists() else { return }
        guard ensureScannedAudioExists() else { return }
        self.testMessage = "Delete" // Update here
        if let existingEntity = recordedAudios.first(where: { $0.uid == scannedUID }) {
            viewContext.delete(existingEntity)
        }
        scannedUID = ""
        audioName = ""
    }
    

    func saveUIDAndAudioFilename(_ uid: String, filename: String) {
        if let existingEntity = recordedAudios.first(where: { $0.uid == uid }) {
            viewContext.delete(existingEntity)
        }
        
        let newRecording = RecordedAudio(context: viewContext)
        newRecording.uid = uid
        newRecording.audioFilename = filename

        do {
            try viewContext.save()
        } catch {
            self.testMessage = "Error saving context: \(error.localizedDescription)" // Update here
        }
    }
}

// If you have a Preview provider, it remains as it is.
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
