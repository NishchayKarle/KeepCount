//
//  TrackItem.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/12/24.
//

import Cocoa

class TrackItem {
    private var title: String
    private var initialValue: Int
    private var count: Int
    private var countUp: Bool
    private var color: NSColor

    init(title: String, value: Int, countUp: Bool, color: NSColor) {
        self.title = title + ": "
        self.initialValue = value
        self.count = value
        self.countUp = countUp
        self.color = color
    }

    func updateCount() {
        if self.countUp {
            self.count += 1
        } else {
            if self.count > 0 {
                self.count -= 1
            }
        }
    }

    func getTitle() -> String {
        return self.title
    }

    func getCount() -> Int {
        return self.count
    }

    func upDown() -> String {
        if self.countUp {
            return "arrow.up"
        }
        return "arrow.down"
    }

    func reset() {
        self.count = self.initialValue
    }

    func getColor() -> NSColor {
        return self.color
    }

    func updateColor() -> NSColor {
        if let currentIndex = AppColors.colorNames.firstIndex(of: self.colorName()) {
            let nextIndex = (currentIndex + 1) % AppColors.colorNames.count
            let nextColorName = AppColors.colorNames[nextIndex]
            self.color = AppColors.colors[nextColorName]!
        } else {
            self.color = AppColors.colors["black"]!
        }
        return self.color
    }

    private func colorName() -> String {
        return AppColors.colors.first { $0.value == self.color }?.key ?? "black"
    }
}
