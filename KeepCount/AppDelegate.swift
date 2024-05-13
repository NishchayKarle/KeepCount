//
//  AppDelegate.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/10/24.
//

import Cocoa
import AppKit

func createImageFromNumber(label: String, count: Int, countUp: String) -> NSImage? {
    let arrowImage = NSImage(systemSymbolName: countUp, accessibilityDescription: nil)
    arrowImage?.isTemplate = true
    
    let text = "\(label)\(count)"
    let appearance = NSAppearance.current
    let textColor = appearance?.name == .aqua ? NSColor.black : NSColor.white
    let attributes = [
        NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
        NSAttributedString.Key.foregroundColor: textColor
    ]
    
    let textSize = text.size(withAttributes: attributes)
    let arrowSize = arrowImage?.size ?? .zero
    let totalWidth = textSize.width + arrowSize.width
    let totalHeight = max(textSize.height, arrowSize.height)
    
    let image = NSImage(size: NSMakeSize(totalWidth, totalHeight))
    image.lockFocus()
    text.draw(at: NSPoint(x: 0, y: (totalHeight - textSize.height) / 2), withAttributes: attributes)
    arrowImage?.draw(at: NSPoint(x: textSize.width, y: (totalHeight - arrowSize.height) / 2), from: .zero, operation: .sourceOver, fraction: 0.5)
    image.unlockFocus()
    
    return image
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItems: [NSStatusItem] = []
    var trackers: [TrackItem] = []
    var configWindowController: TrackerConfigWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addNewTrackerAction()
    }

    @objc func addNewTrackerAction() {
        showConfigWindow()
    }

    func addNewTracker(title: String, value: Int, countUp: Bool) {
        let newItem = TrackItem(title: title, value: value, countUp: countUp)
        trackers.append(newItem)
        
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = setImage(item: newItem)
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
        configWindowController?.completionHandler = { [weak self] title, value, countUp in
            self?.addNewTracker(title: title, value: value, countUp: countUp)
        }
        configWindowController?.window?.center()
        configWindowController?.showWindow(nil)
    }

    func constructMenu(for item: TrackItem?) -> NSMenu {
        let menu = NSMenu()
        let resetItem = NSMenuItem(title: "Reset Counter", action: #selector(resetItem(_:)), keyEquivalent: "r")
        resetItem.representedObject = item
        menu.addItem(resetItem)
        
        let closeItem = NSMenuItem(title: "Close Counter", action: #selector(closeTracker(_:)), keyEquivalent: "c")
        closeItem.representedObject = item
        menu.addItem(closeItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Add New Counter", action: #selector(addNewTrackerAction), keyEquivalent: "n"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        return menu
    }

    @objc func updateCount(_ sender: AnyObject) {
        if let button = sender as? NSStatusBarButton,
           let index = statusItems.firstIndex(where: { $0.button === button }),
           index < trackers.count {
            let tracker = trackers[index]
            tracker.updateCount()
            button.image = setImage(item: tracker)
        }
    }

    @objc func resetItem(_ sender: NSMenuItem) {
        if let tracker = sender.representedObject as? TrackItem,
           let index = trackers.firstIndex(where: { $0 === tracker }),
           let button = statusItems[index].button {
            tracker.reset()
            button.image = setImage(item: tracker)
        }
    }

    @objc func closeTracker(_ sender: NSMenuItem) {
        if let tracker = sender.representedObject as? TrackItem,
           let index = trackers.firstIndex(where: { $0 === tracker }) {
            trackers.remove(at: index)
            let statusItem = statusItems.remove(at: index)
            NSStatusBar.system.removeStatusItem(statusItem)
        }
    }

    func setImage(item: TrackItem) -> NSImage? {
        return createImageFromNumber(label: item.getTitle(), count: item.getCount(), countUp: item.upDown())
    }

    func applicationWillTerminate(_ notification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
}
