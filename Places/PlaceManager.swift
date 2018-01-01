/*
 * Copyright (c) 2014 Razeware LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *  PlaceManager.swift
 *  Places
 *
 *  Created by Soheil Azarpour on 7/2/14.
 */

import UIKit
import CoreLocation

/** A manager to fetch data source and update asynchronously. */
class PlaceManager: NSObject {
  
  /** Designated class constructor. */
  class func sharedManager() -> PlaceManager! {
    let sharedInstance = PlaceManager()
    return sharedInstance
  }
  
  /** URL for the local resource JSON file. There is a default value for this, if not provided. */
  var localResourceFileURL = Bundle.main.url(forResource: "Places", withExtension: "json")
  
  /** Fetches places and returns an array of Place objects. */
  func fetchPlacesWithCompletion(_ completion: @escaping (_ places: [Place]) -> Void) {
    
    DispatchQueue.global().async {
      if let URL = self.localResourceFileURL {
        do {
          let data = try Data(contentsOf: URL, options: .mappedIfSafe)
          do {
            if let root: NSDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
              let processed: [Place] = self.processJSONRoot(root)
              DispatchQueue.main.async(execute: {
                completion(processed)
              })
            }
          } catch {
            print(error)
          }
        } catch {
          print(error)
        }
      }
    }
  }
  
  // MARK: Private
  
  func processJSONRoot(_ root: NSDictionary) -> [Place] {
    var placesObjects = [Place]()
    if let places: NSArray = root["places"] as? NSArray {
      for aPlace: Any in places {
        let placeDict: NSDictionary = aPlace as! NSDictionary
        let title: String = placeDict["title"] as! String
        let dateString: String = placeDict["date"] as! String
        let imageFile: String = placeDict["image"] as! String
        let location: NSDictionary = placeDict["location"] as! NSDictionary
        let latitude: NSNumber = location["latitude"] as! NSNumber
        let longitude: NSNumber = location["longitude"] as! NSNumber
        
        // Convert date string to date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        var date: Date? = dateFormatter.date(from: dateString)
        
        // Create location coordinate.
        let lat: CLLocationDegrees = latitude.doubleValue
        let lon: CLLocationDegrees = longitude.doubleValue
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        // Load image from bundle.
        let image = UIImage(named: imageFile)
        
        // Create a Place object.
        let place = Place(title: title, date: date, image: image, coordinate: locationCoordinate)
        
        placesObjects.append(place)
      }
      placesObjects.sorted(by: { (p1: Place, p2: Place) -> Bool in
        let result: ComparisonResult = p1.date!.compare(p2.date! as Date)
        return result == .orderedDescending
      })
    }
    return placesObjects
  }
}
