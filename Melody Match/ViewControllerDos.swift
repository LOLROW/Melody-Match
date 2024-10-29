import UIKit
import AVFoundation


class ViewControllerDos: UIViewController {
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var confidenceLevelLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var currentSong = ""
    var songIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func playAudio(songID: Int) {
        guard let url = Bundle.main.url(forResource: "\(songIndex)", withExtension: "mp3") else { // Replace with your audio file name and extension
                print("Audio file not found")
                return
            }
        
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                }
                
                if isPlaying {
                    audioPlayer?.pause()
                    playButton.setTitle("Play", for: .normal)
                } else {
                    audioPlayer?.play()
                    playButton.setTitle("Pause", for: .normal)
                }
                
                isPlaying.toggle()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
    }
    
    // Function to get song data asynchronously

    // Function to load song data
    /*func loadSongData(for id: Int) {
        guard let url = Bundle.main.url(forResource: "songDB", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let songInfo = json[String(id)] as? [String: Any] {
                DispatchQueue.main.async {
                    self.songTitle.text = songInfo["Title"] as? String
                    self.genreLabel.text = songInfo["Genre"] as? String
                    self.confidenceLevelLabel.text = songInfo["Level"] as? String
                }
            } else {
                print("Failed to parse JSON")
            }
        } catch {
            print("Error loading or parsing JSON: \(error.localizedDescription)")
        }
    }*/
    
    @IBAction func playSongButton(_ sender: Any) {
        playAudio(songID: songIndex)
    }
    
    @IBAction func restartButton(_ sender: Any) {
        if let currentTime = audioPlayer?.currentTime, currentTime <= 2.0 {
            songIndex -= 1
            if songIndex < 0 {
                songIndex += 1
            }
            audioPlayer = nil
            playAudio(songID: songIndex)
        }
        else {
            audioPlayer?.currentTime = 0
            playAudio(songID: songIndex)
        }
    }
    
    @IBAction func skipSongButton(_ sender: Any) {
        /*songIndex += 1
        if songIndex > songs.count {
            songIndex = songs.count - 1
        }
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            isPlaying = false
        }
        audioPlayer = nil
        playAudio(songID: songIndex)*/
        Task {
            let res = await WebServerQuerier.requestNextSong();
            if res == false {
                print("failed to request next song");
            }
            while true {
                if let id = await WebServerQuerier.getSongID() as? (Int?, String?, Double?) {
                    if songIndex == id.0! {
                        continue;
                    }
                    print("Fetched Song ID: \(id.0!)")
                    songIndex = id.0!
                    self.songTitle.text = "Song ID: \(id.0!)";
                    self.genreLabel.text = "Genre: \(id.1!)";
                    self.confidenceLevelLabel.text = "BPM: \(Int(ceil(id.2!)))";
                    audioPlayer = nil
                    playAudio(songID: songIndex);
                    return;
                } else {
                    print("Failed to fetch Song ID")
                }
            }
        }
    }
}
