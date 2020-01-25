//
//  DateFormatter.swift
//  NotesApp
//
//  Created by MacStudent on 2020-01-23.
//  Copyright © 2020 charanpreet kaur. All rights reserved.
//

import Foundation
extension Date
{
    func formatTime() -> String
    {
     
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = " HH:mm:ss"
        
        return dateFormatterPrint.string(from: self)
    }
    func formatShortDate() -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM-dd, yyyy"
        
        return dateFormatterPrint.string(from: self)
    }
}
