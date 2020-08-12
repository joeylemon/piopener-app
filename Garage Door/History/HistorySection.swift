//
//  HistorySection.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/30/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation

class HistorySection : Codable {
    
    //MARK: Properties
    var Title: String
    var Entries: [HistoryEntry]

    //MARK: Initialization
    init(Title: String, Entries: [HistoryEntry]) {
        self.Title = Title
        self.Entries = Entries
    }
    
}
