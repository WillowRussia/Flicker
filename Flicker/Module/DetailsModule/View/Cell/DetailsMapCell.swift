//
//  DetailsMapCell.swift
//  Flicker
//
//  Created by Илья Востров on 12.10.2024.
//

import UIKit
import MapKit

class DetailsMapCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseId: String = "DetailsMapCell"
    
    lazy var mapView: MKMapView = {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        return $0
    }(MKMapView(frame: bounds))
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
    }
    
    func configureCell(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta:
                                                                                            0.01, longitudeDelta: 0.01)), animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation (pin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
