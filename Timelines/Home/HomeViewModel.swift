//
//  HomeViewModel.swift
//  Timelines
//
//  Created by Bryan Lengle on 2020-08-08.
//  Copyright © 2020 Bryan Lengle. All rights reserved.
//

import Foundation
import Combine
import MapKit

protocol HomeViewModelType {
    var permissionRequiredPublisher: Published<Bool>.Publisher { get }
    var annotationsPublisher: Published<[MKAnnotation]>.Publisher { get }
    
    func enableLocationPermissions()
    func updateFilterSelection(selection: TimelinesFilterType)
}

class HomeViewModel: HomeViewModelType {
    
    @Published var permissionRequired: Bool = true
    var permissionRequiredPublisher: Published<Bool>.Publisher { $permissionRequired }
    @Published var annotations: [MKAnnotation] = []
    var annotationsPublisher: Published<[MKAnnotation]>.Publisher { $annotations }
    private var cancellables: Set<AnyCancellable> = []
    private var filterType: TimelinesFilterType = .latest
    
    var repository: RepositoryManagerType? {
        return AppConfiguration.repositoryManager
    }
    
    init() {
        repository?.locationRepositoryType.hasLocationAccessPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (hasLocationAccess) in
                self?.permissionRequired = !hasLocationAccess
                self?.updateAnnotations()
            }).store(in: &cancellables)
        
        repository?.timelinesRepository.lastModifiedPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (lastModified) in
                self?.updateAnnotations()
            }).store(in: &cancellables)
    }
    
    func updateAnnotations() {
        guard let locations = repository?.timelinesRepository.getLocations(filter: filterType) else {
            return
        }
        
        annotations = locations.map { (location) -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            return annotation
        }
    }
    
    func enableLocationPermissions() {
        repository?.locationRepositoryType.requestAuthorization()
    }
    
    func updateFilterSelection(selection: TimelinesFilterType) {
        filterType = selection
        updateAnnotations()
    }
    
}
