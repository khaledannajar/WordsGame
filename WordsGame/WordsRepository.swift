//
//  WordsRepository.swift
//  WordsGame
//
//  Created by khaledannajar on 6/22/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import Foundation

// we create a repository for each module if needed
class WordsRepository: Repository {
    
    var remote: Repository = WordsRemote() // TODO: inject this
    var local: Repository = WordsLocal() // TODO: inject this
    
    func getWords(refresh: Bool, completion: @escaping ([Word]?, Error?) -> Void) {
        if refresh {
            remote.getWords(refresh: refresh, completion: completion)
        } else {
            local.getWords(refresh: refresh, completion: completion)
        }
    }
    
    func save(_ words: [Word]) {
        local.save(words)
    }
}
