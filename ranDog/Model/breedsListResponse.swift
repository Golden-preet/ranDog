//
//  breedsListResponse.swift
//  ranDog
//
//  Created by Golden on 20/03/21.
//  Copyright © 2021 golden. All rights reserved.
//

import Foundation

struct BreedsListResonse:Codable{
    let status: String
    let message:[String:[String]]   
}
