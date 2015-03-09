//
//  RecordSoundsViewController.swift
//  Pitch Pefect
//
//  Created by Joel Lester on 3/4/15.
//  Copyright (c) 2015 Joel Lester. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var stopRecordingLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(animated: Bool) {
        
        //Enable recording button when the view loads
        recordButton.enabled=true
        pauseButton.hidden=true
        
        //Ensure the Text for the Record button is set
        recordingInProgress.text="Tap to Record"
        
        //Hide the stop button
        stopRecording.hidden=true
        stopRecordingLabel.hidden=true
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
       //Disable Record Button to prevent multiple presses
        recordButton.enabled=false
        pauseButton.hidden=false
        
        //Show "Recording..." Message
        recordingInProgress.text="Tap to Pause Recording..."
 
        //Show stopRecording Button
        stopRecording.hidden=false
        stopRecordingLabel.hidden=false
        
        //TODO: Record user's voice
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Initialize and prepare the audio recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
        
    }
    @IBAction func pauseResumeRecording(sender: UIButton) {
        
        //Create Constants for the Pause and Resume Buttons
        let recordImage = UIImage(named: "microphone~iphone.png") as UIImage!
        let pauseImage = UIImage(named: "pause~iphone.png") as UIImage!
        
        //If Recording Pause. If Paused Resume recording
        if (audioRecorder.recording) {
            audioRecorder.pause()
            pauseButton.setImage(recordImage, forState: .Normal)
            recordingInProgress.text="Tap to Resume Recording..."
            
        } else {
            audioRecorder.record()
            pauseButton.setImage(pauseImage, forState: .Normal)
            recordingInProgress.text="Tap to Pause Recording..."
           
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //if Audio recorded successfully then segue to the next screen
        if(flag) {
            recordedAudio=RecordedAudio(filePathTemp: recorder.url,titleTemp: recorder.url.lastPathComponent! )
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording Failed")
            recordButton.enabled=true
            stopRecording.hidden=true
            stopRecordingLabel.hidden=true
        }
        
    }
    
    //peform segue action based on segue identifier
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
          
            //get data recorded and send to the next view
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    
    
    //Declared Globally
    
  
    
}

