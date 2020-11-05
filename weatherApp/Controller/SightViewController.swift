//
//  SightViewController.swift
//  weatherApp
//
//  Created by Баир Надцалов on 01.11.2020.
//

import UIKit

class SightViewController: UIViewController {

    var scrollView: UIScrollView!
    
    var sightCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Достопримечательности"
        navigationItem.largeTitleDisplayMode = .never
        
        setScrollView()
        
        setContent()
    }
    
    func setScrollView() {
        
        scrollView = UIScrollView()
        scrollView.autoSetDimensions(to: UIScreen.main.bounds.size)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat(sightCount))
        scrollView.backgroundColor = .lightGray
        view.addSubview(scrollView)
    }
    
    func setContent() {
        
        var previous: SightView?
        
        for _ in 0..<sightCount {
            
            let sight = SightView()
            scrollView.addSubview(sight)
            sight.autoAlignAxis(.vertical, toSameAxisOf: scrollView)
            if let previous = previous {
                sight.autoPinEdge(.top, to: .bottom, of: previous, withOffset: 15)
            } else {
                sight.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 15)
            }
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sightViewTapped))
            sight.isUserInteractionEnabled = true
            sight.addGestureRecognizer(gestureRecognizer)
            previous = sight
        }
    }
    
    @objc func sightViewTapped() {
        
        //push view controller with 4th screen
        //should send sight location, image and text info
        print("view tapped")
    }
    
}
