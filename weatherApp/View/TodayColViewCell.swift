//
//  TodayColViewCell.swift
//  weatherApp
//
//  Created by Баир Надцалов on 08.11.2020.
//

import UIKit

class TodayColViewCell: UICollectionViewCell {
    
    var containerView  = UIView()
    var imageView      = UIImageView()
    var timeLabel      = UILabel()
    var tempLabel      = UILabel()
    var weatherIcon    = UIImage()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //adding background view
        contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 15
        
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.backgroundColor = .lightGray
        
        //adding image view
        containerView.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "default")
        imageView.autoPinEdge(.top, to: .top, of: containerView, withOffset: 0)
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoSetDimension(.height, toSize: 80)
        imageView.autoSetDimension(.width, toSize: 80)
    }
}
