//
//  DBModelManagerProtocol.swift
//  Vincles BCN
//
//  Copyright © 2018 i2Cat. All rights reserved.



import UIKit

protocol DBModelManagerProtocol {
    func databaseHasItems() -> Bool
    func removeAllItemsFromDatabase()
}
