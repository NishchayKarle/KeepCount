//
//  ViewController.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/10/24.
//

import Cocoa

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}


class CustomStatusItemView: NSView {
    // Instead of keeping a menu property, you can fetch or build it dynamically
    var menuProvider: (() -> NSMenu)?

    override func rightMouseDown(with event: NSEvent) {
        // Dynamically fetch or create the menu
        if let menu = menuProvider?() {
            NSMenu.popUpContextMenu(menu, with: event, for: self)
        }
    }
}

class TrackerConfigWindowController: NSWindowController, NSWindowDelegate {
    var titleTextField: NSTextField!
    var valueTextField: NSTextField!
    var valueStepper: NSStepper!
    var countUpPopUp: NSPopUpButton!
    var completionHandler: ((String, Int, Bool) -> Void)?

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 350, height: 230),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.isMovableByWindowBackground = true
        self.init(window: window)
        self.window?.title = "New Counter Configuration"
        self.window?.delegate = self
        setupUI()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window {
            window.delegate = self
        } else {
//            print("Window is not loaded.")
        }
    }

    func windowWillClose(_ notification: Notification) {
        print("Window will close.")
        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.closeConfigWindow()
        }
    }

    func setupUI() {
        guard let contentView = window?.contentView else { return }

        // Label for Title
        let titleLabel = createLabel(with: "Title:")
        titleLabel.frame = NSRect(x: 20, y: 150, width: 120, height: 20)
        contentView.addSubview(titleLabel)

        // Title TextField
        titleTextField = createTextField(placeholder: "Enter title", frame: NSRect(x: 150, y: 150, width: 180, height: 20))
        contentView.addSubview(titleTextField)

        // Label for Initial Value (Start Count From)
        let valueLabel = createLabel(with: "Start Count From:")
        valueLabel.frame = NSRect(x: 20, y: 110, width: 120, height: 20)
        contentView.addSubview(valueLabel)

        // Value TextField and Stepper
        valueTextField = createTextField(placeholder: "0", frame: NSRect(x: 150, y: 110, width: 50, height: 20))
        contentView.addSubview(valueTextField)

        valueStepper = NSStepper(frame: NSRect(x: 210, y: 110, width: 20, height: 20))
        valueStepper.minValue = 0
        valueStepper.maxValue = Double(Int.max)
        valueStepper.increment = 1
        valueStepper.valueWraps = false
        valueStepper.autorepeat = true
        valueStepper.target = self
        valueStepper.action = #selector(stepperValueChanged(_:))
        contentView.addSubview(valueStepper)

        // Label for Count Up
        let countUpLabel = createLabel(with: "Count Up:")
        countUpLabel.frame = NSRect(x: 20, y: 70, width: 120, height: 20)
        contentView.addSubview(countUpLabel)

        // Count Up Pop-Up Button
        countUpPopUp = NSPopUpButton(frame: NSRect(x: 150, y: 70, width: 100, height: 20), pullsDown: false)
        countUpPopUp.addItems(withTitles: ["Yes", "No"])
        contentView.addSubview(countUpPopUp)

        // Submit Button (Add)
        let submitButton = NSButton(title: "Add", target: self, action: #selector(submitAction))
        submitButton.frame = NSRect(x: 125, y: 20, width: 100, height: 30)
        submitButton.bezelStyle = .rounded
        submitButton.font = NSFont.systemFont(ofSize: 14, weight: .medium)
        contentView.addSubview(submitButton)
    }

    private func createLabel(with text: String) -> NSTextField {
        let label = NSTextField(labelWithString: text)
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.font = NSFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }

    private func createTextField(placeholder: String, frame: NSRect) -> NSTextField {
        let textField = NSTextField(frame: frame)
        textField.placeholderString = placeholder
        textField.font = NSFont.systemFont(ofSize: 14)
        textField.isBezeled = true
        textField.bezelStyle = .roundedBezel
        return textField
    }

    @objc private func submitAction() {
        let title = titleTextField.stringValue.isEmpty ? "New Counter" : titleTextField.stringValue
        let value = Int(valueTextField.stringValue) ?? 0
        let countUp = countUpPopUp.indexOfSelectedItem == 0  // Yes = 0, No = 1
        completionHandler?(title, value, countUp)
        self.window?.close()
    }

    @objc private func stepperValueChanged(_ sender: NSStepper) {
        valueTextField.stringValue = String(sender.integerValue)
    }
}
