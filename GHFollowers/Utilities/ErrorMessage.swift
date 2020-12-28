//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Jeff Morhous on 5/3/20.
//  Copyright © 2020 Jeff Morhous. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request, please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid from server. Please try again."
    case invalidData = "Data received from server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
}
