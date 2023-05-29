//
//  HomepageViewModel.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 29/05/23.
//

import Foundation
import Combine
import UIKit


class HomepageViewModel {
    
    let isLoading = CurrentValueSubject<[String]?, Never>(nil)
    
    init() {
        
    }
    
    public func populateTableView(){
        
        isLoading.send(["Giulio Aterno", "Silvio Fosso", "Luigi Marino", "Andrea Ferrentino", "Andreana Perla", "Fabiana Chiocca", "Yehia Itani"])
    }
}
