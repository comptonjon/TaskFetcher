//
//  SessionManager.swift
//  TaskFetcher
//
//  Created by Jonathan Compton on 11/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation

class SessionManager {
    
    var currentUser: LocalUser!
    var isLoggedIn = false
    
    private init(){}
    
    static let shared = SessionManager()
}


