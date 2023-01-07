//
//  MonitorLeds.swift
//  CaptureSample
//
//  Created by MingWei Yeoh on 12/17/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import AppKit

class MonitorLeds {
    var ledsTop : Int      = 15
    var ledsSide : Int     = 8
    var ledsBottom : Int   = 6
    var startRight : Bool = true
    
    var cornerGapPix : Int = 100
    var borderInPix : Int  = 50
    var topBorder: Int     = 150
    
    var pixOfInterest: [(_ : Int,_ : Int)] = []
    var dispWidth: Int
    var dispHeight: Int
    
    init(_ displayPixSize: (Int, Int)) {
        dispWidth = displayPixSize.0
        dispHeight = displayPixSize.1
        self.calcPixOfInterest()
    }
    
    func calcPixOfInterest() {
        let pixWidthPerLed = (dispWidth - 2 * cornerGapPix) / ledsTop
        let pixHeightPerLed = (dispHeight - 2 * cornerGapPix) / ledsSide
        let bottomSideLed = ledsBottom/2 - 1
        
        for index in 0...bottomSideLed {
            pixOfInterest.append((dispWidth - cornerGapPix - (bottomSideLed - index) * pixWidthPerLed, dispHeight - borderInPix))
        }
        
        for index in 0...ledsSide-1 {
            pixOfInterest.append((dispWidth - borderInPix , dispHeight - cornerGapPix - (index) * pixHeightPerLed))
        }
        
        for index in 0...ledsTop-1 {
            pixOfInterest.append(( dispWidth - cornerGapPix - (index * pixWidthPerLed) , topBorder))
        }
        
        for index in 0...ledsSide-1 {
            pixOfInterest.append((borderInPix , cornerGapPix + (index) * pixHeightPerLed))
        }
        
        for index in 0...bottomSideLed {
            pixOfInterest.append((cornerGapPix + (index) * pixWidthPerLed, dispHeight - borderInPix))
        }

    }
    
    
    
    func returnRGBData(_ frame: CIImage) -> Data{
        var myData: Data = Data()
        let bitmap = NSBitmapImageRep(ciImage: frame) // <- problem child right here but I think its kinda necessary

        for point in pixOfInterest {
            myData.append(Data(calcColorAt(point)))
        }

        return myData

        func calcColorAt(_ point: (Int, Int)) -> [UInt8] {
            let color = bitmap.colorAt(x: point.0,y: point.1)
            if let color {
                return [UInt8(color.redComponent * 255), UInt8(color.greenComponent * 255), UInt8(color.blueComponent * 255)]
            }
            print("Error at Calc Color!")
            return [UInt8(0), UInt8(0), UInt8(0)]
        }
    }
    
    
    
    
}
