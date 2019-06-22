//
//  Repository.swift
//  WordsGame
//
//  Created by khaledannajar on 6/22/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import Foundation

protocol Repository {
    func getWords(refresh: Bool, completion: @escaping ([Word]?, Error?)-> Void)
    func save(_ words: [Word])
}
