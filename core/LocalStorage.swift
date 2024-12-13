//
//  LocalStorage.swift
//  core
//
//  Created by Lasha Tavberidze on 13.12.24.
//

import Foundation

class UserStorage{
    static let shared = UserStorage()
    private let key = "userInput"
    private init(){}
    func saveUserInput(_ inputs: [String]){
        UserDefaults.standard.set(inputs, forKey: key)
    }
    func loadUserInput() -> [String]?{
        UserDefaults.standard.stringArray(forKey: key)
    }
    func eraseUserInput(){
        UserDefaults.standard.removeObject(forKey: key)
    }
}
