import UIKit

class ViewControllerDos: UIViewController {
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var confidenceLevelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await getSongData()
        }
    }
    
    // Function to get song data asynchronously
    func getSongData() async {
        if let id = await WebServerQuerier.getSongID() {
            print("Fetched Song ID: \(id)")
            loadSongData(for: id)
        } else {
            print("Failed to fetch Song ID")
        }
    }

    // Function to load song data
    func loadSongData(for id: Int) {
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
    }
    
    @IBAction func playSongButton(_ sender: Any) {
        // Add your play song logic here
    }
    
    @IBAction func stopSong(_ sender: Any) {
        // Add your stop song logic here
    }
}
