//
//  Petition.swift
//  NewsExample
//
//  Created by MAC on 2.09.2022.
//

import Foundation

struct Petition : Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
