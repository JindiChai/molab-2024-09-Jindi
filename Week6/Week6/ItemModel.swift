//
//  Item.swift
//

import Foundation

struct ItemModel : Identifiable, Codable {
    var id = UUID()
    var selectedTime:Int = 60
    var meditationCount: Int = 0
    var selectedBackground: String = "Default"
    
    mutating func setSelectedTime(newNum: Int){
        self.selectedTime = newNum
    }
}

