//
//  ItemHero.swift
//  HeroRandomizer
//
//  Created by Aisha Suanbekova Bakytjankyzy on 21.11.2024.
//

import Foundation
import UIKit

struct APIHero: Decodable {
    let name: String
    let biography: Biography
    let images: HeroImage

    struct Biography: Decodable {
        let fullName: String
        let firstAppearance: String
        let publisher: String
        let alignment: String
    }

    struct HeroImage: Decodable {
        let sm: String
    }
}
