//
//  NFCManager.swift
//  EchoAid
//
//  Created by fzfzlfz on 2/3/24.
//

import CoreNFC

class NFCManager: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var uid = ""
    var nfcSession: NFCNDEFReaderSession?
    

    func scan(uid: String) {
        print("scan(uid:) called with uid: \(uid)")
        let uniqueUID = uid.isEmpty ? UUID().uuidString : uid
        self.uid = uniqueUID
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        print("open reader session")
        nfcSession?.alertMessage = "Hold Your iPhone Near an NFC Card"
        nfcSession?.begin()
        print("after begin")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print("in rs")
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than one Tag Detected, please try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }

        guard let tag = tags.first else { return }
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    self.onNFCResult?(.failure(error))
                }
                session.invalidate(errorMessage: "Unable to connect to tag")
                return
            }

            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.onNFCResult?(.failure(error))
                    }
                    session.invalidate(errorMessage: "Error querying NDEF status")
                    return
                }

                switch ndefStatus {
                case .notSupported:
                    DispatchQueue.main.async {
                        self.onNFCResult?(.failure(NFCError.notSupported))
                    }
                    session.invalidate(errorMessage: "Tag not supported")
                case .readOnly:
                    DispatchQueue.main.async {
                        self.onNFCResult?(.failure(NFCError.readOnly))
                    }
                    session.invalidate(errorMessage: "Tag is read-only")
                case .readWrite:
                    // Determine if this is a new tag or an old tag
                    session.alertMessage = "Detect your tag!"
                    if self.uid.isEmpty {
                        // New tag, generate UID and write it to the tag
                        let newUID = UUID().uuidString
                        self.writeNewUID(to: tag, session: session, uid: newUID)
                    } else {
                        // Old tag, proceed with handling the existing UID
                        DispatchQueue.main.async {
                            self.onNFCResult?(.success(self.uid))
                        }
                        session.invalidate()
                    }
                @unknown default:
                    DispatchQueue.main.async {
                        self.onNFCResult?(.failure(NFCError.unknown))
                    }
                    session.invalidate(errorMessage: "Unknown NDEF status")
                }
            })
        })
    }

    func writeNewUID(to tag: NFCNDEFTag, session: NFCNDEFReaderSession, uid: String) {
        let textRecord = NFCNDEFPayload.wellKnownTypeTextPayload(string: uid, locale: Locale.current)
        guard let payload = textRecord else {
            DispatchQueue.main.async {
                self.onNFCResult?(.failure(NFCError.invalidPayload))
            }
            session.invalidate(errorMessage: "Invalid NDEF payload")
            return
        }

        let ndefMessage = NFCNDEFMessage(records: [payload])
        tag.writeNDEF(ndefMessage) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.onNFCResult?(.failure(error))
                }
                session.invalidate(errorMessage: "Failed to write NDEF message")
            } else {
                self.uid = uid // Update the UID after writing
                DispatchQueue.main.async {
                    self.onNFCResult?(.success(uid))
                }
                session.invalidate()
            }
        }
    }

    enum NFCError: Error {
        case notSupported
        case readOnly
        case unknown
        case invalidPayload
    }
    
    // Make sure to define onNFCResult as a closure property in NFCManager:
    var onNFCResult: ((Result<String, Error>) -> Void)?

    // And handle the error case in the same delegate method:
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.onNFCResult?(.failure(error))
        }
    }

}
