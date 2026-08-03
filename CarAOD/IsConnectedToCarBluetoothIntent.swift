//
//  IsConnectedToCarBluetoothIntent.swift
//  CarAOD
//
//  Created by Hendrik Rombach on 03.08.26.
//

import Foundation
import AppIntents
import AVFAudio

struct IsConnectedToCarBluetoothIntent: AppIntent {
    static let title: LocalizedStringResource = "Is Connected To Car Bluetooth"
    static var description = IntentDescription(
        "Checks whether the current audio route matches the saved car Bluetooth device."
    )
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        let target = UserDefaults.standard.string(forKey: "carBluetoothName") ?? ""
        
        guard !target.isEmpty else {
            return .result(value: false)
        }
        
        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
        let matched = outputs.contains { output in
            output.portName == target &&
            (output.portType == .bluetoothHFP || output.portType == .bluetoothA2DP)
        }
        
        return .result(value: matched)
    }
}
