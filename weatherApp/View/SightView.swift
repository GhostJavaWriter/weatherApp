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
        
        let color = UIColor(white: 0, alpha: 0)
        let layer = CAGradientLayer()
        
        layer.cornerRadius = 15
        layer.colors = [color.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 0.55)
        layer.frame = viewFrame
        viewContainer.layer.addSublayer(layer)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
