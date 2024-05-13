//
//  main.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/10/24.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
