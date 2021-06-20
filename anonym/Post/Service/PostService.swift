//
//  File.swift
//  anonym
//
//  Created by Nikita Fedorenko on 11.06.2021.
//

import Foundation

enum Order : String {
    case popular = "mostPopular"
    case commented = "mostCommented"
    case created = "createdAt"
}

protocol PostServiceProtocol {
    func fetch(first: Int, after: String, orderBy: Order, completion: @escaping (PostResponse) -> Void ) -> Void
    func getTextContent(data: [ContentData]) -> [ContentData]
}

class PostService: PostServiceProtocol {
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch(first: Int, after: String, orderBy: Order, completion: @escaping (PostResponse) -> Void){
        
        var urlComponents = URLComponents(string: "https://k8s-stage.apianon.ru/posts/v1/posts")!
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "first", value: String(first)))
        if after != ""{
            queryItems.append(URLQueryItem(name: "after", value: after))
        }
        queryItems.append(URLQueryItem(name: "orderBy", value: orderBy.rawValue))
        
        urlComponents.queryItems = queryItems
        
        print("get request: \(urlComponents.url!)")
        
        let task = session.dataTask(with: urlComponents.url!){ data, response, error in
            
            if let error = error{
                print("client error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else{
                //{"errors":[{"message":"Invalid cursor","code":"UNSPECIFIED"}]}
                print("server error")
                return
            }
            
            if let data = data {
                
                do{
                    let jsonData = try JSONDecoder().decode(PostResponse.self, from: data)
                    completion(jsonData)
                }catch{
                    print("error while converting response data to json: \(error.localizedDescription)")
                }
            }
            
        }
        
        task.resume()
    }
    
    func getTextContent(data: [ContentData]) -> [ContentData] {
        return data.filter({data in data.type == "TEXT"})
    }
}
