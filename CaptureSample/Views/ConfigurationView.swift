/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that provides the UI to configure screen capture.
*/

import SwiftUI
import ScreenCaptureKit

let myLedStrip = LEDModel()

/// The app's configuration user interface.
struct ConfigurationView: View {
    
    private let sectionSpacing: CGFloat = 20
    private let verticalLabelSpacing: CGFloat = 8
    
    private let alignmentOffset: CGFloat = 10
    
    @ObservedObject var screenRecorder: ScreenRecorder
//    @Binding var userStopped: Bool
    
    var body: some View {
        VStack {
            Form {
                HeaderView("Monitor")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                
                // A group that hides view labels.
                Group {
                    
                    VStack(alignment: .leading, spacing: verticalLabelSpacing) {
                        Picker("Display", selection: $screenRecorder.selectedDisplay) {
                            ForEach(screenRecorder.availableDisplays, id: \.self) { display in
                                Text(display.displayName)
                                    .tag(SCDisplay?.some(display))
                            }
                        }
                        
                    }
                    .padding(.bottom, 10.0)
                }
                .labelsHidden()
                
                // Add some space between the Video and Audio sections.
                Spacer()
                    .frame(height: 20)
                
                HeaderView("Audio")
                
//                AudioLevelsView(audioLevelsProvider: screenRecorder.audioLevelsProvider) // <-- constantly crashing cause of the audio thingy

                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(MaterialView())
    }
}

/// A view that displays a styled header for the Video and Audio sections.
struct HeaderView: View {
    
    private let title: String
    private let alignmentOffset: CGFloat = 10.0
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.secondary)
            .alignmentGuide(.leading) { _ in alignmentOffset }
    }
}
