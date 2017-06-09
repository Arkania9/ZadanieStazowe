//
//  ViewController.swift
//  ZadanieStazowe
//
//  Created by Kamil Zajac on 08.06.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class MapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = mapTitle
        getUserCurrentLocation()
    }
    
    func getUserCurrentLocation() {
        let locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        guard let location = locManager.location else { return }
        startDownloadingPlacesAndUpdatingMaps(from: location)
    }
    
    func startDownloadingPlacesAndUpdatingMaps(from location: CLLocation) {
        let service = APIService()
        service.getPlacesFromUser(location) { (result) in
            switch result {
            case .Success(let data):
                let places = self.createArrayOfPlacesFrom(data)
                self.showMapViewAndMarkersFrom(places)
            case .Error(let message):
                self.showAlertWith(title: errorTitle, and: message)
            }
        }
    }
    
    func showAlertWith(title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createArrayOfPlacesFrom(_ data: [[String: AnyObject]]) -> [Place] {
        let places = data.map { (jsonDictionary) -> Place in
            let id = jsonDictionary["id"] as? String ?? ""
            let avatar = jsonDictionary["avatar"] as? String ?? ""
            let latitude = jsonDictionary["lat"] as? Double ?? 0.0
            let longitude = jsonDictionary["lng"] as? Double ?? 0.0
            let name = jsonDictionary["name"] as? String ?? ""
            let newPlace = Place(id: id, avatar: avatar, latitude: latitude, longitude: longitude, name: name)
            return newPlace
        }
        return places
    }
    
    func showMapViewAndMarkersFrom(_ places: [Place]) {
        let camera = GMSCameraPosition.camera(withLatitude: places[0].latitude, longitude: places[0].longitude, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        for place in places {
            let marker = GMSMarker()
            marker.userData = place
            marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            marker.title = place.name
            marker.map = mapView
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mapToDetailsSegue {
            guard let detailsVC =  segue.destination as? DetailsVC else { return }
            guard let marker = sender as? GMSMarker else { return }
            guard let placeToSend = marker.userData as? Place else { return }
            detailsVC.place = placeToSend
            do {
                let realm = try Realm()
                try realm.write {
                    realm.create(Place.self, value: placeToSend, update: true)
                }
            } catch let error {
                self.showAlertWith(title: errorTitle, and: error.localizedDescription)
            }
        }
    }
}

extension MapVC: CLLocationManagerDelegate { }

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        performSegue(withIdentifier: mapToDetailsSegue, sender: marker)
        return false
    }
}
