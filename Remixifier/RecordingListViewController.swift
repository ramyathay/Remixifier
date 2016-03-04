//
//  RecordingListViewController.swift
//  Remixifier

import Foundation
import UIKit
import AVFoundation


class RecordingListViewController:  UIViewController, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var recordedClipsTable: UITableView!
    
    
    var clips: [Clip] = Clip.all()
    //var audioClipsNames = ["20160117134854","20160117131959"]
    var audioClipsURL = [Clip]()
    var userSelectedAudioClips = [NSURL]()
    var audioPlayer: AVAudioPlayer?
    var audioQueuePlayer: AVQueuePlayer?
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let clips: [Clip] = Clip.all()
        for clip in clips {
    //clip.objective should be the title, not the file URL, need to access the URL of each clip
            audioClipsURL.append(clip)
        }
        recordedClipsTable.dataSource = self
        recordedClipsTable.delegate = self
        self.recordedClipsTable.allowsMultipleSelection = true
        recordedClipsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("audioClipCell", forIndexPath: indexPath)
        print("Obj is",(clips[indexPath.row].objective))
        let cell_text = clips[indexPath.row].objective
        cell.textLabel!.text = cell_text
        print(cell,cell_text)
       

        if cell.selected
        {
            cell.selected = false
            if cell.accessoryType == UITableViewCellAccessoryType.None
            {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clips = Clip.all()
        return clips.count
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        print("Selected cell is",cell?.textLabel?.text,cell)
        if cell!.selected
        {
            cell!.selected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.None
            {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else
            {
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        let fileURL = clips[indexPath.row].audioURL
        userSelectedAudioClips.append(fileURL)
        print("Selected songs array",userSelectedAudioClips)
        
        let selectedAudioClipURL = audioClipsURL[indexPath.row].audioURL
        print("SelectedAudioClip ",selectedAudioClipURL)
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPath = documentsDirectory.stringByAppendingPathComponent((clips[indexPath.row].objective))
        let url = NSURL(fileURLWithPath: fullPath)
        print("Newly formed song url",url)
        
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try! audioSession.setActive(true)
        //try! audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        
        do {
            //self.audioPlayer = try AVAudioPlayer(contentsOfURL:(selectedAudioClipURL))
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            audioPlayer?.volume = 1000 
        }
        catch let error as NSError {
            print("Error while playing \(error.localizedDescription)")
        }
    }
}



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
