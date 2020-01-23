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
                                        let noteModal = Note();
                                        
                                        noteModal.title = item.value(forKey: "title") as! String
                                        noteModal.noteText = item.value(forKey: "text") as! String
                                    noteModal.latitude = item.value(forKey: "latitude") as! Double
                                    noteModal.longitude = item.value(forKey: "longitude") as! Double
                                    items.append(noteModal)
                                }
                            } catch {
    //                            print("Failed")
                            }
            
            for (index, i) in items.enumerated() {
            
    //            if (index == items.count-1){
                    print(index)
                    print(i.latitude)
                    print(i.longitude)
                    let location = CLLocation(latitude: i.latitude, longitude: i.longitude)
                    let myAnnotation = MKPointAnnotation()
                    myAnnotation.coordinate = location.coordinate
                    myAnnotation.title = " \(i.title) "
                    annonationCollection.append(myAnnotation);
                    self.mapView.addAnnotation(myAnnotation)
    //                mapView.showAnnotations(mapView.annotations, animated: true)
    //            }
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

}
