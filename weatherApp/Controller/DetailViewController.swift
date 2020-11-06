//
//  DetailViewController.swift
//  weatherApp
//
//  Created by Баир Надцалов on 01.11.2020.
//

import UIKit
import MapKit
import CoreData

class DetailViewController: UIViewController {
    
    var chosenCity: FirstModel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var container: NSPersistentContainer!
    
    var sights = [Sights]()
    var appropriateSights = [Sights]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Погода в городе"
        navigationItem.largeTitleDisplayMode = .never
        
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
        
        container = NSPersistentContainer(name: "weatherApp")
        
        container.loadPersistentStores { (storeDescription, error) in
            
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        DispatchQueue.global().async {
            guard let sightsList = self.getLocalData(forName: "sights") else { return }
            
            DispatchQueue.main.async {
                for object in sightsList {
                    
                    let sight = Sights(context: self.container.viewContext)
                    self.configure(sight: sight, with: object)
                }
                self.saveContext()
            }
        }
        loadSavedData()
        
        // set sights to appropriate city
        for object in sights {
            if object.relationTo == chosenCity.name.lowercased() {
                appropriateSights.append(object)
            }
        }
        
    }
    
    func loadSavedData() {
        let request = Sights.createFetchRequest()
        do {
            sights = try container.viewContext.fetch(request)
            print("got sights: ", sights.count)
        } catch {
            print("fetch failed")
        }
    }
    
    func configure(sight: Sights, with object: SightModel) {
        
        sight.name = object.name
        sight.relationTo = object.relationTo
        sight.image = object.image ?? "no image"
        sight.shortDescr = object.shortDescr ?? "no description"
        sight.fullDescr = object.fullDescr ?? "no description"
        sight.location = object.location ?? "no location"
        
    }
    
    func getLocalData(forName name: String) -> [SightModel]? {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode([SightModel].self, from: jsonData)
                return decodedData
            }
        } catch {
            print("error in get local data \(error)")
        }
        return nil
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                print("core data saved")
            } catch {
                print("An error occurred while saving: \(error)")
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
        
        let vc = SightViewController()
        
        vc.sights = appropriateSights
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
