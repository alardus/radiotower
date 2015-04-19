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

    @IBOutlet weak var about: NSWindow!
    override var windowNibName : String! {
        return "AboutWindow"
    }
    
}
