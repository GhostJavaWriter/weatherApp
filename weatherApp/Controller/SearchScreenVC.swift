//
//  SearchScreenVC.swift
//  weatherApp
//
//  Created by Баир Надцалов on 27.10.2020.
//

import UIKit
import CoreData

class SearchScreenVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var recentSearches = [FirstModel]()
    
    var cityObjects = [Sight]()
    var sights = [Sight]()
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Погода"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        
        //here the things
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? CityWeatherVC {
            vc.chosenCity = recentSearches[indexPath.row]
            
            vc.sights = cityObjects
            
            navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    // MARK: SearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let cityName = searchBar.text {
            
            getLocation(with: cityName) { (firstModel) in
                guard let result = firstModel else { return }
                self.recentSearches.insert(result, at: 0)
                
                for item in self.sights {
                    if item.relationTo == result.name.lowercased() {
                        self.cityObjects.append(item)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
