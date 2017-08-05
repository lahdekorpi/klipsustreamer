//
//  klipsustreamer
//  A simple CLI tool for macOS to monitor clipboard changes and output the contents as a JSON stream
//  Copyright © 2017 Toni Lähdekorpi. All rights reserved.
//

import Foundation
import AppKit

class Klipsustreamer:NSObject {
    var clipTimer:Timer? = nil // Define timer
    var counter = 0 // Define clipboard change counter

    var pasteboard = NSPasteboard.general() // Init pasteboard

    func checkChanges(interval: Double) {
        clipTimer = Timer.scheduledTimer(withTimeInterval:interval, repeats:false, block: {_ in
            let newCount = self.pasteboard.changeCount
            var clipType = ""
            var clipData = ""
            
            if(newCount != self.counter) {
                self.counter = newCount
                if let str: String = self.pasteboard.string(forType: NSPasteboardTypeHTML) {
                    clipType = "html"
                    clipData = str
                } else if let str: String = self.pasteboard.string(forType: NSPasteboardTypeRTF) {
                    clipType = "rtf"
                    clipData = str
                } else if let str: String = self.pasteboard.string(forType: NSPasteboardTypeString) {
                    clipType = "text"
                    clipData = str
                }
                if(clipType != "") {
                    let json = ["type":clipType,"data":clipData]

                    let data = try! JSONSerialization.data(withJSONObject: json)
                    let string: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String!
                    print(string)
                }
            }

            self.checkChanges(interval:interval)
        })
    }
}

let arguments = CommandLine.arguments
var interval: Double = 0.1

if(arguments.count > 1 && (arguments[1]=="--help" || arguments[1]=="-h" || arguments[1]=="-?")) {
    print("klipsustreamer 1.0.1\n\nUsage:\n -h - Show help\n -i - Set update interval in seconds (default -i 0.1)")
} else {
    if(arguments.count > 2 && arguments[1]=="-i") {
        interval = (arguments[2] as NSString).doubleValue
    }

    let cli = Klipsustreamer()
    cli.checkChanges(interval: interval)

    let theRL = RunLoop.current
    while theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) { }
}

