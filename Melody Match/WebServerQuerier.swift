import Foundation

public class WebServerQuerier {
    
    // Function to fetch data asynchronously
    public static func fetchData(from url: String) async throws -> [String: Any] {
        guard let url = URL(string: url) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Check for HTTP response status
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON decoding error"])
            }
        } catch {
            throw error
        }
    }

    // Function to get the Song ID asynchronously
    public static func getSongID() async -> (id:Int?, genre:String?, bpm:Double?) {
        let esp8266URL = "http://192.168.4.1/viewserverdata"
        do {
            let json = try await fetchData(from: esp8266URL)
            print("JSON Data: \(json)")
            // Forcefully unwrap since "id" is always present
            return (json["id"] as? Int, json["genre"] as? String, json["bpm"] as? Double)
        } catch {
            print("Error fetching song ID: \(error.localizedDescription)")
            return (nil,nil,nil)
        }
    }

    // Function to request the next song asynchronously
    public static func requestNextSong() async -> Bool {
        let esp8266URL = "http://192.168.4.1/clientdata"
        guard let url = URL(string: esp8266URL) else {
            print("Invalid URL")
            return false
        }

        // Create the JSON payload
        let jsonPayload: [String: Any] = ["code": 14]
        
        // Convert payload to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonPayload, options: []) else {
            print("Error creating JSON data")
            return false
        }

        // Set up the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check for HTTP response status
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return false
            }

            print("Successfully requested next song")
            return true
        } catch {
            print("Error requesting next song: \(error.localizedDescription)")
            return false
        }
    }
}
