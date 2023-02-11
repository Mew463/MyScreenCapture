/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that renders a video frame.
*/

import SwiftUI
import AppKit

struct CapturePreview: NSViewRepresentable {
//    private var image: NSImage = NSImage()
    
    let myMonitorLeds = MonitorLeds((1920,1080))
    
    func makeNSView(context: Context) -> NSImageView { return NSImageView() }
 

    func updateFrame(_ frame: CapturedFrame) {
        if let ciimage = CIFilter(name: "CIGaussianBlur" , parameters: ["inputImage": CIImage(ioSurface: frame.surface!), "inputRadius" : 25])!.outputImage {
//            let rep = NSCIImageRep(ciImage: ciimage)
//            image.size = rep.size
//            image.addRepresentation(rep)
            myLedStrip.sendColors(myMonitorLeds.returnRGBData(ciimage))
//
        }
        
    }
    
    
    func updateNSView(_ nsView: NSImageView, context: Context) { // Neccessary to conform to NSViewRepresentable
        
    }

}
