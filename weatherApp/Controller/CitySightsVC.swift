//
//  CitySightsVC.swift
//  weatherApp
//
//  Created by Баир Надцалов on 08.11.2020.
//

import UIKit
import PureLayout

class CitySightsVC: UIViewController {
    
    var sights: [Sight]!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SightCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Достопримечательности"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        collectionView.autoPinEdgesToSuperviewEdges()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension CitySightsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - CGFloat(40), height: UIScreen.main.bounds.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SightCollectionViewCell else { fatalError() }
        
        cell.sight = sights[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = SightDetailVC()
        vc.currentSight = sights[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
