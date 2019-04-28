//
//  Double+roundTo.swift
//  Eagle Books 2.0
//
//  Created by Lindsay Braun on 4/25/19.
//  Copyright © 2019 Lindsay Braun. All rights reserved.
//

import Foundation
// rounds any Double to "places" places

extension Double {
    func roundTo(places: Int) -> Double {
        let tenToPower = pow(10.0, Double((places >= 0 ? places : 0)))
        let roundedValue = (self * tenToPower).rounded() / tenToPower
        return roundedValue
        
    }
}
