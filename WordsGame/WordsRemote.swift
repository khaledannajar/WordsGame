//
//  WordsRemote.swift
//  WordsGame
//
//  Created by khaledannajar on 6/22/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import Foundation

class WordsRemote: Repository {
    func getWords(refresh: Bool, completion: @escaping ([Word]?, Error?) -> Void) {
        guard let wordsUrl = URL(string: "https://gist.githubusercontent.com/DroidCoder/7ac6cdb4bf5e032f4c737aaafe659b33/raw/baa9fe0d586082d85db71f346e2b039c580c5804/words.json") else {
            print("Repository.Remote: could not create url")
            //TODO: report this in the Analytics
            return
        }
        
        URLSession.shared.dataTask(with: wordsUrl, completionHandler: { (data, urlResponse, error) in
            var words: [Word]?
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    words = try decoder.decode([Word].self, from: data)
                } catch {
                    // TODO: report this in the Analytics
                    print(error)
                }
                completion(words, error)
            }
        }).resume()
    }
    func save(_ words: [Word]) {
        fatalError("This should not be reached")
    }
}
