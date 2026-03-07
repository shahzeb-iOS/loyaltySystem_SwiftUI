import Foundation

struct APIService {
    private let baseURL = "https://api.example.com/"
    
    // Function to get all services
    func getAllServices(completion: @escaping (Result<[Service], Error>) -> Void) {
        let url = URL(string: baseURL + "services")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1, userInfo: nil)))
                return
            }
            do {
                let services = try JSONDecoder().decode([Service].self, from: data)
                completion(.success(services))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Function to get promotions
    func getPromotions(completion: @escaping (Result<[Promotion], Error>) -> Void) {
        let url = URL(string: baseURL + "promotions")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1, userInfo: nil)))
                return
            }
            do {
                let promotions = try JSONDecoder().decode([Promotion].self, from: data)
                completion(.success(promotions))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Function to get user appointments
    func getUserAppointments(userId: String, completion: @escaping (Result<[Appointment], Error>) -> Void) {
        let url = URL(string: baseURL + "appointments?userId=\(userId)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1, userInfo: nil)))
                return
            }
            do {
                let appointments = try JSONDecoder().decode([Appointment].self, from: data)
                completion(.success(appointments))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct Service: Codable {
    let id: String
    let name: String
}

struct Promotion: Codable {
    let id: String
    let title: String
    let discount: Double
}

struct Appointment: Codable {
    let id: String
    let userId: String
    let date: String
}