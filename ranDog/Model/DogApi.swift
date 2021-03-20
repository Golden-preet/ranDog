//
//  DogApi.swift
//  ranDog
//
//  Created by Golden on 14/03/21.
//  Copyright © 2021 golden. All rights reserved.
//

import UIKit

class DogApi{
    enum Endpoint{
        case randomImageFromAllDogsCollection
        
        // has param of type String
        case randomImageForBreed(String)
        
        case listAllBreeds
        
    // computed property to access this endpoint as url
    var url: URL{
        // use constructor to convert self.rawValue into a url
        // since it returns an optional, unwrap it
        //return URL(string: self.rawValue)!
        
        return URL(string: self.stringValue)!
    }
        
        var stringValue:String{
            switch self{
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
                
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/\(breed))/hound/images"
                
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
  }
    // marking it as class method because we dont need to use an instance of DogApi class to call this method
    
    class func requestRandomImage(breed: String, completionHandler: @escaping(DogImage?, Error?) -> Void){
       // let randomImageEndpoint = DogApi.Endpoint.randomImageFromAllDogsCollection.url
       let randomImageEndpoint = DogApi.Endpoint.randomImageForBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint){(data, response, error)in
                   guard let data = data else{
                    completionHandler(nil,error)
                       return
                   }
                   //print(data)
                   
                   let decoder = JSONDecoder()
                   let imageData = try! decoder.decode(DogImage.self, from: data)
                   print(imageData)
            completionHandler(imageData,nil)
        }
        task.resume()
    }
    
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data,response,error)in
                       guard let data = data else{
                        completionHandler(nil,error)
                        return
            }
                       let downloadedImage = UIImage(data:data)
                       completionHandler(downloadedImage,nil)
    })
        task.resume()
    }
    
    class func requestBreedsList(completionHandler: @escaping([String], Error?) -> Void){
        let listAllBreeds = DogApi.Endpoint.listAllBreeds.url
        
        let task = URLSession.shared.dataTask(with: listAllBreeds){(data, response, error) in
            guard let data = data else{
                completionHandler([], error)
                return
            }
           let decoder = JSONDecoder()
            do {
            let breedsResponse = try decoder.decode(BreedsListResonse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds,nil)
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}
