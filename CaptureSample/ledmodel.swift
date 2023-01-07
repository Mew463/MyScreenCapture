//
//  ledmodel.swift
//  monitor menu bar
//
//  Created by MingWei Yeoh on 12/13/22.
//

import Foundation
import ORSSerial

class LEDModel {
    private var curData: Data = Data(capacity: 37)
    
    private enum states {
        case STATIC, RAINBOW
    }
    private var LEDStates: states = .STATIC
    
    let serialPort: ORSSerialPort?
    
    let port = "/dev/cu.usbserial-120"
    let numLeds = 37
    
    init() {
        self.serialPort = ORSSerialPort(path: port)
        let _ = connect()
//        var curHue:Int = 0
//        DispatchQueue.global().async { // Keep alive daemon
//            while true {
//                switch self.LEDStates{
//                case .STATIC:
//                    Thread.sleep(forTimeInterval: 5)
////                    self.sendColors(self.curData)
//                case .RAINBOW:
//                    Thread.sleep(forTimeInterval: 0.05)
//                    curHue+=1
//                    if curHue > 360 { curHue = 0}
//                    self.makeRainbow(offsetHue: curHue, deltaHue: 5)
//                }
//            }
//        }
    }
    
    func disconnect() {
        serialPort?.close()
    }
    
    func connect() -> Bool{
        if let serialPort {
            serialPort.baudRate = 115200
            serialPort.open()
            return true
        }
        return false
    }

    func hueToRGB(_ hue: Int) -> [UInt8]{ // Converts a HUE value to RGB value on the edge of the color wheel.
        let z = UInt8(255 * ( 1 - abs((Double(hue)/60).truncatingRemainder(dividingBy: 2) - 1)))
        
        if hue < 60 {
            return [255, z, 0]
        }
        else if hue < 120 {
            return [z, 255, 0]
        }
        else if hue < 180 {
            return [0, 255, z]
        }
        else if hue < 240 {
            return [0, z, 255]
        }
        else if hue < 300 {
            return [z, 0, 255]
        }
        else { // For hue < 360
            return [255, 0, z]
        }
    }
    
    func animateRainbow() {
        LEDStates = .RAINBOW
    }
    
    func makeRainbow(offsetHue: Int, deltaHue:Int ) {
        var myData: Data = Data()
        for i in 0...numLeds{
            myData.append(Data(hueToRGB((offsetHue + i * deltaHue) % 360)))
        }
        sendColors(myData)
    }
    
    func setColor(_ color: [UInt8]) { // Sets ALL leds to a specified RGB Value
        LEDStates = .STATIC
        var myData: Data = Data()
        for _ in 0...numLeds{
            myData.append(Data(color))
        }
        sendColors(myData)
    }
    
    func sendColors(_ dataArray: Data) { // Sends the entire Data array through serial port. Should be enough to fill all of the leds to a certain color
        if let serialPort {
            serialPort.send(Data([0x41, 0x64, 0x61])) // Send "Ada"
            serialPort.send(dataArray)
            curData = dataArray
//            serialPort.send(Data([0x45])) // Send "E"
        }
    }
    
    func lightUpPartColors(_ color: [UInt8], _ percent: Float) { // Sets ALL leds to a specified RGB Value
        var myData: Data = Data()
        for index in 0...numLeds{
            if index > numLeds/2 - Int(Float(numLeds/2)*percent) && index < numLeds/2 + Int(Float(numLeds/2)*percent)  {
                myData.append(Data([0,0,0]))
            } else {
                myData.append(Data(color))
            }
        }
        sendColors(myData)
    }

}
