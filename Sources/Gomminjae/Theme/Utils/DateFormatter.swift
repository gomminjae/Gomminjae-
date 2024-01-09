//
//  File.swift
//  
//
//  Created by 권민재 on 1/9/24.
//

import Foundation

extension DateFormatter {
    static var time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter.time
        return dateFormatter.string(from: self)
    }
}
