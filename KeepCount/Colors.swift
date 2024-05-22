//
//  Colors.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/21/24.
//

import Cocoa

struct AppColors {
    static let colors: [String: NSColor] = [
        "black": .black,
        "white": .white,
        "red": NSColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), // Red
        "green": NSColor(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0), // Green
        "blue": NSColor(displayP3Red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), // Blue
        "yellow": NSColor(displayP3Red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), // Yellow (custom for contrast)
        "cyan": NSColor(displayP3Red: 0.0, green: 0.6, blue: 0.6, alpha: 1.0), // Darker Cyan
        "magenta": NSColor(displayP3Red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0), // Magenta
        "orange": NSColor(displayP3Red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0), // Orange
        "purple": NSColor(displayP3Red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0), // Darker Purple
        "teal": NSColor(displayP3Red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0), // Teal
        "pink": NSColor(displayP3Red: 1.0, green: 0.4, blue: 0.7, alpha: 1.0), // Pink
        "brown": NSColor(displayP3Red: 0.6, green: 0.3, blue: 0.0, alpha: 1.0), // Brown
        "olive": NSColor(displayP3Red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0), // Olive
        "lime": NSColor(displayP3Red: 0.75, green: 1.0, blue: 0.0, alpha: 1.0), // Lime
        "navy": NSColor(displayP3Red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0), // Navy
        "coral": NSColor(displayP3Red: 1.0, green: 0.5, blue: 0.31, alpha: 1.0), // Coral
        "gold": NSColor(displayP3Red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0), // Gold
        "silver": NSColor(displayP3Red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0), // Silver
        "bronze": NSColor(displayP3Red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0), // Bronze
        "turquoise": NSColor(displayP3Red: 0.25, green: 0.88, blue: 0.82, alpha: 1.0) // Turquoise
    ]

    static let colorNames: [String] = [
        "black",
        "white",
        "red",
        "green",
        "blue",
        "yellow",
        "cyan",
        "magenta",
        "orange",
        "purple",
        "teal",
        "pink",
        "brown",
        "olive",
        "lime",
        "navy",
        "coral",
        "gold",
        "silver",
        "bronze",
        "turquoise"
    ]
}

