//
//  SunriseSunsetModel.swift
//  SunriseSunsetApp
//
//  Created by Nadiia Pavliuk on 6/22/18.
//  Copyright © 2018 ios. All rights reserved.
//

import Foundation

struct Root: Decodable {
    let results: SunriseSunsetData

}

struct SunriseSunsetData: Decodable {
    let sunrise: String?
    let sunset: String?
}
