//
//  ImageLoader.swift
//  anonym
//
//  Created by Nikita Fedorenko on 17.06.2021.
//

import Foundation
import UIKit

class ImgLoader {
    
    var cache = NSCache<NSString, UIImage>()
    
    func load(from path: String, completion: @escaping (UIImage) -> Void) {
        if let image = self.cache.object(forKey: path as NSString){
            DispatchQueue.main.async {
                completion(image)
            }
        }
        else
        {
            let placeholder = UIImage(systemName: "person.circle")!
            DispatchQueue.main.async {
                completion(placeholder)
            }
            
            if let url = URL(string: path){
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url){
                        if let img = UIImage(data: data){
                            self.cache.setObject(img, forKey: path as NSString)
                            DispatchQueue.main.async {
                                completion(img)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
