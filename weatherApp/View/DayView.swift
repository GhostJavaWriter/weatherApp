//
//  DayView.swift
//  weatherApp
//
//  Created by Баир Надцалов on 02.11.2020.
//

import Foundation
import UIKit
import PureLayout

class DayView: UIView {
    
    var shouldSetupConstraints = true
    
    var backgroundView : UIView!
    var imageView      : UIImageView!
    var timeLabel      : UILabel!
    var weatherLabel   : UILabel!
    var weatherIcon    : UIImage!
    
    let scrollViewSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
    
    init(frame: CGRect, size: CGSize, model: HourlyModel, timeOffset: TimeInterval) {
        super.init(frame: frame)
        
        let backgroundViewSize = CGSize(width: 150, height: size.height)
        
        let date = Date(timeIntervalSince1970: model.dt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(timeOffset))
        let time = dateFormatter.string(from: date)
        
        let temp = Int(model.temp)
        
        backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.autoSetDimension(.width, toSize: backgroundViewSize.width)
        backgroundView.autoSetDimension(.height, toSize: backgroundViewSize.height)
        backgroundView.layer.cornerRadius = 15
        self.addSubview(backgroundView)
        
        imageView = UIImageView(frame: CGRect.zero)
        //imageView.backgroundColor = UIColor.brown
        imageView.autoSetDimension(.width, toSize: backgroundViewSize.width)
        imageView.autoSetDimension(.height, toSize: backgroundViewSize.height/2)
        
        let icon = model.weather[0].icon
        DispatchQueue.global().async {
            self.loadIconFromURL(with: icon)
        }
        
        backgroundView.addSubview(imageView)
        
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.text = "\(time)"
        timeLabel.textAlignment = .center
        timeLabel.autoSetDimension(.height, toSize: backgroundViewSize.height/4)
        timeLabel.autoSetDimension(.width, toSize: backgroundViewSize.width)
        backgroundView.addSubview(timeLabel)
        
        weatherLabel = UILabel(frame: CGRect.zero)
        weatherLabel.text = "\(temp)˚С"
        weatherLabel.textAlignment = .center
        weatherLabel.autoSetDimension(.height, toSize: backgroundViewSize.height/4)
        weatherLabel.autoSetDimension(.width, toSize: backgroundViewSize.width)
        backgroundView.addSubview(weatherLabel)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            
            backgroundView.autoPinEdgesToSuperviewEdges(with: .zero)
            
            imageView.autoPinEdge(toSuperviewEdge: .left)
            imageView.autoPinEdge(.top, to: .top, of: backgroundView)
            
            timeLabel.autoPinEdge(toSuperviewEdge: .left)
            timeLabel.autoPinEdge(.top, to: .bottom, of: imageView)

            weatherLabel.autoPinEdge(toSuperviewEdge: .left)
            weatherLabel.autoPinEdge(.top, to: .bottom, of: timeLabel)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    func loadIconFromURL(with iconCode: String){
        
        let urlString = "http://openweathermap.org/img/wn/\(iconCode)@2x.png"
        
        guard let imageUrl = URL(string: urlString) else {
            print("get url error")
            return
        }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
}

