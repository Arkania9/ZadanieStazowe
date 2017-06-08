//
//  DetailsVC.swift
//  ZadanieStazowe
//
//  Created by Kamil Zajac on 08.06.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsVC: UIViewController {

    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var placeImgView: UIImageView!
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        DispatchQueue.main.async {
            self.placeNameLbl.text = self.place?.name
            self.longitudeLbl.text = "\(self.place?.longitude ?? 0.0)"
            self.latitudeLbl.text = "\(self.place?.latitude ?? 0.0)"
            guard let url = self.place?.avatar else { return }
            self.placeImgView.loadImageFromURLString(url)
        }
    }
    
}
