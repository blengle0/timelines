//
//  HomeViewController.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import UIKit
import MapKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var permissionContainerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    private var viewModel: HomeViewModelType?
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel = HomeViewModel()
        
        viewModel?.permissionRequiredPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (permissionRequired) in
                self?.permissionContainerView.isHidden = !permissionRequired
                self?.mapView.showsUserLocation = !permissionRequired
            }).store(in: &cancellables)
        
        viewModel?.annotationsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (annotations) in
                if let oldAnnotations = self?.mapView.annotations {
                    self?.mapView.removeAnnotations(oldAnnotations)
                }
                self?.mapView.addAnnotations(annotations)
                self?.mapView.showAnnotations(annotations, animated: true)
            }).store(in: &cancellables)
    }
    
    @IBAction func didTapEnable(_ sender: UIButton) {
        viewModel?.enableLocationPermissions()
    }
    
    @IBAction func didChangeFilterSelection(_ sender: UISegmentedControl) {
        guard let filter = TimelinesFilterType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        viewModel?.updateFilterSelection(selection: filter)
    }

}

