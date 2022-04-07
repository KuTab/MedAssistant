//
//  APIWorker.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 05.04.2022.
//

import Foundation

final class APIWorker {
    static let shared = APIWorker()
    
    //MARK: - API Call to get user ID
    func getUserID(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: "https://telesfor.herokuapp.com/api/users/current") else {
            print("Wrong url")
            return
        }
        
        var request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let decodedResponse = try JSONDecoder().decode(CurrentUserModel.self, from: data)
                    print(decodedResponse.id)
                    completion(.success(decodedResponse.id))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    
    //MARK: - API Call to adding drug service
    func sendNewDrug(id: Int, name: String, startDate: String, endDate: String, numDays: String, type: String, dosage: String){
        guard let url = URL(string: "https://telesfor.herokuapp.com/api/medicaments/patient/add") else {
            print("Wrong url")
            return
        }
        
        let json = ["name" : name, "startDate" : startDate, "endDate" : endDate, "numDays" : numDays, "type": type, "dosage": dosage, "patientId" : String(id)] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            print(response.statusCode)
            
            
            
            DispatchQueue.main.async {
                let decodedResponse = String(data: data, encoding: .utf8)
                print(decodedResponse)
            }
        }
        
        dataTask.resume()
    }
    
    //MARK: - API Call to login service
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
    
    //MARK: - API Call to register service
    func registerRequest(username: String, surname: String, patronymic: String, phoneNumber: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let finalUrl: String = "https://telesfor.herokuapp.com/api/registration"
        
        let json = ["phoneNumber": phoneNumber, "password": password, "firstName": username, "lastName": surname, "patronymic": patronymic]
        print(JSONSerialization.isValidJSONObject(json))
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(jsonData!)
        
        guard let url = URL(string: finalUrl) else {
            print("Wrong registration url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
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
                    //print(data)
                    let decodedResponse = String(data: data, encoding: .utf8)
                    completion(.success(decodedResponse!))
                    print(decodedResponse!)
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()
    }
    
    //MARK: - API Call to confirmation service
    func confirmRequest(code: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let finalUrl: String = "https://telesfor.herokuapp.com/api/registration/confirm?code=\(code)"
        
        guard let url = URL(string: finalUrl) else {
            print("Wrong confirm url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
                    if (decodedResponse == "confirmed") {
                        completion(.success(true))
                        //print("set to true")
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
