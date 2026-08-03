//
//  ContentView.swift
//  CarAOD
//
//  Created by Hendrik Rombach on 03.08.26.
//

import SwiftUI
import AVFAudio

struct DiagnosticsView: View {
    @State private var outputs: [String] = []
    
    @AppStorage("carBluetoothName") private var carBluetoothName: String = ""
    
    var body: some View {
        List {
            Section("Detected Audio Outputs") {
                ForEach(outputs, id: \.self) { Text($0) }
            }
            
            Section("Car Bluetooth Name") {
                TextField("e.g. Tesla Model Y", text: $carBluetoothName)
            }
        }
        .onAppear(perform: refresh)
        .refreshable { refresh() }
    }
    
    func refresh() {
        outputs = AVAudioSession.sharedInstance().currentRoute.outputs
            .map { "\($0.portName) - \($0.portType.rawValue)" }
    }
}

#Preview {
    DiagnosticsView()
}
