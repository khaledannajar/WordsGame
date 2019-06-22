//
//  Word.swift
//  WordsGame
//
//  Created by khaledannajar on 6/21/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import Foundation

struct Word : Codable {
    
    let textEng : String?
    let textSpa : String?
    
    
    enum CodingKeys: String, CodingKey {
        case textEng = "text_eng"
        case textSpa = "text_spa"
    }
    
}

