//
//  ViewController.swift
//  Melody Match
//
//  Created by Owen Strader on 10/26/24.
//

import UIKit
import Network
import AVFoundation

struct Song: Codable {
    let id: Int        // Identifier for the song
    let title: String
    let artist: String
    let url: String
}

class ViewController: UIViewController {

    var songs: [Song] = []
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongs()
    }
    
    @IBAction func playMusic(_ sender: Any) {
        fetchSongIdFromServer { songId in
            self.playSong(withId: songId)
        }
    }

    func loadSongs() {
        guard let url = Bundle.main.url(forResource: "songs", withExtension: "json") else {
            print("Failed to find songs.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            songs = try decoder.decode([Song].self, from: data)
            print("Loaded songs: \(songs)")
        } catch {
            print("Error loading songs: \(error.localizedDescription)")
        }
    }

    func fetchSongIdFromServer(completion: @escaping (Int) -> Void) {
        guard let url = URL(string: "https://yourserver.com/api/getSongId") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching song ID: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                // Assuming the server responds with JSON containing an integer ID
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let songId = json["playSongId"] as? Int {
                    // Call the completion handler with the song ID
                    completion(songId)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func playSong(withId songId: Int) {
        let songID = WebServerQuerier.getSongID();
        guard let song = songs.first(where: { $0.id == songId }) else {
            print("Song not found for ID: \(songId)")
            return
        }

        // Assuming audio files are stored in the app bundle
        guard let audioFileURL = Bundle.main.url(forResource: song.url, withExtension: nil) else {
            print("Audio file not found: \(song.url)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.play()
            print("Playing: \(song.title) by \(song.artist)")
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
}
