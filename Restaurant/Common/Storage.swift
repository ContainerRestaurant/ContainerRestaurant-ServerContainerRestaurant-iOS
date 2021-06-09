//
//  Storage.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/07.
//

import Foundation

public class Storage {
    static func isFirstEntry() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstEntry") == nil {
            defaults.set("No", forKey:"isFirstEntry")
            return true
        } else {
            return false
        }
    }
}
