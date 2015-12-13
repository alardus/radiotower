//
//  AppDelegate.swift
//  RadioTower
//
//  Created by Alexander Bykov on 19.04.15.
//  Copyright (c) 2015 Alexander Bykov. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    var aboutWindow: AboutWindow!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // If stat was sent at previous day - send it again
//    func checkStatReport() {
//        // Set current date
//        let date = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let currentDate = dateFormatter.stringFromDate(date)
//        
//        
//        // Set Google Analytics URL
//        let uuid = defaults.stringForKey("userID") as String!
//        let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
//        let analyticsURL = "uid="+uuid+"&an=RadioTower3&av="+build
//        
//        // Send statistic
//        if defaults.stringForKey("lastReport") != nil {
//            if defaults.stringForKey("lastReport") == currentDate {
//                // reported already, do nothing
//            } else {
//                // Sending report
//                let uuid = defaults.stringForKey("userID") as String!
//                let sendStat = NSTask()
//                sendStat.launchPath = "/usr/bin/curl"
//                sendStat.arguments = ["-G", "http://portaller.com/app/collect", "-d", analyticsURL]
//                sendStat.launch()
//                sendStat.waitUntilExit()
//                
//                
//                // Touch last report date
//                defaults.setObject(currentDate, forKey: "lastReport")
//            }
//        } else {
//            // Sending report
//            let uuid = defaults.stringForKey("userID") as String!
//            let sendStat = NSTask()
//            sendStat.launchPath = "/usr/bin/curl"
//            sendStat.arguments = ["-G", "http://portaller.com/app/collect", "-d", analyticsURL]
//            sendStat.launch()
//            sendStat.waitUntilExit()
//            
//            // Touch last report date
//            defaults.setObject(currentDate, forKey: "lastReport")
//        }
//    }
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.menu = statusMenu
        
        
        // FOR DEBUG, MUST BE COMMENTED
        //defaults.setObject("28-04-2015", forKey: "lastReport")
        
        
        // Set UUID
        if defaults.stringForKey("userID") != nil {
            // do nothing
        } else {
            let uuid = NSUUID().UUIDString
            defaults.setObject(uuid, forKey: "userID")
        }
        
        
        // Special delay func
        func delay(delay:Double, closure:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), closure)
        }
        
        
        // Call checkStatReport and set sleep timer for 12 hours (43200sec)
//        checkStatReport()
//        NSTimer.scheduledTimerWithTimeInterval(43200, target: self, selector: Selector("checkStatReport"), userInfo: nil, repeats: true)
    
    }
    
    
    override func awakeFromNib() {
        
        // Set icons and enable support for dark theme
        let iconOn = NSImage(named: "statusIcon")
        let iconOff = NSImage(named: "statusIconOff")
        iconOn!.template = true
        iconOff!.template = true
        
        
        // Run NSTask and read output
        func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
            
            var output : [String] = []
            var error : [String] = []
            
            let task = NSTask()
            task.launchPath = cmd
            task.arguments = args
            
            let outpipe = NSPipe()
            task.standardOutput = outpipe
            let errpipe = NSPipe()
            task.standardError = errpipe
            
            task.launch()
            
            let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
            if var string = String.fromCString(UnsafePointer(outdata.bytes)) {
                string = string.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
                output = string.componentsSeparatedByString("\n")
            }
            
            let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
            if var string = String.fromCString(UnsafePointer(errdata.bytes)) {
                string = string.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
                error = string.componentsSeparatedByString("\n")
            }
            
            task.waitUntilExit()
            let status = task.terminationStatus
            
            return (output, error, status)
        }
        
        
        // Read output for Wi-Fi and Ethernet adapters
        let outputWf = runCommand("/usr/sbin/networksetup", args: "-getdnsservers", "Wi-Fi").output
        let outputEth = runCommand("/usr/sbin/networksetup", args: "-getdnsservers", "USB Ethernet").output
        
        
        // Define "right" settings
        let rightSettings = ["107.170.15.247", "77.88.8.8"]
        
        
        // Compare current settings to "right" and set menu items
        if outputWf == rightSettings {
            wfItem.state = NSOnState
        }
            
        if outputEth == rightSettings {
            ethItem.state = NSOnState
        }
        
        
        // Set proper icon in menubar
        if outputWf == rightSettings {
            statusItem.image = iconOn
        } else if outputEth == rightSettings {
            statusItem.image = iconOn
        } else {
            statusItem.image = iconOff
        }
        
        aboutWindow = AboutWindow()
    }
    
    
    // Outlets for menubar items
    @IBAction func loadPandora(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.pandora.com")!)
    }
    
    @IBAction func loadSpotify(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.spotify.com")!)
    }
    
    @IBAction func loadNetflix(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.netflix.com")!)
    }
    @IBOutlet weak var wfItem: NSMenuItem!
    @IBOutlet weak var ethItem: NSMenuItem!

    
    // Actions with menubar items
    @IBAction func menuEth(sender: NSMenuItem) {
        let eth = NSTask()
        eth.launchPath = "/usr/sbin/networksetup"
        
        if(sender.state == NSOnState) {
            sender.state = NSOffState
            eth.arguments = ["-setdnsservers", "USB Ethernet", "Empty"]
            let iconOff = NSImage(named: "statusIconOff")
            statusItem.image = iconOff
        }
        else {
            sender.state = NSOnState
            eth.arguments = ["-setdnsservers", "USB Ethernet", "107.170.15.247", "77.88.8.8"]
            let iconOn = NSImage(named: "statusIcon")
            statusItem.image = iconOn
        }
        
        eth.launch()
        eth.waitUntilExit()
    }
    
    
    @IBAction func menuWf(sender: NSMenuItem) {
        let wf = NSTask()
        wf.launchPath = "/usr/sbin/networksetup"
        
        if(sender.state == NSOnState) {
            sender.state = NSOffState
            wf.arguments = ["-setdnsservers", "Wi-Fi", "Empty"]
            let iconOff = NSImage(named: "statusIconOff")
            statusItem.image = iconOff
        }
        else {
            sender.state = NSOnState
            wf.arguments = ["-setdnsservers", "Wi-Fi", "107.170.15.247", "77.88.8.8"]
            let iconOn = NSImage(named: "statusIcon")
            statusItem.image = iconOn
            
        }
        
        wf.launch()
        wf.waitUntilExit()
    }


    @IBAction func menuAbout(sender: NSMenuItem) {
        aboutWindow.showWindow(nil)
    }
    
    
    @IBAction func menuExit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
}

