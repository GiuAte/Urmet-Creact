//
//  CameraCallViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 02/09/22.
//

import Foundation

class CameraCallViewModel {
    var locations: [Location]

    var selectedLocation: Location

    var selectedCameraIndex: Int?

    init(locations: [Location], selectedLocation: Location, selectedCameraIndex: Int?) {
        self.locations = locations
        self.selectedLocation = selectedLocation
        self.selectedCameraIndex = selectedCameraIndex
    }
}
