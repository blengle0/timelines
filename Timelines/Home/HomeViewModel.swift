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
    var permissionRequired: Published<Bool>.Publisher { get }
    var annotations: Published<[MKAnnotation]>.Publisher { get }
    
    func enableLocationPermissions()
    func updateFilterSelection(selection: TimelinesFilterType)
}

class HomeViewModel: HomeViewModelType {
    
    @Published var permissionRequiredValue: Bool = true
    var permissionRequired: Published<Bool>.Publisher { $permissionRequiredValue }
    @Published var annotationsValue: [MKAnnotation] = []
    var annotations: Published<[MKAnnotation]>.Publisher { $annotationsValue }
    private var cancellables: Set<AnyCancellable> = []
    private var filterType: TimelinesFilterType = .latest
    
    var repository: RepositoryManagerType? {
        return AppConfiguration.repositoryManager
    }
    
    init() {
        repository?.locationRepositoryType.hasLocationAccessPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (hasLocationAccess) in
                self?.permissionRequiredValue = !hasLocationAccess
                self?.updateAnnotations()
            }).store(in: &cancellables)
        
        NotificationCenter.default.addObserver(forName: .TimelinesDidUpdate, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            self?.updateAnnotations()
        }
    }
    
    func updateAnnotations() {
        guard let locations = repository?.timelinesRepository.getLocations(filter: filterType) else {
            return
        }
        
        annotationsValue = locations.map { (location) -> MKAnnotation in
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
