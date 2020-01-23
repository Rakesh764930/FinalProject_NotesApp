//
//  ContentView.swift
//  new
//
//  Created by MacStudent on 2020-01-23.
//  Copyright © 2020 MacStudent. All rights reserved.
//
import Foundation
class Note {
    var noteText: String
    var title: String
    var noteCategory: String
    var imageData: Data
    var latitude : Double
    var longitude : Double
    var creationDate: Date
    init() {
        self.noteText = String()
        self.title = String()
        self.noteCategory = String()
        self.imageData = Data()
        self.latitude = Double()
        self.longitude = Double()
        self.creationDate = Date()
    }
}
