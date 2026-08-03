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
    
    var body: some View {
        List(outputs, id: \.self) { Text($0) }
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
