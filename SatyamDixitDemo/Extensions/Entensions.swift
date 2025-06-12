//
//  Entensions.swift
//  SatyamDixitDemo
//
//  Created by Satyam Dixit on 12/06/25.
//


extension Double {
    func roundedString(fractionDigits: Int = 2) -> String {
        return String(format: "%.\(fractionDigits)f", self)
    }
}
