//
//  SightView.swift
//  weatherApp
//
//  Created by Баир Надцалов on 05.11.2020.
//

import UIKit

class SightView: UIView {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    init(frame: CGRect, currentSight: Sights) {
        super.init(frame: frame)

        self.autoSetDimension(.width, toSize: screenWidth - CGFloat(40))
        self.autoSetDimension(.height, toSize: screenHeight/4)
        
        let viewFrame = CGRect(x: 0, y: 0, width: screenWidth - CGFloat(40), height: screenHeight/4)
        
        //add image
        let imageView = UIImageView(image: UIImage(named: currentSight.image))
        imageView.frame = viewFrame
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        
        let viewContainer = UIView(frame: CGRect.zero)
        
        viewContainer.autoSetDimensions(to: self.bounds.size)
        
        self.addSubview(viewContainer)
        viewContainer.frame = viewFrame
        viewContainer.autoPinEdgesToSuperviewEdges(with: .zero)
        
        //add gradient layer
        let color = UIColor(white: 0, alpha: 0)
        let layer = CAGradientLayer()
        
        layer.cornerRadius = 15
        layer.colors = [color.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.25)
        layer.endPoint = CGPoint(x: 0, y: 0.55)
        layer.frame = viewFrame
        viewContainer.layer.addSublayer(layer)
        
        //add name if sight
        let nameLabel = UILabel()
        nameLabel.text = currentSight.name
        nameLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        nameLabel.textColor = UIColor.white
        viewContainer.addSubview(nameLabel)
        
        nameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        
        //add short description
        let descr = UILabel()
        descr.text = currentSight.shortDescr
        descr.font = UIFont(name: "arial", size: 16)
        descr.textColor = UIColor.white
        viewContainer.addSubview(descr)
        
        descr.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 20)
        descr.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        descr.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        
        descr.numberOfLines = 0
        if let breakMode = NSLineBreakMode(rawValue: 0) {
            descr.lineBreakMode = breakMode
        } else {
            print("fail adding line break mode")
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
