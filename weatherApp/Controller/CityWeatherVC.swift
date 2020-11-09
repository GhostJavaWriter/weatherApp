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
    var sights = [Sight]()
    var weather: Model?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tomLabel: UILabel!
    @IBOutlet weak var todayColView: UICollectionView!
    @IBOutlet weak var tomorrowColView: UICollectionView!
    @IBOutlet weak var sightsBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Погода в городе"
        navigationItem.largeTitleDisplayMode = .never
        
        //turn off button before counting sights in current city
        sightsBtnOutlet.isEnabled = false
        sightsBtnOutlet.layer.cornerRadius = 15
        
        configureMapView()
        
        cityNameLabel.text = chosenCity.name
        
        let date = Date()
        let calendar = Calendar.current
        
        //getting current date
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        todayLabel.text = "Сегодня, \(day) \(month) \(year)"
        
        //getting current date plus 1 day
        var dateComponent = DateComponents()
        dateComponent.day = 1
        if let nextDate = Calendar.current.date(byAdding: dateComponent, to: date) {
            let newDay = calendar.component(.day, from: nextDate)
            let newMonth = calendar.component(.month, from: nextDate)
            let newYear = calendar.component(.year, from: nextDate)
            tomLabel.text = "Завтра, \(newDay) \(newMonth) \(newYear)"
        } else {
            tomLabel.text = "Завтра, 00 00 0000"
        }
        
        let lat = chosenCity.coord.lat
        let lon = chosenCity.coord.lon
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        getWeather(at: location) { (model) in
            
            DispatchQueue.main.async {
                self.weather = model
            }
        }
        
        if !sights.isEmpty {
            sightsBtnOutlet.isEnabled = true
            
            for (index, item) in sights.enumerated().reversed() {
                if item.relationTo != chosenCity.name.lowercased() {
                    sights.remove(at: index)
                }
            }
        }
        
    }
//    func configureScrollView(with model: Model) {
//        let oneDayViewCount = model.hourly.count
//        for index in 0..<oneDayViewCount {
//            let dayView = DayView(frame: CGRect.zero, size: scrollSize, model: model.hourly[index], timeOffset: model.timezone_offset)
    
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
    
    @IBAction func sightsBtnAction(_ sender: Any) {
        
        let vc = CitySightsVC()
        
        vc.sights = sights
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CityWeatherVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == todayColView {
            
            return 10
        }
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == todayColView {
            let cell = todayColView.dequeueReusableCell(withReuseIdentifier: "today", for: indexPath) as! TodayColViewCell
            
            
            
            return cell
        }
        
        let cell = tomorrowColView.dequeueReusableCell(withReuseIdentifier: "tomorrow", for: indexPath) as! TomorrowColViewCell
        
        cell.backgroundColor = .cyan
        
        return cell
    }
}
