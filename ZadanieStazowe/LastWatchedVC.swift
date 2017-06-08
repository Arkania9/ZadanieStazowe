//
//  LastWatchedVC.swift
//  ZadanieStazowe
//
//  Created by Kamil Zajac on 08.06.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import RealmSwift

class LastWatchedVC: UIViewController {
    
    @IBOutlet weak var placesTableView: UITableView!
    
    var places: Results<Place>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Last watched places"
        let realm = try! Realm()
        places = realm.objects(Place.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lastWatchedSegue" {
            guard let destination = segue.destination as? DetailsVC else { return }
            guard let placeToSend = sender as? Place else { return }
            destination.place = placeToSend
        }
    }
    
}

extension LastWatchedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let counter = places?.count {
            return counter
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LastWatchedCell") as? LastWatchedCell {
            if let place = places?[indexPath.row] {
                cell.configureTableView(from: place)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let placeToSend = places?[indexPath.row] else { return }
        performSegue(withIdentifier: "lastWatchedSegue", sender: placeToSend)
    }
    
}
