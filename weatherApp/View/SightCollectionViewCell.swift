//
//  SightCollectionViewCell.swift
//  weatherApp
//
//  Created by Баир Надцалов on 08.11.2020.
//

import UIKit
import PureLayout

class SightCollectionViewCell: UICollectionViewCell {
    
    var sight: Sight? {
        didSet {
            guard let sight = sight else { return }
            imageView.image = UIImage(named: sight.image)
            nameLabel.text = sight.name
            descr.text = sight.shortDescr
        }
    }
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descr = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let containerView = UIView()
        contentView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()

        //add image
        containerView.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "default")
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.autoPinEdgesToSuperviewEdges()
        
        //add gradient view
        let gradientView = UIView(frame: CGRect.zero)

        containerView.addSubview(gradientView)
        
        gradientView.frame = contentView.frame
        gradientView.autoPinEdgesToSuperviewEdges(with: .zero)

        //add gradient layer
        let color = UIColor(white: 0, alpha: 0)
        let layer = CAGradientLayer()

        layer.cornerRadius = 15
        layer.colors = [color.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.25)
        layer.endPoint = CGPoint(x: 0, y: 0.55)
        layer.frame = contentView.frame
        gradientView.layer.addSublayer(layer)

        //add name if sight
        nameLabel.text = "default sight name"
        nameLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        nameLabel.textColor = UIColor.white
        containerView.addSubview(nameLabel)

        nameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)

        //add short description
        descr.text = "default descr"
        descr.font = UIFont(name: "arial", size: 16)
        descr.textColor = UIColor.white
        containerView.addSubview(descr)

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
        fatalError("init(coder:) has not been implemented")
    }
}
