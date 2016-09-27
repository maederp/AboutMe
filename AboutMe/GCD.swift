//
//  GCD.swift
//  AboutMe
//
//  Created by Peter Mäder on 26.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain( updates: @escaping () -> Void) {
    
    DispatchQueue.main.async(execute:  {
        updates()
    })
    
}
