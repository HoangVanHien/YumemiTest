//
//  ViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by mk1 on 30/08/2022.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

class ViewModel {
    var favorite: [Bool] = []
    var repo: [[String: Any]] = [] {
        didSet {
            var i = 0
            while i < repo.count {
                favorite.append(false)
                i += 1
            }
        }
    }
    var task: URLSessionTask?
    var word: String?
    var url: String?
    var idx: Int?
}
