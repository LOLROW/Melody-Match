import Foundation

public class WebServerQuerier{
    public static func fetchData(from url: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON decoding error"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // Usage
    public static func getSongID() -> Int? {
        let esp8266URL = "http://192.168.4.1/data"
        var songID: Int? = nil
        
        fetchData(from: esp8266URL) { result in
            switch result {
            case .success(let json):
                print("JSON Data: \(json)")
                // Forcefully unwrap since "id" is always present
                songID = json["id"] as? Int // Safely unwrapping for potential safety
                print("ID: \(songID!)") // Print the ID
            case .failure(let error):
                // Print error message
                print("Error: \(error.localizedDescription)")
            }
        }
        
        return songID // This will return nil immediately since fetchData is async
    }
}
