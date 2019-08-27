//
//  Beer.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

struct Beer: Decodable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case tagline
        case image_url
        case description
        case ingredients
    }
    
    enum AdditionalCodingKeys: CodingKey {
        case malt
    }
    
    let id: Int
    let name: String
    let malts: [Malt]
    let tagline: String
    let imageUrl: String?
    let description: String
    
    init(id: Int,
         name: String,
         malts: [Malt],
         tagline: String,
         imageUrl: String?,
         description: String) {
        self.id = id
        self.name = name
        self.malts = malts
        self.tagline = tagline
        self.imageUrl = imageUrl
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id) 
        name = try container.decode(String.self, forKey: .name)
        tagline = try container.decode(String.self, forKey: .tagline)
        description = try container.decode(String.self, forKey: .description)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .image_url)
        
        let additionalContainer = try container.nestedContainer(keyedBy: AdditionalCodingKeys.self, forKey: .ingredients)
        malts = try additionalContainer.decode([Malt].self, forKey: .malt)
    }
}
