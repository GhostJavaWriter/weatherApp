//
//  CityWeatherVC.swift
//  weatherApp
//
//  Created by Баир Надцалов on 01.11.2020.
//

import UIKit
import MapKit

class CityWeatherVC: UIViewController {
    
    var chosenCity: FirstModel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sightButtonOutlet: UIButton!
    
    var sights = [Sight]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Погода в городе"
        navigationItem.largeTitleDisplayMode = .never
        
        sightButtonOutlet.isEnabled = false
        
        cityNameLabel.text = chosenCity.name
        cityNameLabel.textAlignment = .center
        
        configureMapView()
        
        let lat = chosenCity.coord.lat
        let lon = chosenCity.coord.lon
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        getWeather(at: location) { (model) in
            
            DispatchQueue.main.async {
                self.configureScrollView(with: model)
            }
        }
        
        if !sights.isEmpty {
            sightButtonOutlet.isEnabled = true
            
            for (index, item) in sights.enumerated().reversed() {
                if item.relationTo != chosenCity.name.lowercased() {
                    sights.remove(at: index)
                }
            }
        }
        
    }
    
    func configureScrollView(with model: Model) {
        
        let scrollSize = scrollView.visibleSize
        
        let oneDayViewCount = model.hourly.count
        
        var previous: DayView?
        
        for index in 0..<oneDayViewCount {
            let dayView = DayView(frame: CGRect.zero, size: scrollSize, model: model.hourly[index], timeOffset: model.timezone_offset)
            scrollView.addSubview(dayView)
            if let previous = previous {
                dayView.autoPinEdge(.left, to: .right, of: previous, withOffset: 10)
            } else {
                dayView.autoPinEdge(.left, to: .left, of: scrollView)
            }
            previous = dayView
        }
        
        let scrollContenSizeWidth = CGFloat(150 * oneDayViewCount + 10 * (oneDayViewCount - 1))

        scrollView.contentSize = CGSize(width: scrollContenSizeWidth, height: scrollView.visibleSize.height)
        
    }
    
    func configureMapView() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.title = chosenCity?.name
        let lat = chosenCity.coord.lat
        let lon = chosenCity.coord.lon
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func getWeather(at location: CLLocationCoordinate2D, result: @escaping ((Model) -> ())){
        
        let apiKey = "707f9337bf1698a7919d6186e92f3612"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/onecall"
        urlComponents.queryItems = [URLQueryItem(name: "lat", value: "\(location.latitude)"),
                                    URLQueryItem(name: "lon", value: "\(location.longitude)"),
                                    URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "exlude", value: "current,minutely,daily,alerts"),
                                    URLQueryItem(name: "units", value: "metric")]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                if data != nil {
                    if let decoderModel = try? decoder.decode(Model.self, from: data!) {
                        result(decoderModel)
                    } else {
                        print("decode fail")
                    }
                }
            } else {
                print(error as Any)
            }
        }.resume()
    }
    
    @IBAction func sightsButton(_ sender: UIButton) {
        
        let vc = CitySightsVC()
        
        vc.sights = sights
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
