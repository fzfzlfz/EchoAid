//
//  AVAudioRecorder.swift
//  EchoAid
//
//  Created by fzfzlfz on 2/3/24.
//  Updated by chewyuenrachael on 2/4/24

import AVFoundation

// Define a custom error type
enum AudioRecorderError: Error {
    case sessionSetupFailed(String)
    case recordingFailed(String)
    case saveFailed(String)
    case encodingFailed(String)
    
    var localizedDescription: String {
        switch self {
        case .sessionSetupFailed(let message),
             .recordingFailed(let message),
             .saveFailed(let message),
             .encodingFailed(let message):
            return message
        }
    }
}

class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    let tempAudioFilename = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp_recording.m4a")

    // Configure the audio session for recording
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }

    // Start recording to a temporary file URL
    func startRecording() {
        print("Temporary audio filename: \(tempAudioFilename)")
        configureAudioSession()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100, // Standard sample rate for better quality
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: tempAudioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            print("Recording started.")
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    // Stop the recording
    func stopRecording() {
        audioRecorder?.stop()
        print("Recording stopped.")
    }

    // Save the recording with a unique filename
    func saveRecording(to directory: URL, withName name: String) {
        let destinationURL = directory.appendingPathComponent(name)
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.moveItem(at: tempAudioFilename, to: destinationURL)
            print("Recording saved to \(destinationURL).")
        } catch {
            print("Failed to save recording: \(error.localizedDescription)")
        }
    }

    // Delegate method called when recording is finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully.")
        } else {
            print("Recording finished unsuccessfully.")
        }
    }

    // Delegate method called if an encoding error occurs
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Encoding error: \(error.localizedDescription)")
        }
    }
}
