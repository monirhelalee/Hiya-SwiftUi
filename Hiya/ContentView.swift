//
//  ContentView.swift
//  Hiya
//
//  Created by monir on 1/4/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    private var largeLamguageModel = SystemLanguageModel.default
    private var session = LanguageModelSession()
    
    @State private var response: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            switch largeLamguageModel.availability{
            case .available:
                if response.isEmpty{
                    if isLoading{
                        ProgressView()
                    }else{
                        Text("Tap the button to get a fun response")
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                            .font(.title)
                    }
                }else{
                    if isLoading{
                        ProgressView()
                    }else{
                        Text(response)
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .bold()
                    }
                }
            case .unavailable(.deviceNotEligible):
                Text("Your Device is not eligible for Apple Inteligent.")
            case .unavailable(.appleIntelligenceNotEnabled):
                Text("Please enable Apple Intelligence in settings")
            case .unavailable(.modelNotReady):
                Text("Model is not ready yet.")
            case .unavailable(_):
                Text("The AI feature in unavailable for unknown reason.")
            }
            Spacer()
                
            Button{
                Task{
                    isLoading = true
                    defer { isLoading = false }
                    
                    let prompt = "Say hi in fun way."
                    
                    do{
                        let reply = try await session.respond(to: prompt)
                        response = reply.content
                    } catch{
                        response = "Failed to get response: \(error.localizedDescription)"
                    }
                    
                }
            } label: {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonSizing(.flexible)
            .glassEffect(.regular.interactive())
        }
        .padding()
        .tint(.purple)
    }
}

#Preview {
    ContentView()
}
