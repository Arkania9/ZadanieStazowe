//
//  LastWatchedCell.swift
//  ZadanieStazowe
//
//  Created by Kamil Zajac on 08.06.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class LastWatchedCell: UITableViewCell {

    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    func configureTableView(from place: Place) {
        placeNameLbl.text = place.name
        latitudeLbl.text = "\(place.latitude)"
        longitudeLbl.text = "\(place.longitude)"
    }

}
