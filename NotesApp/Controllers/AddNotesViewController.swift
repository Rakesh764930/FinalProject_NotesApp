//
//  ContentView.swift
//  new
//
//  Created by MacStudent on 2020-01-23.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData
import  CoreLocation


class AddNotesViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    var locationManager: CLLocationManager!
    var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    var lat: Double!
    var long: Double!
    var textString = String()
    var txtTitle = String()
    var txtnoteCategory = String()
    var categoryPickerData: [String] = [String]()
    var noteDate = Date()
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    @IBOutlet weak var txtAdd: UITextView!
    @IBOutlet weak var edtTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var btnSelectCategory: UIButton!
    

    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
            dataManager = appDelegate.persistentContainer.viewContext;
            categoryPickerData = ["General", "Work", "School", "Miscellenous", "Sports", "Others"]
            self.categoryPicker.delegate = self
            self.categoryPicker.dataSource = self

            categoryPicker.isHidden = true;

            txtCategory.text = "\(categoryPickerData[5])"
            txtCategory.isUserInteractionEnabled = false

            noteDate = getDate()
        //noteDate = Date()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {

            let location = locations.last! as CLLocation

            /* you can use these values*/
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print("\(lat) \n \(long)")
    //        print(self.lat as Any);
    //        print(self.long as Any);
    //        print(timestamp as Any);
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
                    //self.locationTF.text = ""

                }
            }
        }
        }
    @IBAction func btnSelectCategory(_ sender: Any) {
        self.categoryPicker.isHidden = false
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return categoryPickerData.count
       }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryPicker.isHidden = true;
        txtCategory.text = categoryPickerData[row]
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        textString = txtAdd.text
        txtTitle = edtTitle.text!
        txtnoteCategory = txtCategory.text!
       
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        if (txtTitle != "")
        {
            if(textString != "")
            {
                 newEntity.setValue(txtTitle, forKey: "title")
                 newEntity.setValue(textString, forKey: "text")
                newEntity.setValue(txtnoteCategory, forKey: "category")
                if !(imageData.isEmpty){
                    newEntity.setValue(imageData, forKey: "picture")
                }
                newEntity.setValue(noteDate, forKey: "creationDate")
                newEntity.setValue(lat, forKey: "latitude")
                newEntity.setValue(long, forKey: "longitude")
                
            }
            else
            {
                showAlert(alertCase: 2)
                
            }
        }
        else{
            showAlert(alertCase: 1)
            
        }
       
            
               do {
                   try context.save()
                   print("saved")
                self.navigationController?.popViewController(animated: true)
               } catch  {
           print("Failed")
               }
        
    }
    func showAlert(alertCase : Int) {
        switch alertCase {
        case 1:
            let alert = UIAlertController(title: "NoteApp", message: "Please add title of the note.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        case 2:
            let alert = UIAlertController(title: "NoteApp", message: "Please add description of the note.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        default:
            let alert = UIAlertController(title: "NoteApp", message: "Please add neccessary information of the note.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
          
      }
//    func getData()
//    {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject]
//            {
//                textString = data.value(forKey: "text") as! String
//                txtTitle = data.value(forKey: "title") as! String
//                txtnoteCategory = data.value(forKey: "category") as! String
//                //(score)
//            }
//        } catch  {
//            print("Failed")
//        }
//    }
    @IBAction func btnChooseImage(_ sender: Any) {
    let alert = UIAlertController(title: "NoteIt!", message: "Pick image from", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
          if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera;
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
    }))
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary;
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
              }
          
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               self.imageView.isHidden =  false
               self.imageView.image = image
              // self.RemovePhotoBTN.isHidden =  false
               self.btnAddImage.isHidden =  true
               imageData = image.pngData()!
           }
           self.dismiss(animated: true, completion: nil)
       }
    func getDate() -> Date{
        let date = Date();
           
        
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss" //Specify your format that you want
        
            let strDate = dateFormatter.string(from: date)
        let d = dateFormatter.date(from: strDate)
        return d!
    }
    
    } // end of class
    
    

