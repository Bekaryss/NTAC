//
//  TimerViewController.swift
//  NTAC
//
//  Created by Zhanat on 26.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func start(_ sender: Any) {
        start()
        resetButton.isEnabled = false
        pauseButton.isEnabled = true
        startButton.isEnabled = false
    }
    
    @IBAction func pause(_ sender: Any) {
        stop()
        resetButton.isEnabled = true
        startButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        timer?.invalidate()
        startTime = 0
        time = 0
        elapsed = 0
        timerLabel.text = String(format:"%02i:%02i:%02i", 0, 0, 0)
        pauseButton.isEnabled = false
        startButton.isEnabled = true
        resetButton.isEnabled = false
    }
    
    func start() {
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stop() {
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
    }
    
    func updateCounter() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt8(time * 100)
        
        timerLabel.text = String(format:"%02i:%02i:%02i", minutes, seconds, milliseconds)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isEnabled = false
        pauseButton.isEnabled = false
    }
}
