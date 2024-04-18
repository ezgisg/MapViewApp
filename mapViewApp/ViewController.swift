//
//  ViewController.swift
//  mapViewApp
//
//  Created by Ezgi Sümer Günaydın on 17.04.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let map = MKMapView()
    let mapPin = MKPointAnnotation()
    let continueButton = UIButton()
    var isFirstScreen = true
    
    let containerView = UIView()
    let generalAddressLabel = UILabel()
    let detailAddressTextField = UITextField()
    let addressHeaderTextField = UITextField()
    let saveButton = UIButton()

    var mapHeight: NSLayoutConstraint?
    
    let mapLocationManager = CLLocationManager()
    var lastLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        lastLocation = mapLocationManager.location
        setupLocationManager()
        configureMapView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            setupAnnotationLocation()
            map.addAnnotation(mapPin)
            map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if isFirstScreen {
            DispatchQueue.global().async {
                self.checkLocationServices()
            }
        }
         
        
           
    }
    
    
    func configureMapView() {
        
        mapHeight = map.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -80)
        guard let mapHeight else { return }
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapHeight
        ])
        
        
        continueButton.backgroundColor = .blue
        continueButton.setTitle("Continue", for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 100),
            continueButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func continueButtonTapped() {
        
        isFirstScreen = false
        UIView.animate(withDuration: 0.3) { [self] in
            
            mapHeight?.constant = -(view.frame.height * 0.5)
            view.layoutIfNeeded()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.mapTapped))
            map.addGestureRecognizer(tapGesture)
            
            let customGreen = UIColor(red: 100/255, green: 190/255, blue: 120/255, alpha: 1.0)
            containerView.backgroundColor = customGreen
            
            containerView.layer.cornerRadius = 20
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.white.cgColor
            view.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: -5),
                containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            

            generalAddressLabel.textAlignment = .center
            generalAddressLabel.textColor = .black
            generalAddressLabel.backgroundColor = .white
            generalAddressLabel.layer.cornerRadius = 10
            generalAddressLabel.layer.borderWidth = 2
            generalAddressLabel.layer.borderColor = UIColor.white.cgColor
            generalAddressLabel.layer.masksToBounds = true
            containerView.addSubview(generalAddressLabel)
            generalAddressLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                generalAddressLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                generalAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                generalAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                generalAddressLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/6)
            ])
         
            detailAddressTextField.placeholder = "Please enter your address"
            detailAddressTextField.textAlignment = .center
            detailAddressTextField.backgroundColor = .white
            detailAddressTextField.layer.cornerRadius = 10
            detailAddressTextField.layer.borderWidth = 2
            detailAddressTextField.layer.borderWidth = 2
            detailAddressTextField.layer.borderColor = UIColor.white.cgColor
            containerView.addSubview(detailAddressTextField)
            detailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                detailAddressTextField.topAnchor.constraint(equalTo: generalAddressLabel.bottomAnchor, constant: 10),
                detailAddressTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                detailAddressTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                detailAddressTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/6)
            ])
         
            
            addressHeaderTextField.placeholder = "Please enter your address header"
            addressHeaderTextField.textAlignment = .center
            addressHeaderTextField.backgroundColor = .white
            addressHeaderTextField.layer.cornerRadius = 10
            addressHeaderTextField.layer.borderWidth = 2
            addressHeaderTextField.layer.borderWidth = 2
            addressHeaderTextField.layer.borderColor = UIColor.white.cgColor
            containerView.addSubview(addressHeaderTextField)
            addressHeaderTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addressHeaderTextField.topAnchor.constraint(equalTo: detailAddressTextField.bottomAnchor, constant: 10),
                addressHeaderTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                addressHeaderTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                addressHeaderTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/6)
            ])
         
            
            saveButton.setTitle("Save", for: .normal)
            saveButton.backgroundColor = .blue
            saveButton.layer.cornerRadius = 10
            containerView.addSubview(saveButton)
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40),
                saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                saveButton.widthAnchor.constraint(equalToConstant: 100),
                saveButton.heightAnchor.constraint(equalToConstant: 40)
            ])
         
            
        }
    }
    
    @objc func mapTapped() {
        UIView.animate(withDuration: 0.3) { [self] in
            self.containerView.removeFromSuperview()
            isFirstScreen = true
            mapHeight?.constant = -80
            view.layoutIfNeeded()
        }
    }
    
    
    func showLocationServicesDisabledAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Location services is closed", message: "Please change settings", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func makeAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "There is no permission", message: "Please give permission", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }

    }
    
}


extension ViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
 
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.checkLocationAuth()
            }
        } else {
            showLocationServicesDisabledAlert()
        }
    }
    
    func checkLocationAuth() {
        switch mapLocationManager.authorizationStatus {
        case .notDetermined:
            mapLocationManager.requestWhenInUseAuthorization()
        case .restricted:
           makeAlert()
        case .denied:
           makeAlert()
        case .authorizedAlways:
            userLocationTracking()
        case .authorizedWhenInUse:
            userLocationTracking()
        @unknown default:
            makeAlert()
            
        }
    }
    
    func setupLocationManager() {
        mapLocationManager.delegate = self
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func userLocationArea() {
        if let location = mapLocationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 100, longitudinalMeters: 100)
            map.setRegion(region, animated: true)
            print(map.region.center)
        }
    }
    
    func userLocationTracking() {
        map.showsUserLocation = true
        userLocationArea()
        mapLocationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {return}
        if let lastLocation = lastLocation, newLocation.distance(from: lastLocation) > 20 {
            self.lastLocation = newLocation
            userLocationArea()
        }

    }
    
    func setupAnnotationLocation () {
        let centerCoordinate = map.region.center
        let adjustedCenterCoordinate = CLLocationCoordinate2D(latitude: centerCoordinate.latitude + 0.00004, longitude: centerCoordinate.longitude)
        mapPin.coordinate = adjustedCenterCoordinate
        
        let center = CLLocation(latitude: mapPin.coordinate.latitude, longitude: mapPin.coordinate.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(center) { [weak self] placemarks , error in
            guard let self = self else {return}
            if let error = error {
                print("Hata: \(error)")
                return
            }
            guard let placemark = placemarks?.first else {return}
            let city = placemark.locality ?? ""
            let street = placemark.thoroughfare ?? ""
            let district = placemark.subAdministrativeArea ?? ""
            self.generalAddressLabel.text = "\(city) - \(district) -\(street)"
            (map.view(for: mapPin) as? CustomAnnotationView)?.configure(for: mapPin, title: district, subtitle: street)
        }

    
    }
    


    func convertCoordinateToLocation(coordinate: CLLocationCoordinate2D) -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.5) { [self] in
            setupAnnotationLocation()
        }
    }
    
}




class CustomAnnotationView: MKAnnotationView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()

//    override var annotation: MKAnnotation? {
//        didSet {
//            configure(for: annotation, title: "", subtitle: "")
//        }
//    }
    
    func configure(for annotation: MKAnnotation?, title: String, subtitle: String) {
        guard annotation != nil else { return }
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        titleLabel.frame = CGRect(x: 0, y: -40, width: 100, height: 20)
        subtitleLabel.frame = CGRect(x: 0, y: -20, width: 100, height: 20)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        let maxWidth: CGFloat = 50
        let maxHeight: CGFloat = 50
        image = UIImage(named: "location")
        let aspectRatio = image!.size.width / image!.size.height
        var newSize = CGSize(width: maxWidth, height: maxHeight)
        
        if aspectRatio > 1 {
            newSize.height = maxWidth / aspectRatio
        } else {
            newSize.width = maxHeight * aspectRatio
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            image?.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        image = resizedImage

    }
}

