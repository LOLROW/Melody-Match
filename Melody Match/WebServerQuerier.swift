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
    public static func getSongID() async -> Int? {
        let esp8266URL = "http://192.168.4.1/data"
        do {
            let json = try await fetchData(from: esp8266URL)
            print("JSON Data: \(json)")
            // Forcefully unwrap since "id" is always present
            return json["id"] as? Int
        } catch {
            print("Error fetching song ID: \(error.localizedDescription)")
            return nil
        }
    }
}
