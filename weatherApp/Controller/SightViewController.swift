//
//  SightViewController.swift
//  weatherApp
//
//  Created by Баир Надцалов on 01.11.2020.
//

import UIKit

class SightViewController: UIViewController {

    var scrollView: UIScrollView!
    
    var sights: [Sights]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Достопримечательности"
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .white
        
        setScrollView()
        
        if sights.count > 0 {
            setContent(sights: sights)
        }
    }
    
    func setScrollView() {
        
        scrollView = UIScrollView()
        scrollView.autoSetDimensions(to: UIScreen.main.bounds.size)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height/4 + 15) * CGFloat(sights?.count ?? 1))
        
        view.addSubview(scrollView)
    }
    
    func setContent(sights: [Sights]) {
        
        var previous: SightView?
        
        for sight in sights {
            
            let sightDescr = SightView(frame: CGRect.zero, currentSight: sight)
            
            scrollView.addSubview(sightDescr)
            sightDescr.autoAlignAxis(.vertical, toSameAxisOf: scrollView)
            if let previous = previous {
                sightDescr.autoPinEdge(.top, to: .bottom, of: previous, withOffset: 15)
            } else {
                sightDescr.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 15)
            }
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sightViewTapped))
            sightDescr.isUserInteractionEnabled = true
            sightDescr.addGestureRecognizer(gestureRecognizer)
            
            previous = sightDescr
        }
    }
    
    //go to 4th screen
    @objc func sightViewTapped() {
        
        let vc = SightDetailVC()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
