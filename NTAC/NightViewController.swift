//
//  NightViewController.swift
//  NTAC
//
//  Created by Zhanat on 27.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftGifOrigin

class NightViewController: UIViewController {
    
    
    var seconds = 60
    var timer = Timer()
    var isMusicStart = false

    @IBOutlet weak var timeLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var musicButton: UIButton!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func playSound() {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm", ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
    }

    
    @IBAction func musicPlayer(_ sender: Any) {
        if(isMusicStart){
            audioPlayer?.pause()
            isMusicStart = false
            musicButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        }else{
            audioPlayer?.play()
            isMusicStart = true
            musicButton.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
    }
    
    @IBAction func choseTime(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "1 min", style: .default, handler: { _ in
            self.seconds = 60
            self.runTimer()
        }))
        
        alert.addAction(UIAlertAction(title: "5 min", style: .default, handler: { _ in
            self.seconds = 300
            self.runTimer()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            let alert = UIAlertController(title: "1 min", message: "END", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            UIApplication.shared.isIdleTimerDisabled = false
            audioPlayer?.stop()
        } else {
            seconds -= 1
            timeLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        playSound()
        imageView.image = UIImage.gif(name: "giphy")
    }
}
