//
//  MainViewController.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let networkManager      = NetworkManager()
    var collectionView      : UICollectionView!
    var forecastData        : [ForecastTemperature] = []

    var locationManager     = CLLocationManager()
    var currentLoc          : CLLocation?
    var stackView           : UIStackView!
    var latitude            : CLLocationDegrees!
    var longitude           : CLLocationDegrees!
    
    let crrntLction: UILabel = {
        let label           = UILabel()
        label.text          = "..Location"
        label.textAlignment = .left
        label.textColor     = .label
        label.numberOfLines = 0
        label.font          = UIFont.systemFont(ofSize: 38, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "current location"
        return label
    }()
    let crrntTime: UILabel = {
        let label           = UILabel()
        label.text          = "23 June 2021"
        label.textAlignment = .left
        label.textColor     = .label
        label.font          = UIFont.systemFont(ofSize: 10, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let crrntTmpLbl: UILabel = {
        let label           = UILabel()
        label.text          = "°F"
        label.textColor     = .label
        label.textAlignment = .left
        label.font          = UIFont.systemFont(ofSize: 60, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tempDetails: UILabel = {
        let label           = UILabel()
        label.text          = "..."
        label.textAlignment = .left
        label.textColor     = .label
        label.font          = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tmpSmbl: UIImageView = {
        let img         = UIImageView()
        img.image       = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.tintColor   = .gray
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    let maxTmp: UILabel = {
        let label           = UILabel()
        label.text          = "  °F"
        label.textAlignment = .left
        label.textColor     = .label
        label.font          = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let minTmp: UILabel = {
        let label           = UILabel()
        label.text          = "  °F"
        label.textAlignment = .left
        label.textColor     = .label
        label.font          = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)), UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        transparentNavigationBar()
        
        setupViews()
        layoutViews()
        loadData(city: "San Francisco")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate    = nil
        let location        = locations[0].coordinate
        latitude            = location.latitude
        longitude           = location.longitude
        print("Long", longitude.description)
        print("Lat", latitude.description)
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
    func loadData(city: String) {
        loadWeeklyForecast(city: city)
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            print("Current Temperature", weather.main.temp.kelvinToFConverter())
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy" //yyyy
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.crrntTmpLbl.text = (String(weather.main.temp.kelvinToFConverter()) + "°F")
                self.crrntLction.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.tempDetails.text = weather.weather[0].description
                self.crrntTime.text = stringDate
                self.minTmp.text = ("Min: " + String(weather.main.temp_min.kelvinToFConverter()) + "°F" )
                self.maxTmp.text = ("Max: " + String(weather.main.temp_max.kelvinToFConverter()) + "°F" )
                self.tmpSmbl.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    func loadWeeklyForecast(city: String) {
        networkManager.fetchWeeklyForecast(city: city) { (forecast) in
            self.forecastData = forecast
            print("Total Count:", forecast.count)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            print("Current Temperature", weather.main.temp.kelvinToFConverter())
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy" //yyyy
            let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
            
            DispatchQueue.main.async {
                self.crrntTmpLbl.text = (String(weather.main.temp.kelvinToFConverter()) + "°F")
                self.crrntLction.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                self.tempDetails.text = weather.weather[0].description
                self.crrntTime.text = stringDate
                self.minTmp.text = ("Min: " + String(weather.main.temp_min.kelvinToFConverter()) + "°F" )
                self.maxTmp.text = ("Max: " + String(weather.main.temp_max.kelvinToFConverter()) + "°F" )
                self.tmpSmbl.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
            }
        }
    }
    
    //MARK: - Handlers
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("City Name: \(String(describing: firstTextField.text))")
            guard let cityname = firstTextField.text else { return }
            self.loadData(city: cityname)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
    
    func setupViews() {
        view.addSubview(crrntLction)
        view.addSubview(crrntTmpLbl)
        view.addSubview(tmpSmbl)
        view.addSubview(tempDetails)
        view.addSubview(crrntTime)
        view.addSubview(minTmp)
        view.addSubview(maxTmp)
        view.addSubview(collectionView)
    }
    
    func layoutViews() {
        
        crrntLction.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        crrntLction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        crrntLction.heightAnchor.constraint(equalToConstant: 70).isActive = true
        crrntLction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        crrntTime.topAnchor.constraint(equalTo: crrntLction.bottomAnchor, constant: 4).isActive = true
        crrntTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        crrntTime.heightAnchor.constraint(equalToConstant: 10).isActive = true
        crrntTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
//        crrntTmpLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        crrntTmpLbl.topAnchor.constraint(equalTo: crrntTime.bottomAnchor, constant: 18).isActive = true
        crrntTmpLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        crrntTmpLbl.heightAnchor.constraint(equalToConstant: 70).isActive = true
        crrntTmpLbl.widthAnchor.constraint(equalToConstant: 250).isActive = true
     
        
        tmpSmbl.topAnchor.constraint(equalTo: crrntTmpLbl.bottomAnchor).isActive = true
        tmpSmbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        tmpSmbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tmpSmbl.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempDetails.topAnchor.constraint(equalTo: crrntTmpLbl.bottomAnchor, constant: 12.5).isActive = true
        tempDetails.leadingAnchor.constraint(equalTo: tmpSmbl.trailingAnchor, constant: 8).isActive = true
        tempDetails.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tempDetails.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        minTmp.topAnchor.constraint(equalTo: tmpSmbl.bottomAnchor, constant: 18).isActive = true
        minTmp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        minTmp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minTmp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        maxTmp.topAnchor.constraint(equalTo: minTmp.bottomAnchor).isActive = true
        maxTmp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        maxTmp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxTmp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
//        collectionView.topAnchor.constraint(equalTo: maxTmp.bottomAnchor, constant: 18).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18).isActive = true
//        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        collectionView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.topAnchor.constraint(equalTo: maxTmp.bottomAnchor, constant: 8).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    //collection view Configuration
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
        cell.configure(with: forecastData[indexPath.row])
        return cell
     }
     

    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

       let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
       let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
      // layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
       return layoutSection
}
}

