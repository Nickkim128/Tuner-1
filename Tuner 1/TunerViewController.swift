//
//  ViewController.swift
//  Guitar Tuner
//
//  Created by Nicholas Kim on 2020/07/20.
//  Copyright © 2020 Nicholas Kim. All rights reserved.
//

import UIKit
import AudioKit

class TunerViewController: UIViewController {

    //Properties
    @IBOutlet weak var frequencyTrack: UILabel!
    @IBOutlet weak var updown: UILabel!
    
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    let tuneInterval = 0.05
    var tuneTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    
    // Start Tuning
    @IBAction func start(_ sender: Any) {
        start()
    }
    
    //Stop Tuning
    @IBAction func stop(_ sender: Any) {
        stop()
        frequencyTrack.text = "Nearest Note"
        updown.text = "Tune Up/Down"
    }
    
    
    // Start the polling through the microphone calling the pollingTick function every 0.05 seconds, or tuneInterval
    func start() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: [])
        } catch let error {
                print(error.localizedDescription)
        }
        
        //Set up the AudioSession
        mic = AKMicrophone()!
        AKSettings.audioInputEnabled = true
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain:0)
        
        AudioKit.output = silence
        
        do {
            try AudioKit.start()
        } catch let error {
            print(error.localizedDescription)
        }
        
        frequencyTrack.font = frequencyTrack.font.withSize(70)
        
        tuneTimer = Timer.scheduledTimer(timeInterval: tuneInterval, target: self, selector: #selector(pollingTick), userInfo: nil, repeats: true)
    }
    
    // Stop polling the audio and to stop calling pollingTick
    func stop() {
        do {
            try AudioKit.stop()
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let instance = tuneTimer {
            instance.invalidate()
        }
        
        frequencyTrack.font = frequencyTrack.font.withSize(50)
        frequencyTrack.textColor = UIColor.white
    }
    
    /*Gets the frequency through the microphone, gets the pitch to the nearest note, calculates
     the errorRatio from the obtained frequency to the frequency of the closest note,
     displays the closest note, and indicates whether to tune up, tune down, or stay the same for the nearest note
 */
    @objc func pollingTick() {
        let frequency = Double(tracker.frequency)
        let pitch = Pitch.findClosestNote(frequency)
        let errorRatio = frequency / pitch.frequency
        
        frequencyTrack.text = toNote(note: pitch.note) + " " + toSharpFlat(note: pitch.note)
        
        if (errorRatio > 1.01){
            updown.text = "Tune Down"
            frequencyTrack.textColor = UIColor.red
        }
        else if (errorRatio < 0.99){
            updown.text = "Tune Up"
            frequencyTrack.textColor = UIColor.red
        }
        else{
            updown.text = "Got It"
            frequencyTrack.textColor = UIColor.green
        }
        
    }
    
    
    // Returns the String of the note
    func toNote(note: Note) -> String{
        if (note.aNote.rawValue == 0){
            return "A"
        }
        if (note.aNote.rawValue == 1){
            return "B"
        }
        if (note.aNote.rawValue == 2){
            return "C"
        }
        if (note.aNote.rawValue == 3){
            return "D"
        }
        if (note.aNote.rawValue == 4){
            return "E"
        }
        if (note.aNote.rawValue == 5){
            return "F"
        }
        if (note.aNote.rawValue == 6){
            return "G"
        }
        return "None Found"
    }
    
    // Returns the String of whether a note is sharp, flat, or natural
    func toSharpFlat(note: Note) -> String{
        if (note.aAccidental.rawValue == 1){
            return "Sharp"
        }
        if (note.aAccidental.rawValue == 2){
            return "Flat"
        }
        return ""
    }
    
    

}
