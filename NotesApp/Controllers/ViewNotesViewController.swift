//
//  ContentView.swift
//  new
//
//  Created by MacStudent on 2020-01-23.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreLocation
class ViewNotesViewController:  UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCreationDate: UILabel!
    var items: [Note] = [];
    @IBOutlet weak var notesImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "Title: \(items[0].title)"
        lblCategory.text = "Category: \(items[0].noteCategory)"
        lblDescription.text = " \(items[0].noteText)"
        notesImage.image = UIImage(data:items[0].imageData)
        //let d = getDate()
        lblCreationDate.text = "Created on :   \(items[0].creationDate.formatDate())"  //needs to format date
        let location = CLLocation(latitude: items[0].latitude, longitude: items[0].longitude)

                let geocoder = CLGeocoder()
                var placemark: CLPlacemark?

                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                  if error != nil {
        //            print("something went horribly wrong")
                  }
                  if let placemarks = placemarks {
                    placemark = placemarks.first
                    DispatchQueue.main.async {
        //              self.locationTF.text = (placemark?.locality!)
                        self.lblCity.text = " City: \(placemark!.locality!)"

                    }
                }
            }
    }
//    func getDate() -> Date{
//            let date = items[0].creationDate;
//            let dateFormatter = DateFormatter()
//            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//            dateFormatter.locale = NSLocale.current
//            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss" //Specify your format that you want
//            let strDate = dateFormatter.string(from: date)
//            let d = dateFormatter.date(from: strDate)
//            return d!
//    }

    

}
extension Date
{
    func formatDate() -> String
    {
     
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM-dd, yyyy   HH:mm:ss"
        
        return dateFormatterPrint.string(from: self)
    }
    func formatShortDate() -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM-dd, yyyy"
        
        return dateFormatterPrint.string(from: self)
    }
}
