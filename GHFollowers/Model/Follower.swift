//
//  Follower.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 4/18/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}
