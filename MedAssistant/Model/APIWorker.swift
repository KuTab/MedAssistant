//
//  APIWorker.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 05.04.2022.
//

import Foundation

class APIWorker {
    static let shared = APIWorker()
    
    func sendNewDrug() async {
//        guard let url = URL(string: "")
    }
    
    func loginRequest(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) { //async
        let finalUrl: String = "https://telesfor.herokuapp.com/login?username=\(username)&password=\(password)"
        guard let url = URL(string: finalUrl) else {
            print("Wrong login url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            print(response.statusCode)

            DispatchQueue.main.async {
                do {
                    print(data)
                    let decodedResponse = String(data: data, encoding: .utf8)!
                    print(decodedResponse)
                    if (decodedResponse == "Api is working! Hello ^^") {
                        completion(.success(true))
                        print("set to true")
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
