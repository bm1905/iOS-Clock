//
//  BM_Clock.swift
//  Clock_FinalProject
//
//  Created by Bijay Maharjan on 11/27/19.
//  Copyright © 2019 Bijay Maharjan. All rights reserved.
//

import Foundation
import UIKit

@objc class BM_Clock:NSObject {
    @objc func updateTime(clockShort: UIImageView,
                          clockLong: UIImageView,
                          clockSecond: UIImageView,
                          gearSmall: UIImageView,
                          gearLeft: UIImageView,
                          gearRight: UIImageView,
                          gearBlurred1: UIImageView,
                          gearBlurred2: UIImageView,
                          gearBlurred3: UIImageView,
                          meterHand: UIImageView,
                          displayValues: Bool) {
        
        updateTime(clockShort: clockShort,
                   clockLong: clockLong,
                   clockSecond: clockSecond,
                   gearSmall: gearSmall,
                   gearLeft: gearLeft,
                   gearRight: gearRight,
                   gearBlurred1: gearBlurred1,
                   gearBlurred2: gearBlurred2,
                   gearBlurred3: gearBlurred3,
                   meterHand: meterHand,
                   labelDay: nil,
                   labelDayName: nil)
    }
    
    @objc func updateTime(clockShort: UIImageView,
                          clockLong: UIImageView,
                          clockSecond: UIImageView,
                          gearSmall: UIImageView,
                          gearLeft: UIImageView,
                          gearRight: UIImageView,
                          gearBlurred1: UIImageView,
                          gearBlurred2: UIImageView,
                          gearBlurred3: UIImageView,
                          meterHand: UIImageView,
                          labelDay: UILabel?,
                          labelDayName: UILabel?) {
        
        // Updates date.
        if(labelDay != nil) {
            labelDay?.text = "\(self.getMonth())/\(self.getDay())/\(self.getYear())"
        }
        
        // Updates day name.
        if(labelDayName != nil) {
            labelDayName?.text = "\(self.getDayName())"
        }
        
        // Rotates short clock arm 'h' hours and 'm' minutes.
        // 360 degrees / 12 hours = 30 degrees
        // 360 degrees / 12 hours / 60 minutes = 0.5 degree
        rotateUIImageView(degrees: 30 * CGFloat(convertToHours(totalSeconds: dynamicTime())) + 0.5 * CGFloat(convertToMinutes(totalSeconds: dynamicTime())),
                          imageView: clockShort)
        
        // Rotates long clock arm 'm' minutes,
        // 360 degrees / 60 minutes / 60 seocnds = 0.1 degree
        rotateUIImageView(degrees: CGFloat(Double(6 * convertToMinutes(totalSeconds: dynamicTime())) + 0.1 * Double(convertToSeconds(totalSeconds: dynamicTime()))),
                          imageView: clockLong)
        
        // Rotates second clock arm 's' seconds
        // 360 degree / 60 seconds = 6 degree
        rotateUIImageView(degrees: 6 * CGFloat(convertToSeconds(totalSeconds: dynamicTime())),
                          imageView: clockSecond)
        
        
        // Debug purposes only.
//        print(convertToHours(totalSeconds: dynamicTime()))
//        print(convertToMinutes(totalSeconds: dynamicTime()))
//        print(convertToSeconds(totalSeconds: dynamicTime()))
        
        // Rotates temperature meter hand.
        rotateMeterHand(degrees: CGFloat(3 * weatherDataModel.temperature), imageView: meterHand)
        
        // Rotates left gear
        rotateView(targetView: gearLeft,
                   duration: 1.0,
                   degrees: 0.02)
        
        // Rotates Right gear
        rotateView(targetView: gearRight,
                   duration: 1.0,
                   degrees: -0.02)
        
        // Rotates Small gear
        rotateView(targetView: gearSmall,
                   duration: 1.0,
                   degrees: 0.10)
        
        // Rotates background gears
        rotateView(targetView: gearBlurred1,
                   duration: 1.0,
                   degrees: 0.07)
        
        // Rotates background gears
        rotateView(targetView: gearBlurred2,
                   duration: 1.0,
                   degrees: 0.1)
        
        // Rotates background gears
        rotateView(targetView: gearBlurred3,
                   duration: 1.0,
                   degrees: 0.15)
    }
    
    // Returns current month
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: Date())
    }
    
    // Returns current day.
    func getDay() -> Int {
        return Calendar.current.component(.day, from: Date())
    }
    
    // Returns current year.
    func getYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    // Returns current day name.
    func getDayName() -> String {
        let days = Calendar.current.component(.weekday, from: Date())
        switch days {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Error"
        }
    }
    
    // Returns current hours
    func getHours() -> Int {
        return Calendar.current.component(.hour, from: Date())
    }
    
    // Returns current minutes
    func getMinutes()  -> Int {
        return Calendar.current.component(.minute, from: Date())
    }
    
    // Returns current seconds
    func getSeconds() -> Int {
        return Calendar.current.component(.second, from: Date())
    }
    
    // Returns current nanoseconds
    func getNanoseconds() -> Int {
        return Calendar.current.component(.nanosecond, from: Date())
    }
    
    // Converts current time to seconds.
    func getCurrentTime() -> Int {
        return (self.getHours() * 60 * 60) + (self.getMinutes() * 60) + self.getSeconds()
    }
    
    // Gets timezone from api and converts to their time in seconds.
    func dynamicTime() -> Int {
//        print(getCurrentTime())
//        print(weatherDataModel.timeZone)
        
        // Change Shreveport time to UTC.
        return getCurrentTime() - 21600 + weatherDataModel.timeZone
    }
    
    // Converts updated time to hours.
    func convertToHours(totalSeconds: Int) -> Int {
        let totalHours = totalSeconds % (24 * 3600)
        let hours = totalHours / 3600
//        print("Hours: \(hours)")
        return hours
    }
    
    // Converts updated time to minutes.
    func convertToMinutes(totalSeconds: Int) -> Int {
        var totalHours = totalSeconds % (24 * 3600)
        totalHours %= 3600
        let minutes = totalHours / 60
        return minutes
    }
    
    // Converts updated time to seconds.
    func convertToSeconds(totalSeconds: Int) -> Int {
        var totalHours = totalSeconds % (24 * 3600)
        totalHours %= 3600
        totalHours %= 60
        let seconds = totalHours
        return seconds
    }
    
    // Rotates UIImageView clock hands
    func rotateUIImageView(degrees: CGFloat,
                           imageView: UIImageView) {
        let radians: CGFloat = CGFloat(Double.pi / 180)
        imageView.transform = CGAffineTransform(rotationAngle: degrees * radians)
    }
    
    // Rotates UIImageView gears
    func rotateView(targetView: UIImageView,
                    duration: Double,
                    degrees: CGFloat) {
        UIImageView.animate(withDuration: duration,
                            delay: 0.0,
                            options: .curveLinear,
                            animations: {
                                targetView.transform = targetView.transform.rotated(by: CGFloat(degrees))
        })
    }
    
    // Rotates meter hand with temperature
    func rotateMeterHand(degrees: CGFloat,
                         imageView: UIImageView) {
        let radians: CGFloat = CGFloat(Double.pi / 180)
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * radians))
    }
}
