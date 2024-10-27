//
//  ViewControllerDos.swift
//  Melody Match
//
//  Created by Owen Strader on 10/27/24.
//

import UIKit
import AVFoundation

var audioPlayer: AVAudioPlayer?
var isPlaying = false

func playAudio(songTitle: String) {
    guard let url = Bundle.main.url(forResource: songTitle, withExtension: "mp3") else { // Replace with your audio file name and extension
            print("Audio file not found")
            return
        }
        
        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
////            audioPlayer?.prepareToPlay()
////            audioPlayer?.play()
//
//            if isPlaying {
//                audioPlayer?.pause()
//            }
//            else {
//                audioPlayer?.prepareToPlay()
//                audioPlayer?.play()
//            }
            if audioPlayer == nil {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
            }
            
            if isPlaying {
                audioPlayer?.pause()
            } else {
                audioPlayer?.play()
            }
            
            isPlaying.toggle()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
}

class ViewControllerDos: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func displaySongTitle() {
        
    }
    func displayGenre() {
        
    }
    func displayConfidence() {
        // Display confidence number
    }
    func getSongID() {
        
    }
    @IBAction func playSongButton(_ sender: Any) {
        playAudio(songTitle: "swag")
    }
    @IBOutlet weak var songTitle: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var confidenceLevelLabel: UILabel!
}
