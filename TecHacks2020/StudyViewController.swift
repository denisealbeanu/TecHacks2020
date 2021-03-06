//
//  StudyViewController.swift
//  TecHacks2020
//
//  Created by Angela Du on 2020-08-15.
//  Copyright © 2020 Angela Du. All rights reserved.
//

import Foundation
import UIKit


class StudyViewController: UIViewController {

    lazy var groundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 700, height: 100)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Ground-1.png")
        return imageView
    }()
    
    let storage: Storage = UserDefaultsStorage()
    

    lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.text = getTotalTimeText()
        label.font = UIFont(name: "ChalkboardSE-Regular", size: 16)
        label.textColor = #colorLiteral(red: 0.2954841909, green: 0.4323643718, blue: 0.3980227289, alpha: 1)
        return label
    }()
    
    lazy var totalPlantLabel: UILabel = {
        let label = UILabel()
        label.text = getTotalPlantText()
        label.font = UIFont(name: "ChalkboardSE-Regular", size: 16)
        label.textColor = #colorLiteral(red: 0.2954841909, green: 0.4323643718, blue: 0.3980227289, alpha: 1)
        return label
    }()
    
    lazy var plantImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = determineImage()
        return imageView
    }()
    
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        let icon = UIImage(systemName: "play")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.3606600941, green: 0.5, blue: 0.3822331787, alpha: 1)
        button.setImage(icon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 55),
            button.heightAnchor.constraint(equalToConstant: 55)
        ])
        return button
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        button.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        let icon = UIImage(systemName: "pause")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.5, green: 0.3928384412, blue: 0.1582015084, alpha: 1)
        button.setImage(icon, for: .normal)
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 55),
            button.heightAnchor.constraint(equalToConstant: 55)
        ])
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3378090189, blue: 0.3325169804, alpha: 1)
        button.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        let icon = UIImage(systemName: "stop")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.466767132, green: 0.1147519991, blue: 0.1628827654, alpha: 1)
        button.setImage(icon, for: .normal)
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 55),
            button.heightAnchor.constraint(equalToConstant: 55)
        ])
        return button
    }()
    
    lazy var buttonControlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubviews([playButton, pauseButton, stopButton])
        return stackView
    }()
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = self.formatLabel()
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 50)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    var timer: Timer?

    override func viewDidLoad() {
        setupReveal()
        customizeNavBar()

        view.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.9215686275, blue: 0.8156862745, alpha: 1)
        layoutViews()
        //Stop by putting -> timer.invalidate()
    }
    func customizeNavBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.418486735, green: 0.6923183693, blue: 0.5116335288, alpha: 1)
        self.navigationItem.title = "Study Tracker"
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 19)!,
             NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    }
    func layoutViews() {
        view.addSubview(groundImage)
        view.addSubview(playButton)
        view.addSubview(buttonControlStackView)
        view.addSubview(counterLabel)
        view.addSubview(totalTimeLabel)
        view.addSubview(plantImage)
        view.addSubview(totalPlantLabel)
        
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        buttonControlStackView.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        totalPlantLabel.translatesAutoresizingMaskIntoConstraints = false
        groundImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        groundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        groundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        groundImage.heightAnchor.constraint(equalToConstant: 340).isActive = true

        plantImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plantImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5).isActive = true

        totalTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        totalTimeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        totalPlantLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        totalPlantLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 0).isActive = true
        
        counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        counterLabel.topAnchor.constraint(equalTo: plantImage.bottomAnchor, constant: -25).isActive = true
        
        buttonControlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        buttonControlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80).isActive = true
        buttonControlStackView.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        playButton.isEnabled = false
    }
    
    @objc func fireTimer() {
        seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
            if minutes > 59 {
                hours += 1
            }
        }
        DispatchQueue.main.async {
            self.counterLabel.text = self.formatLabel()
            self.plantImage.image = self.determineImage()
            self.totalTimeLabel.text = self.getTotalTimeText()
        }
    }
    
    func determineImage() -> UIImage {
        if storage.retrieve(key: "currentTime") == nil {
            storage.store(key: "currentTime", object: 0)
        }
        let curTime = storage.retrieve(key: "currentTime") as! Int
        let time = timeStudied() + curTime
        if (time < 1800) {
            return UIImage(named: "1.png")!
        } else if (time < 3600) {
            return UIImage(named: "2.png")!
        } else if (time < 5400) {
            return UIImage(named: "3.png")!
        } else if (time < 7200) {
            return UIImage(named: "4.png")!
        } else if (time < 9000) {
            return UIImage(named: "5.png")!
        } else {
            return UIImage(named: "6.png")!
        }
    }
    
    func formatLabel() -> String {
        return "\(self.formatNum(self.hours)):\(self.formatNum(self.minutes)):\(self.formatNum(self.seconds))"
    }
    
    func formatNum(_ int: Int) -> String {
        return String(format: "%02d", int)
    }
    
    func timeStudied() -> Int {
        var totalSeconds = 0
        totalSeconds = hours * 3600 + minutes * 60 + seconds
        return totalSeconds
    }
    
    func dequeueSeconds(int: Int) -> (Int, Int, Int) {
        let hours2 = int/3600 //Number of hours
        let remainder = int - (3600*hours2)
        let minutes2 = remainder/60
        let seconds2 = remainder - (60*minutes2)
        return (hours2, minutes2, seconds2)
    }
    
    @objc func stopTimer() {
        timer?.invalidate()
        
        if storage.retrieve(key: "totalTime") == nil {
            storage.store(key: "totalTime", object: 0)
        }

        guard let totalTime = storage.retrieve(key: "totalTime") as? Int else { return }
        storage.store(key: "totalTime", object: totalTime + timeStudied())
        if (timeStudied() < 10800) {
            storage.store(key: "currentTime", object: timeStudied())
        }
        print(storage.retrieve(key: "currentTime") as! Int)
        seconds = 0
        minutes = 0
        hours = 0

        self.totalPlantLabel.text = self.getTotalPlantText()
        self.counterLabel.text = self.formatLabel()
            self.totalTimeLabel.text = getTotalTimeText()
            playButton.isEnabled = true
    }
    
    @objc func pauseTimer() {
        timer?.invalidate()
        playButton.isEnabled = true
        
    }
    
    func getTotalTime() -> Int {
        let curTime = storage.retrieve(key: "currentTime") as! Int
        let pastTime = storage.retrieve(key: "totalTime") as! Int
        let studyTime = timeStudied()
        
        return curTime + pastTime + studyTime
    }
    
    func getTotalTimeText() -> String {
        let (h,m,s) = dequeueSeconds(int: getTotalTime())
        return "Total Time: \(h) hours, \(m) minutes, and \(s) seconds"
    }
    
    func getTotalPlantText() -> String {
        let totalNumber = getTotalTime()/10800
        return "Total number of plants grown: \(totalNumber)"
    }
}
