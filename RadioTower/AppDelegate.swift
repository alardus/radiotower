//
//  AppDelegate.swift
//  RadioTower
//
//  Created by Alexander Bykov on 19.04.15.
//  Copyright (c) 2015 Alexander Bykov. All rights reserved.
//

import Cocoa
import Foundation
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    var aboutWindow: AboutWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength: -1)
    let defaults = UserDefaults.standard
    
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
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let launcherAppId = "com.portaller.RadioTower.LauncherApplication"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
        
        statusItem.menu = statusMenu
        
        
        // FOR DEBUG, MUST BE COMMENTED
        //defaults.setObject("28-04-2015", forKey: "lastReport")
        
        
        // Set UUID
        if defaults.string(forKey: "userID") != nil {
            // do nothing
        } else {
            let uuid = UUID().uuidString
            defaults.set(uuid, forKey: "userID")
        }
        
        
        // Special delay func
        func delay(_ delay:Double, closure:@escaping ()->()) {
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        }
        
        
        // Call checkStatReport and set sleep timer for 12 hours (43200sec)
//        checkStatReport()
//        NSTimer.scheduledTimerWithTimeInterval(43200, target: self, selector: Selector("checkStatReport"), userInfo: nil, repeats: true)
    
    }
    
    
    override func awakeFromNib() {
        
        // Set icons and enable support for dark theme
        let iconOn = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        let iconOff = NSImage(named: NSImage.Name(rawValue: "statusIconOff"))
        iconOn!.isTemplate = true
        iconOff!.isTemplate = true
        
        
        // Run NSTask and read output
        func runCommand(_ cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
            
            let output : [String] = []
            let error : [String] = []
            
            let task = Process()
            task.launchPath = cmd
            task.arguments = args
            
            let outpipe = Pipe()
            task.standardOutput = outpipe
            let errpipe = Pipe()
            task.standardError = errpipe
            
            task.launch()
            
//            let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
//            if var string = String(validatingUTF8: UnsafePointer((outdata as NSData).bytes)) {
//                string = string.trimmingCharacters(in: CharacterSet.newlines)
//                output = string.components(separatedBy: "\n")
//            }
//            
//            let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
//            if var string = String(validatingUTF8: UnsafePointer((errdata as NSData).bytes)) {
//                string = string.trimmingCharacters(in: CharacterSet.newlines)
//                error = string.components(separatedBy: "\n")
//            }
            
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
            wfItem.state = NSControl.StateValue.on
        }
            
        if outputEth == rightSettings {
            ethItem.state = NSControl.StateValue.on
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
    @IBAction func loadPandora(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "http://www.pandora.com")!)
    }
    
    @IBAction func loadSpotify(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "http://www.spotify.com")!)
    }
    
    @IBAction func loadNetflix(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "http://www.netflix.com")!)
    }
    @IBOutlet weak var wfItem: NSMenuItem!
    @IBOutlet weak var ethItem: NSMenuItem!

    
    // Actions with menubar items
    @IBAction func menuEth(_ sender: NSMenuItem) {
        let eth = Process()
        eth.launchPath = "/usr/sbin/networksetup"
        
        if(sender.state == NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.off
            eth.arguments = ["-setdnsservers", "USB Ethernet", "Empty"]
            let iconOff = NSImage(named: NSImage.Name(rawValue: "statusIconOff"))
            statusItem.image = iconOff
        }
        else {
            sender.state = NSControl.StateValue.on
            eth.arguments = ["-setdnsservers", "USB Ethernet", "107.170.15.247", "77.88.8.8"]
            let iconOn = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
            statusItem.image = iconOn
        }
        
        eth.launch()
        eth.waitUntilExit()
    }
    
    
    @IBAction func menuWf(_ sender: NSMenuItem) {
        let wf = Process()
        wf.launchPath = "/usr/sbin/networksetup"
        
        if(sender.state == NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.off
            wf.arguments = ["-setdnsservers", "Wi-Fi", "Empty"]
            let iconOff = NSImage(named: NSImage.Name(rawValue: "statusIconOff"))
            statusItem.image = iconOff
        }
        else {
            sender.state = NSControl.StateValue.on
            wf.arguments = ["-setdnsservers", "Wi-Fi", "107.170.15.247", "77.88.8.8"]
            let iconOn = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
            statusItem.image = iconOn
            
        }
        
        wf.launch()
        wf.waitUntilExit()
    }


    @IBAction func menuAbout(_ sender: NSMenuItem) {
        aboutWindow.showWindow(nil)
    }
    
    
    @IBAction func menuExit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
}

