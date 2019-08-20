//
//  Beer.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

struct Beer {
    let id: Int
    let name: String
    let tagline: String
    let description: String
}

extension Beer: Decodable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case tagline
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let tagline = try container.decode(String.self, forKey: .tagline)
        let description = try container.decode(String.self, forKey: .description)
        
        self.init(id: id, name: name, tagline: tagline, description: description)
    }
}
