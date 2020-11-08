//
//  SightDetailVC.swift
//  weatherApp
//
//  Created by Баир Надцалов on 07.11.2020.
//

import UIKit
import MapKit

class SightDetailVC: UIViewController {

    var currentSight: Sights!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "name of sight"
        
        view.backgroundColor = .white
        
        configureView()
    }
    
    func configureView() {
        
        //set an imageView on top of the view
        let imageView = UIImageView(image: UIImage(named: "babr")) //set the name of image
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
        
        imageView.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .bottom)
        imageView.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        imageView.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/4)
        
        //set a labelView with sight name to the bottom edge of the imageView
        var sightNameLabel = UILabel()
        sightNameLabel.text = "Музей естественных наук"
        sightNameLabel.numberOfLines = 0
        
        //Wrapping occurs at word boundaries
        addLineBreakMode(label: &sightNameLabel)
        
        sightNameLabel.font = UIFont(name: "Arial-BoldMT", size: 36)
        view.addSubview(sightNameLabel)
        
        sightNameLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 20)
        sightNameLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        sightNameLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        //set a label with short description
        var descLabel = UILabel()
        descLabel.text = "dfdfdfdfd dfsfd sfdsfsd sfsdfsdf sdfsdfsdf sdfsdsdfdsf sdfsdf sfdsf sfdsf ss sfsdfs"
        descLabel.numberOfLines = 0
        
        addLineBreakMode(label: &descLabel)
        
        descLabel.font = UIFont(name: "arial", size: 18)
        view.addSubview(descLabel)
        
        descLabel.autoPinEdge(.top, to: .bottom, of: sightNameLabel, withOffset: 20)
        descLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        descLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        // set a label with full description
        var descFullLabel = UILabel()
        descFullLabel.text = """
        dfdfdfdfd dfsfd sfdsfsd sfsdfsdf sdfsdfsdf sdfsdsdfdsf sdfsdf sfdsf sfdsf ss sfsdfs \
        dfdfdfdfd dfsfd sfdsfsd sfsdfsdf sdfsdfsdf sdfsdsdfdsf sdfsdf sfdsf sfdsf ss sfsdfs \
        dfdfdfdfd dfsfd sfdsfsd sfsdfsdf sdfsdfsdf sdfsdsdfdsf sdfsdf sfdsf sfdsf ss sfsdfs \
        dfdfdfdfd dfsfd sfdsfsd sfsdfsdf sdfsdfsdf sdfsdsdfdsf sdfsdf sfdsf sfdsf ss sfsdfs
        """
        descFullLabel.numberOfLines = 0
        
        addLineBreakMode(label: &descFullLabel)
        
        descFullLabel.font = UIFont(name: "arial", size: 18)
        view.addSubview(descFullLabel)
        
        descFullLabel.autoPinEdge(.top, to: .bottom, of: descLabel, withOffset: 20)
        descFullLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        descFullLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        // set label "На карте"
        let onMapLabel = UILabel()
        onMapLabel.text = "На карте"
        onMapLabel.font = UIFont(name: "Arial-BoldMT", size: 32)
        view.addSubview(onMapLabel)
        
        onMapLabel.autoPinEdge(.top, to: .bottom, of: descFullLabel, withOffset: 40)
        onMapLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        onMapLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        //set mapView
        let mapView = MKMapView()
        mapView.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        mapView.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/4)
        view.addSubview(mapView)
        
        mapView.autoPinEdge(.top, to: .bottom, of: onMapLabel, withOffset: 20)
        mapView.autoPinEdge(toSuperviewSafeArea: .leading)
        mapView.autoPinEdge(toSuperviewSafeArea: .trailing)
        
        addAnnotation(mapView: mapView)
    }
    
    func addAnnotation(mapView: MKMapView) {
        
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.title = "sight name"
        
        let lat = 52.275995
        let lon = 104.286517
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addLineBreakMode(label: inout UILabel) {
        if let breakMode = NSLineBreakMode(rawValue: 0) {
            label.lineBreakMode = breakMode
        } else {
            print("fail adding line break mode")
        }
    }
    
}
