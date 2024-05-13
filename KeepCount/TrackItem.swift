//
//  TrackItem.swift
//  KeepCount
//
//  Created by Nishchay Karle on 5/12/24.
//


class TrackItem {
    private var title : String
    private var initialValue: Int
    private var count: Int
    private var countUp : Bool
    
    init(title: String, value: Int, countUp: Bool) {
        self.title = title + ": "
        self.initialValue = value
        self.count = value
        self.countUp = countUp
    }

    func updateCount() {
        if (self.countUp) {
            self.count += 1
        }
        
        else {
            if (self.count > 0) {
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
        if (self.countUp) {
            return "arrow.up"
        }
        return "arrow.down"
    }
    
    func reset() {
        self.count = self.initialValue
    }
}

