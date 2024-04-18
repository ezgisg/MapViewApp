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
    let continueButton = UIButton()
    let generalAddressLabel = UILabel()
    let detailAddressTextField = UITextField()
    let addressHeaderTextField = UITextField()
    let saveButton = UIButton()
    
    let containerView = UIView()
    
    var mapHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
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
        
        print(view.frame.height)
        
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
            

            generalAddressLabel.text = "Genel Adres"
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
            mapHeight?.constant = -80
            view.layoutIfNeeded()
        }
    }
    
    
}



