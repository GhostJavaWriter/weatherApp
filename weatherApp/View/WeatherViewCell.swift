//
//  WeatherViewCell.swift
//  weatherApp
//
//  Created by Баир Надцалов on 08.11.2020.
//

import UIKit


class WeatherViewCell: UICollectionViewCell {
    
    var hourWeather: HourlyModel? {
        didSet {
            guard let hourWeather = hourWeather else { return }
            let image = UIImage(named: hourWeather.weather[0].icon)
            imageView.image = image
            timeLabel.text = getFormatedTime(time: hourWeather.dt)
            tempLabel.text = "\(Int(hourWeather.temp))˚C"
        }
    }
    var timeOffset = TimeInterval()
    
    private let imageView = UIImageView()
    private let timeLabel = UILabel()
    private let tempLabel = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //adding background view
        let containerView  = UIView()
        contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .lightGray
        
        //adding weather icon
        containerView.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //adding time text
        containerView.addSubview(timeLabel)
        timeLabel.text = "default"
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //adding temperature text
        containerView.addSubview(tempLabel)
        tempLabel.text = "default"
        tempLabel.textAlignment = .center
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            
            timeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    func getFormatedTime(time: TimeInterval) -> String {
        //"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
        let date = Date(timeIntervalSince1970: time)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(timeOffset))
        
        let currentTime = dateFormatter.string(from: date)
        
        return currentTime
    }
}
