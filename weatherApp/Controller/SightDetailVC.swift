//
//  SightDetailVC.swift
//  weatherApp
//
//  Created by Баир Надцалов on 07.11.2020.
//

import UIKit
import MapKit
import PureLayout

class SightDetailVC: UIViewController {

    var currentSight: Sight!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentSight.name
        
        view.backgroundColor = .white
        
        configureView(with: currentSight)
    }
    
    func configureView(with sight: Sight) {
        
        //add scrollView for large descriptions
        let scrollView = UIScrollView()
        
        //MARK: Content size working wrong. FIX it later
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.7)
        view.addSubview(scrollView)
        
        scrollView.autoPinEdgesToSuperviewEdges()
        
        //set an imageView on top of the view
        let imageView = UIImageView(image: UIImage(named: sight.image))
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(imageView)
        
        imageView.autoPinEdge(.top, to: .top, of: scrollView)
        imageView.autoPinEdge(.leading, to: .leading, of: scrollView)
        imageView.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        imageView.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/4)
        
        //set a labelView with sight name to the bottom edge of the imageView
        let sightNameLabel = UILabel()
        sightNameLabel.text = sight.name
        sightNameLabel.numberOfLines = 0
        sightNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        sightNameLabel.font = UIFont(name: "Arial-BoldMT", size: 36)
        sightNameLabel.sizeToFit()
        scrollView.addSubview(sightNameLabel)
        
        sightNameLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 20)
        sightNameLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        sightNameLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        //set a label with short description
        let descLabel = UILabel()
        descLabel.text = sight.shortDescr
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        descLabel.font = UIFont(name: "arial", size: 18)
        descLabel.sizeToFit()
        scrollView.addSubview(descLabel)
        
        descLabel.autoPinEdge(.top, to: .bottom, of: sightNameLabel, withOffset: 20)
        descLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        descLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        // set a label with full description
        let descFullLabel = UILabel()
        descFullLabel.text = sight.fullDescr
        descFullLabel.numberOfLines = 0
        descFullLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        descFullLabel.font = UIFont(name: "arial", size: 18)
        descFullLabel.sizeToFit()
        
        scrollView.addSubview(descFullLabel)
        
        descFullLabel.autoPinEdge(.top, to: .bottom, of: descLabel, withOffset: 20)
        descFullLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        descFullLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        // set label "На карте"
        let onMapLabel = UILabel()
        onMapLabel.text = "На карте"
        onMapLabel.font = UIFont(name: "Arial-BoldMT", size: 32)
        onMapLabel.sizeToFit()
        scrollView.addSubview(onMapLabel)
        
        onMapLabel.autoPinEdge(.top, to: .bottom, of: descFullLabel, withOffset: 40)
        onMapLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        onMapLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        //set mapView
        let mapView = MKMapView()
        mapView.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        //mapView.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        mapView.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/4)
        scrollView.addSubview(mapView)
        
        mapView.autoPinEdge(.top, to: .bottom, of: onMapLabel, withOffset: 20)
        mapView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        mapView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        //create useful coordinates from string value
        let coord = sight.location
        let index = coord.firstIndex(of: " ") ?? coord.endIndex
        let latitude = coord[..<index]
        let longitude = coord[index..<coord.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)

        if let lat = Double(latitude),
           let lon = Double(longitude) {
            
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            addAnnotation(mapView: mapView, sightName: sight.name, at: location)
        }
    }
    
    func addAnnotation(mapView: MKMapView, sightName: String, at location: CLLocationCoordinate2D) {
        
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.title = sightName
        
        let lat = location.latitude
        let lon = location.longitude
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
