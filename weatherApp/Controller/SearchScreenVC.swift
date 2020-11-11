//
//  SearchScreenVC.swift
//  weatherApp
//
//  Created by Баир Надцалов on 27.10.2020.
//

import UIKit
import CoreData

class SearchScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cities = [CityModel]()
    private var filteredCities = [CityModel]()
    
    private var cityObjects = [Sight]()
    private var sights = [Sight]()
    
    private var container: NSPersistentContainer!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false //make clickable
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //load cities
        getCitiesFromFile(fileName: "cities")
        
        container = NSPersistentContainer(name: "weatherApp")
        
        container.loadPersistentStores { (storeDescription, error) in
            
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        DispatchQueue.global().async {
            guard let sightsList = self.getSightsFromFile(fileName: "sights") else { return }
            
            DispatchQueue.main.async {
                for object in sightsList {
                    
                    let sight = Sight(context: self.container.viewContext)
                    self.configure(sight: sight, with: object)
                }
                self.saveContext()
                self.loadSavedData()
            }
        }
        loadSavedData()
    }
    
    func loadSavedData() {
        let request = Sight.createFetchRequest()
        do {
            sights = try container.viewContext.fetch(request)
            print("Sights loaded: ", sights.count)
            
        } catch {
            print("fetch failed")
        }
    }
    
    func configure(sight: Sight, with object: SightModel) {
        
        sight.name = object.name
        sight.relationTo = object.relationTo
        sight.image = object.image ?? "no image"
        sight.shortDescr = object.shortDescr ?? "no description"
        sight.fullDescr = object.fullDescr ?? "no description"
        sight.location = object.location ?? "no location"
        
    }
    
    func getSightsFromFile(fileName name: String) -> [SightModel]? {
        
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
    
    func getCitiesFromFile(fileName name: String) {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    
                let decodedData = try JSONDecoder().decode([CityModel].self, from: jsonData)
                cities = decodedData
            }
        } catch {
            print("list of cities load fail")
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                print("Sights saved: ", sights.count)
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func getLocation(with cityName: String, result: @escaping ((FirstModel?) -> ())) {
        
        let apiKey = "707f9337bf1698a7919d6186e92f3612"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: cityName),
                                    URLQueryItem(name: "appid", value: apiKey),]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                if data != nil {
                    if let decoderModel = try? decoder.decode(FirstModel.self, from: data!) {
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
}

extension SearchScreenVC: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if !searchBarIsEmpty {
            filterContentForSearchingText(searchBar.text!)
        } else {
            filteredCities.removeAll()
            tableView.reloadData()
        }
    }
    
    private func filterContentForSearchingText(_ searchText: String) {
        
        filteredCities = cities.filter({ (city: CityModel) -> Bool in
            
            return city.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredCities[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city = filteredCities[indexPath.row].name
        
        getLocation(with: city) { (firstModel) in
            guard let result = firstModel else { return }
            
            for item in self.sights {
                if item.relationTo == result.name.lowercased() {
                    self.cityObjects.append(item)
                }
            }
            DispatchQueue.main.async {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? CityWeatherVC {
                    
                    vc.chosenCity = result
                    
                    vc.sights = self.cityObjects
                    
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
        }
    }
}
