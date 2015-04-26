//
//  AboutWindow.swift
//  RadioTower
//
//  Created by Alexander Bykov on 19.04.15.
//  Copyright (c) 2015 Alexander Bykov. All rights reserved.
//

import Cocoa

class AboutWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override func awakeFromNib() {
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String
//        let name = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String
        aboutVersion.stringValue = "Version " + version! + " (" + build! + ")"
    }

    @IBOutlet weak var about: NSWindow!
    override var windowNibName : String! {
        return "AboutWindow"
    }
    
    @IBOutlet weak var aboutVersion: NSTextField!

}
