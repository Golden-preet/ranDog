//
//  ViewController.swift
//  ranDog
//
//  Created by Golden on 14/03/21.
//  Copyright © 2021 golden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we need to make sure that our picker view knows which object is the
        //datasource and the delegate
            pickerView.dataSource = self
           pickerView.delegate = self

           //DogApi.requestRandomImage(completionHandler: handleRandomImageResponse(imageData:error:))
        DogApi.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
}
    
    func handleRandomImageResponse(imageData: DogImage?,error: Error?){
        guard let imageURL = URL(string: imageData?.message ?? "")else{
                       return
                   }
                   DogApi.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func handleBreedsListResponse(breeds: [String], error: Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
}



//            do{
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                let url = json["message"] as! String
//                print(url)
//            }catch {
//                print(error)
//            }
//        }
//        task.resume()

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // we want the user to select one value
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // called when pickerView stops spinning
        DogApi.requestRandomImage(breed: breeds[row],completionHandler: handleRandomImageResponse(imageData:error:))
    }
}
