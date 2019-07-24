//
//  Utilities.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/24/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit
import MapKit

// MARK: Helper Extensions
extension UIViewController {
    func extShowAlertOK(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.dismiss(animated: true, completion: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


}

extension UIViewController {
    func extDateToString(date: Date) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "dd.MM.yyyy"
        let srtDate = dF.string(from: date)
        return srtDate
    }

}

extension UIViewController {
    func cutNameBrackets(name: String) -> String {
        let firstBracket = name.firstIndex(of: "(") ?? name.endIndex
        let cutName = String(name[..<firstBracket])
        return cutName
    }
    
}

extension MKMapView {
    func extZoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: true)
    }
}



