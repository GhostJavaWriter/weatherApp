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
        
        setScrollView()
        
        if sights.count > 0 {
            setContent(sights: sights)
        }
    }
    
    func setScrollView() {
        
        scrollView = UIScrollView()
        scrollView.autoSetDimensions(to: UIScreen.main.bounds.size)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(sights?.count ?? 1))
        scrollView.backgroundColor = .lightGray
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
    
    @objc func sightViewTapped() {
        
        //push view controller with 4th screen
        //should send sight location, image and text info
        print("view tapped")
    }
    
}
