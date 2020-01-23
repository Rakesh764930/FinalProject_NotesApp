//
//  ContentView.swift
//  new
//
//  Created by MacStudent on 2020-01-23.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
class MapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    var items: [Note] = [];
    var annonationCollection = [MKAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        dataManager = appDelegate.persistentContainer.viewContext;
        fetchData();
    }
    func fetchData() {
                 let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes");
                            do {
                                let result = try dataManager.fetch(request);
                                print(result.count)
                                    listArray = result as! [NSManagedObject]
                                    print(listArray.count)
                                    for item in listArray {
                                        let noteModel = Note();
                                        
                                        noteModel.title = item.value(forKey: "title") as! String
                                        noteModel.noteText = item.value(forKey: "text") as! String
                                    noteModel.latitude = item.value(forKey: "latitude") as! Double
                                    noteModel.longitude = item.value(forKey: "longitude") as! Double
                                    items.append(noteModel)
                                }
                            } catch {
                           print(error)
                            }
            
            for (index, i) in items.enumerated() {
            
    
                    print(index)
                    print(i.latitude)
                    print(i.longitude)
                    let location = CLLocation(latitude: i.latitude, longitude: i.longitude)
                    let myAnnotation = MKPointAnnotation()
                    myAnnotation.coordinate = location.coordinate
                    myAnnotation.title = " \(i.title) "
                    annonationCollection.append(myAnnotation);
                    self.mapView.addAnnotation(myAnnotation)
    
            }
        }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
  
           let identifier = "marker"
           var view: MKMarkerAnnotationView
        
           if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
             as? MKMarkerAnnotationView {

            dequeuedView.annotation = annonationCollection as! MKAnnotation;
             view = dequeuedView
           } else {
           
             view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
             view.canShowCallout = true
             view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
           }
           return view
         }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation , let title = annotation.title else {
            return
        }
     for (index, i) in items.enumerated() {
              let location = CLLocation(latitude: i.latitude, longitude: i.longitude)
              let geocoder = CLGeocoder()
                         var placemark: CLPlacemark?

                         geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                           if error != nil {
              
                           }
                           if let placemarks = placemarks {
                             placemark = placemarks.first
                             DispatchQueue.main.async {
               
                              let alertController = UIAlertController(title: "This note was created by \(i.title) at\(placemark?.locality)", message: " You are in \(placemark?.locality)", preferredStyle: .alert)
                              let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                              alertController.addAction(cancelAction)
                              self.present(alertController, animated: true, completion: nil)
                              }
                                                   }
                     }
              
      }
    }
}
