//
//  PlaySoundsViewController.swift
//  Pitch Pefect
//
//  Created by Joel Lester on 3/5/15.
//  Copyright (c) 2015 Joel Lester. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var stopPlayback: UIButton!
    @IBOutlet weak var stopPlaybackLabel: UILabel!
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer=AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
        
        audioEngine=AVAudioEngine()
        audioFile=AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func viewWillAppear(animated: Bool) {
        stopPlayback.hidden=true
        stopPlaybackLabel.hidden=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func slowButton(sender: UIButton) {
        
       playAudio(speed: 0.5,startTime: 0.0, volume: 2.0)
        
       
        
    }
    
    @IBAction func fastPlaybackButton(sender: UIButton) {
        
        playAudio(speed: 1.5,startTime: 0.0, volume: 2.0)
        
    }
    
    
    @IBAction func stopPlaybackButton(sender: UIButton) {
        audioPlayer.stop()
        stopPlayback.hidden=true
        stopPlaybackLabel.hidden=true
    
    }
    
   
    //Play the audio file based on Speed, Start time and Volume given
    func playAudio (speed: Float=0.0, startTime: NSTimeInterval=0.0, volume: Float=1.0){
        
        
        //make sure players and engines are stopped and reset to prevent overlap
        stopResetPlayerEngine()

        
        audioPlayer.rate=speed
        audioPlayer.currentTime=startTime
        audioPlayer.volume = volume
        audioPlayer.play()
        
        //Show the stopPlaybackButton
        stopPlayback.hidden=false
        stopPlaybackLabel.hidden=false
    
    
    }
    
    
    //Hide the stopPlayback button if audio finshed playing
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if (flag){
            stopPlayback.hidden=true
            stopPlaybackLabel.hidden=true
        }
    }
    
    
    @IBAction func playChimpunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(pitch: 1000)
    }
    
   
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(pitch: -1000)
    }
    
    
    //Play audio with variable pitch based on function parameters
    func playAudioWithVariablePitch(pitch: Float = 0.0, volume: Float = 2.0){
        
        //make sure players and engines are stopped and reset
        stopResetPlayerEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        //Create pitch effect and set the level
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.volume = volume
        audioPlayerNode.play()
        
        //Show the stopPlaybackButton
        stopPlayback.hidden=false
        stopPlaybackLabel.hidden=false
    }
    
    
    @IBAction func playAudioWithReverb(sender: UIButton) {
        playAudioWithReverb(reverb: 50.0, volume: 4.0)
    }
    
    
    func playAudioWithReverb (reverb: Float = 0.0, volume: Float = 2.0) {
        stopResetPlayerEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect=AVAudioUnitReverb()
        reverbEffect.wetDryMix=reverb
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format:nil)
        audioEngine.connect(reverbEffect, to:audioEngine.outputNode, format:nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.volume = volume
        audioPlayerNode.play()
        
        //Show the stopPlaybackButton
        stopPlayback.hidden=false
        stopPlaybackLabel.hidden=false
        
    
    }
    
    //Stops and Resets audioPlayer and audioEngine
    func stopResetPlayerEngine () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
  
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
