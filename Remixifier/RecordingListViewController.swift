//
//  RecordingListViewController.swift
//  Remixifier
//
//  Created by Christian Gonzalez on 1/15/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class RecordingListViewController:  UIViewController, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var recordedClipsTable: UITableView!
    
    
    var clips: [Clip] = Clip.all()
    var audioClipsNames = ["20160117134854","20160117131959"]
    var audioClipsURL = [NSURL]()
    var userSelectedAudioClips = [NSURL]()
    var audioPlayer: AVAudioPlayer?
    var audioQueuePlayer: AVQueuePlayer?
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let clips: [Clip] = Clip.all()
        for clip in clips {
            
            
//            clip.objective should be the title, not the file URL, need to access the URL of each clip
            
            audioClipsURL.append(NSURL(fileURLWithPath: clip.objective))
        }
        
        recordedClipsTable.reloadData()
        recordedClipsTable.dataSource = self
        recordedClipsTable.delegate = self
        
//        while i < audioClipsNames.count {
//            if let bundlePath = NSBundle.mainBundle().pathForResource(audioClipsNames[i], ofType: "m4a") {
//                let fileURL = NSURL(fileURLWithPath: bundlePath)
//                do {
//                    audioClipsURL.append(fileURL)
//                    print("Audio clip array contains \(audioClipsURL[i])")
//                }
//                catch let error as NSError {
//                    print("Error while playing \(error.localizedDescription)")
//                }
//            }
//            else {
//                print("This file does not exists in the database")
//            }
//            i++
//            
//        }
        recordedClipsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playFinalAudioFileButton(sender: UIButton) {
        var i = 0
        let queuePlayer = AVQueuePlayer()
        print("adding to queue")
        while i < userSelectedAudioClips.count {
            let playerItem = AVPlayerItem(URL: userSelectedAudioClips[i])
            queuePlayer.insertItem(playerItem, afterItem: nil)
            queuePlayer.play()
            i++
        }
    }
    @IBAction func audioClipSelected(sender: UIButton) {
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("audioClipCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("audioClipCell", forIndexPath: indexPath)
        cell.textLabel?.text = String(clips[indexPath.row].createdAt)
        print(cell)
        return cell
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return audioClipsURL.count
        clips = Clip.all()
        return clips.count
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = recordedClipsTable.indexPathForSelectedRow
        print(audioClipsURL)
        let fileURL = NSURL(fileURLWithPath: String(indexPath))
        userSelectedAudioClips.append(fileURL)
        
//
        
        let selectedAudioClipURL = audioClipsURL[indexPath!.row]
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL:(selectedAudioClipURL))
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch let error as NSError {
            print("Error while playing \(error.localizedDescription)")
        }
        
    }
}
