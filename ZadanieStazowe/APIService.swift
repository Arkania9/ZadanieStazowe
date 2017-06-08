//
//  APIService.swift
//  ZadanieStazowe
//
//  Created by Kamil Zajac on 08.06.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import GoogleMaps

class APIService: NSObject {
    
    struct APIUrl {
        static let placeUrlOne = "https://interview-ready4s.herokuapp.com/geo?lat="
        static let placeUrlTwo = "&lng="
    }
    
    func getPlacesFromUser(_ location: CLLocation, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let mainUrl = "\(APIUrl.placeUrlOne)\(latitude)\(APIUrl.placeUrlTwo)\(longitude)"
        guard let url = URL(string: mainUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error!.localizedDescription)) }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
    
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
