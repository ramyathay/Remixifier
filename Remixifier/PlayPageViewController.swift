//
//  File.swift
//  Remixifier



import Foundation
import UIKit
import AVFoundation

class PlayPageViewController: UIViewController {
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    var userSelectedAudioClips = [NSURL]()
    var audioPlayerItems = [AVPlayerItem]()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    
    @IBAction func playButtonPressed(sender: UIButton) {
        var i = 0
        
        while i < userSelectedAudioClips.count {
            let playerItem = AVPlayerItem(URL: userSelectedAudioClips[i])
            print("Adding to queue",userSelectedAudioClips[i])
            audioPlayerItems.append(playerItem)
            i++
            print("Playing song")
        }
        let queuePlayer = AVQueuePlayer.init(items: audioPlayerItems)
        queuePlayer.play()
        
        userSelectedAudioClips.removeAll()
    }
    
}