//
//  AppDelegate.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/10/24.
//

import Cocoa
import AppKit

func createImageFromNumber(label: String, count: Int, countUp: String, textColor: NSColor) -> NSImage? {
    guard let arrowImage = NSImage(systemSymbolName: countUp, accessibilityDescription: nil) else {
        return nil
    }
    arrowImage.isTemplate = true

    let text = "\(label)\(count)"
    
    let attributes = [
        NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
        NSAttributedString.Key.foregroundColor: textColor
    ]
    
    let textSize = text.size(withAttributes: attributes)
    let arrowSize = arrowImage.size
    let totalWidth = textSize.width + arrowSize.width
    let totalHeight = max(textSize.height, arrowSize.height)
    
    let image = NSImage(size: NSMakeSize(totalWidth, totalHeight))
    image.lockFocus()
    
    // Draw the text
    text.draw(at: NSPoint(x: 0, y: (totalHeight - textSize.height) / 2), withAttributes: attributes)
    
    // Create a tinted version of the arrow image
    if let tintedArrowImage = arrowImage.copy() as? NSImage {
        tintedArrowImage.lockFocus()
        textColor.set()
        let imageRect = NSRect(origin: .zero, size: arrowSize)
        imageRect.fill(using: .sourceAtop)
        tintedArrowImage.unlockFocus()
        
        // Draw the tinted arrow image
        tintedArrowImage.draw(at: NSPoint(x: textSize.width, y: (totalHeight - arrowSize.height) / 2), from: .zero, operation: .sourceOver, fraction: 1.0)
    }
    
    image.unlockFocus()
    
    return image
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItems: [NSStatusItem] = []
    var trackers: [TrackItem] = []
    var configWindowController: TrackerConfigWindowController?
    var mainWindow: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMainMenu()
        setupMainWindow()
        addNewTrackerAction()
        
        // Observe wallpaper changes
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(wallpaperDidChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
    }

    func setupMainMenu() {
        let mainMenu = NSMenu()

        // Application menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        let quitMenuItem = NSMenuItem(title: "Quit KeepCount", action: #selector(quitApp), keyEquivalent: "q")
        appMenu.addItem(quitMenuItem)
        appMenuItem.submenu = appMenu

        NSApp.mainMenu = mainMenu
    }

    func setupMainWindow() {
        mainWindow = NSWindow(contentRect: NSMakeRect(0, 0, 200, 200),
                              styleMask: [.titled, .closable, .miniaturizable, .resizable],
                              backing: .buffered, defer: false)
        mainWindow?.isReleasedWhenClosed = false
        mainWindow?.makeKeyAndOrderFront(nil)
        mainWindow?.orderOut(nil) // Hide the window initially
    }

    @objc func addNewTrackerAction() {
        showConfigWindow()
    }

    func addNewTracker(title: String, value: Int, countUp: Bool, color: NSColor) {
        let newItem = TrackItem(title: title, value: value, countUp: countUp, color: color)
        trackers.append(newItem)
        
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = setImage(item: newItem, color: color)
            let customView = CustomStatusItemView(frame: button.bounds)
            customView.menuProvider = { [weak self, weak newItem] in
                self?.constructMenu(for: newItem) ?? NSMenu()
            }
            button.addSubview(customView)
            button.action = #selector(updateCount(_:))
            button.target = self
        }
        statusItems.append(statusItem)
    }

    func showConfigWindow() {
        configWindowController = TrackerConfigWindowController()
        configWindowController?.completionHandler = { [weak self] title, value, countUp, color in
            self?.addNewTracker(title: title, value: value, countUp: countUp, color: color)
        }
        if let window = configWindowController?.window {
            window.level = .floating  // Set the window level to floating to ensure it appears in front
            configWindowController?.showWindow(nil)
            window.center()  // Center the window on the screen
        }
    }

    func constructMenu(for item: TrackItem?) -> NSMenu {
        let menu = NSMenu()
        let changeColor = NSMenuItem(title: "Change Color", action: #selector(updateColor(_:)), keyEquivalent: "L")
        changeColor.representedObject = item
        menu.addItem(changeColor)
        
        let resetItem = NSMenuItem(title: "Reset Counter", action: #selector(resetItem(_:)), keyEquivalent: "r")
        resetItem.representedObject = item
        menu.addItem(resetItem)
        
        let closeItem = NSMenuItem(title: "Close Counter", action: #selector(closeTracker(_:)), keyEquivalent: "c")
        closeItem.representedObject = item
        menu.addItem(closeItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Add New Counter", action: #selector(addNewTrackerAction), keyEquivalent: "n"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        return menu
    }

    @objc func activateApp() {
            NSApp.activate(ignoringOtherApps: false)
    }

    @objc func updateCount(_ sender: AnyObject) {
        activateApp()
        if let button = sender as? NSStatusBarButton,
           let index = statusItems.firstIndex(where: { $0.button === button }),
           index < trackers.count {
            let tracker = trackers[index]
            tracker.updateCount()
            button.image = setImage(item: tracker, color: tracker.getColor())
        }
    }
    
    @objc func updateColor(_ sender: AnyObject) {
        activateApp()
        // Change Color
        if let tracker = sender.representedObject as? TrackItem,
           let index = trackers.firstIndex(where: { $0 === tracker }),
           let button = statusItems[index].button {
            let color = tracker.updateColor()
            button.image = setImage(item: tracker, color: color)
        }
    }

    @objc func resetItem(_ sender: NSMenuItem) {
        activateApp()
        if let tracker = sender.representedObject as? TrackItem,
           let index = trackers.firstIndex(where: { $0 === tracker }),
           let button = statusItems[index].button {
            tracker.reset()
            button.image = setImage(item: tracker, color: tracker.getColor())
        }
    }

    @objc func closeTracker(_ sender: NSMenuItem) {
        activateApp()
        if let tracker = sender.representedObject as? TrackItem,
           let index = trackers.firstIndex(where: { $0 === tracker }) {
            trackers.remove(at: index)
            let statusItem = statusItems.remove(at: index)
            NSStatusBar.system.removeStatusItem(statusItem)
            
            // Check if all trackers are closed and quit the app if so
            if allCountersClosed() {
                quitApp()
            }
        }
    }
    
    @objc func allCountersClosed() -> Bool {
        return trackers.isEmpty
    }
    
    @objc func closeConfigWindow() {
        if allCountersClosed() {
            quitApp()
        }
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    func setImage(item: TrackItem, color: NSColor) -> NSImage? {
        return createImageFromNumber(label: item.getTitle(), count: item.getCount(), countUp: item.upDown(), textColor: color)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
    
    @objc func wallpaperDidChange(notification: NSNotification) {
    }
}
