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
        let iconOn = NSImage(named: "statusIcon")
        let iconOff = NSImage(named: "statusIconOff")
        iconOn!.setTemplate(true)
        iconOff!.setTemplate(true)
        
        statusItem.image = iconOff
        statusItem.menu = statusMenu
    }

    override func awakeFromNib() {
        aboutWindow = AboutWindow()
    }
    
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

