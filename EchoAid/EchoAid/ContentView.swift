//
//  ContentView.swift
//  EchoAid
//
//  Created by fzfzlfz on 2/3/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showSaveButton = false // Example state variable, adjust logic as needed
    @State private var isRecording = false // Example state variable, adjust logic as needed
    @State private var messageText = "Welcome to EchoTag!" // Example message text

    var body: some View {
        VStack {
            scanButton
            Spacer()
            messageDisplay
            actionButtons
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
        Text(messageText)
            .font(.title)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
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
                .frame(minWidth: 100, maxWidth: .infinity)
                .padding()
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    // Action methods
    private func scanButtonTapped() {
        // Implement scanning logic here
        messageText = "Scanning..."
    }

    private func saveButtonTapped() {
        // Implement save logic here
        messageText = "Saving..."
    }

    private func recordButtonTapped() {
        isRecording.toggle() // Example toggle logic
        messageText = isRecording ? "Recording..." : "Stopped recording."
    }

    private func playButtonTapped() {
        // Implement play logic here
        messageText = "Playing..."
    }

    private func deleteButtonTapped() {
        // Implement delete logic here
        messageText = "Deleted..."
    }
}

// Example preview provider with a placeholder PersistenceController
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

