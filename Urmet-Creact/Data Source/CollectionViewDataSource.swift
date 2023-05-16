//
//  ViewControllerCollectionView.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 15/05/23.
//

import UIKit

class CollectionViewDataSource: NSObject {
    
    private weak var collectionView: UICollectionView?
    private var values: [String]?
    
    var cellVieModel: [CustomCell]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init(collectionView: UICollectionView, with values: [String]?) {
        self.values = values
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        let cellNib = UINib(nibName: "CustomCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "myCell")
        
    }
}

extension CollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? CustomCell else { return UICollectionViewCell()}
        cell.setNames(values?[safe: indexPath.row] ?? "", "")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Setup click 
    }
    
}


