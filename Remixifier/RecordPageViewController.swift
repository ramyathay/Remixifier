//
//  ViewController.swift
//  Remixifier
//

import Foundation
import UIKit
import AVFoundation

class RecordPageViewController: UIViewController,  AVAudioPlayerDelegate, AVAudioRecorderDelegate{

//    
//    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var RecordingComplete: UILabel!
//    @IBOutlet weak var cancelRecordingButton: UIButton!
    @IBOutlet weak var cancelRecordingButton: UIButton!
    @IBOutlet weak var recordingProgress: UIProgressView!

    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var recordedAudio: RecordedAudio!
    var clipToAdd = Clip?()
    var clipCreatedAt: NSDate = NSDate()
    weak var delegate: RecordingPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //only show the logo and the record button
        RecordingComplete.hidden = true
        cancelRecordingButton.hidden = true
        saveRecordingButton.hidden = true
        stopButtonOutlet.hidden = true
        playButtonOutlet.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var saveRecordingButton: UIButton!
    
    @IBAction func saveRecording(sender: UIButton) {
    
        RecordingComplete.text = "Saved!"
        //call to save into DB, transition into next page, other tell user to press the next tab button
        let clip = Clip(obj: String(recordedAudio!.title),audio_url: recordedAudio.filePathURL)
        delegate?.recordPageViewController(self, didFinishAddingClip: clip)
        clip.save()
        cancelRecordingButton.hidden = true
        saveRecordingButton.hidden = true
        recordButtonOutlet.hidden = false
        stopButton.hidden = true
        RecordingComplete.hidden = true
        playButton.hidden = true
        
    }
    
    @IBAction func CancelRecording(sender: UIButton) {
        //hide the success message + buttons
        RecordingComplete.hidden = true
        cancelRecordingButton.hidden = true
        saveRecordingButton.hidden = true
        
        //hide the stop and play buttons
        stopButtonOutlet.hidden = true
        playButtonOutlet.hidden = true
        //show the record button, back to start
        recordButtonOutlet.hidden = false
    }
    
   
    @IBAction func recordAudiouchOnTo(sender: UIButton) {
        
        
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    
                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    try! audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
                    
                    
                    //get documnets directory
                    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                    let fullPath = documentsDirectory.stringByAppendingPathComponent(self.shortDate)
                    let url = NSURL(fileURLWithPath: fullPath)
                    
                    //create AnyObject of settings
                    let settings: [String : AnyObject] = [
                        AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
                        AVSampleRateKey:44100.0,
                        AVNumberOfChannelsKey:2,
                        AVEncoderBitRateKey:12800,
                        AVLinearPCMBitDepthKey:16,
                        AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
                    ]
                    print("URl of the audio clip",url)
                    //record
                    try! self.audioRecorder = AVAudioRecorder(URL: url, settings: settings)
                    self.audioRecorder?.delegate = self
                    self.audioRecorder?.prepareToRecord()
                    self.audioRecorder?.recordForDuration(5.0)

                    self.recordButtonOutlet.hidden = true
                    //show the stop button to stop
                    self.stopButtonOutlet.hidden = false
                }
                else{
                    print("not granted")
                }
                
            })
        }
    }
    
    //Conforms to AVAudioRecorderDelegate protocol :-
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //save the recorded audio
        recordedAudio = RecordedAudio()
        recordedAudio.filePathURL = recorder.url
        recordedAudio.title = String((recorder.url.lastPathComponent)!)
        print("The recorded audio is",recordedAudio.title)

        self.RecordingComplete.hidden = false
                                //show the cancel button to restart if desired
        self.cancelRecordingButton.hidden = false
                                //show the save button to continue
        self.saveRecordingButton.hidden = false
                                //keep the record and stop buttons hidden
        self.recordButtonOutlet.hidden = true
        self.stopButtonOutlet.hidden = true
                                //show the play button
        self.playButtonOutlet.hidden = false
    }
    
    @IBAction func stopRecordingOnTouch(sender: UIButton) {
    print("Stop recording")
        if audioRecorder!.recording {
            print("Recording in progress")
        }
        audioRecorder?.stop()
        print("Stopped recording")
        //once we stop, show the success message, show the cancel recording and save recording button, hide the record and stop button, show the play button
        RecordingComplete.hidden = false
        cancelRecordingButton.hidden = false
        saveRecordingButton.hidden = false
        recordButtonOutlet.hidden = true
        stopButtonOutlet.hidden = true
        playButtonOutlet.hidden = false
//        recordingProgress.hidden = true
    }
    
    
    @IBAction func playButton(sender: UIButton) {
        do {
            //try activating the audio player, with the url (filepath)
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: (audioRecorder?.url)!)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        }
        catch let error as NSError {
            print("Error while playing \(error.localizedDescription)")
        }
    }
    
    var shortDate: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-yy-ss"
        return dateFormatter.stringFromDate(NSDate())
    }

    
    func didFinishAddingClip(){
        
    }
    
// 
//func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
//    print("Error while recording audio \(error.localizedDescription)")
//}
//
//func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
//}
//
//func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!) {
//    print("Audio Play Decode Error")
//}
//
//func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!) {
//    print("Audio Record Encode Error")
//}
//
//func playAudioWithVariablePitch(pitch: Float){
//    audioPlayer!.stop()
//    audioEngine.stop()
//    audioEngine.reset()
//    
//    var audioPlayerNode = AVAudioPlayerNode()
//    audioEngine.attachNode(audioPlayerNode)
//    
//    var changePitchEffect = AVAudioUnitTimePitch()
//    changePitchEffect.pitch = pitch
//    audioEngine.attachNode(changePitchEffect)
//    
//    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
//    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
//    
//    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
//    //audioEngine.startAndReturnError(nil)
//    
//    audioPlayerNode.play()
//}



}

