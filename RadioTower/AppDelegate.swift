//
//  AppDelegate.swift
//  RadioTower
//
//  Created by Alexander Bykov on 19.04.15.
//  Copyright (c) 2015 Alexander Bykov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    var aboutWindow: AboutWindow!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.menu = statusMenu
    }
    
    override func awakeFromNib() {
        
        // Set icons and enable support for dark theme
        let iconOn = NSImage(named: "statusIcon")
        let iconOff = NSImage(named: "statusIconOff")
        iconOn!.setTemplate(true)
        iconOff!.setTemplate(true)
        
        
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
        let outputWf = runCommand("/usr/sbin/networksetup", "-getdnsservers", "Wi-Fi").output
        let outputEth = runCommand("/usr/sbin/networksetup", "-getdnsservers", "USB Ethernet").output
        
        
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

