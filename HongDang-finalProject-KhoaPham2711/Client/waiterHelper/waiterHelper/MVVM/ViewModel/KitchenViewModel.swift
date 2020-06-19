//
//  KitchenViewModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/15/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class KitchenViewModel {
    static var shared = KitchenViewModel()
    
    func CountWaitTime(_ timeOrder:DATETIME, _ timeCurrent:DATETIME) -> Int{
        var time = timeOrder
        var count:Int = 0
        while !Compare(timeCurrent, time) {
            time = add1Second(time)
            count += 1
        }
        return Int(ceil(Double(count)/60.0))
    }
    func Compare(_ timeOrder:DATETIME, _ timeCurrent:DATETIME) -> Bool {
//        timeOrder.date == timeCurrent.date && timeOrder.month == timeCurrent.month && timeOrder.year == timeCurrent.year &&
        if ( timeOrder.hour == timeCurrent.hour && timeOrder.minute == timeCurrent.minute && timeOrder.seconds == timeCurrent.seconds ){
            return true
        }
        return false
    }
     func add1Second(_ time:DATETIME) -> DATETIME {
           var temp:DATETIME = time
           if (temp.seconds < 60 ) {
               temp.seconds += 1
               return temp
           } else if temp.minute < 60 {
               temp.seconds = 1
               temp.minute += 1
               return temp
           } else if temp.hour < 24 {
               temp.seconds = 1
               temp.minute = 0
               temp.hour += 1
               return temp
           } else {
               temp.seconds = 1
               temp.minute = 0
               temp.hour = 0
               return temp
           }

       }
    func getTimeCurrenr() -> DATETIME{
        var dt = DATETIME(date: 0, month: 0, year: 0, hour: 0, minute: 0, seconds: 0)
        let date = Date()
        let calendar = Calendar.current
        dt.hour = calendar.component(.hour, from: date)
        dt.minute = calendar.component(.minute, from: date)
        dt.seconds = calendar.component(.second, from: date)
        dt.date = calendar.component(.day, from: date)
        dt.month = calendar.component(.month, from: date)
        dt.year = calendar.component(.year, from: date)
        return dt
    }
    func parseTime(_ date:String, _ month:String, _ year:String, _ hour:String, _ minute:String, _ seconds:String) ->DATETIME {
        var datetime = DATETIME(date: 0, month: 0, year: 0, hour: 0, minute: 0, seconds: 0)
        datetime.date = Int(date)!
        datetime.month = Int(month)!
        datetime.year = Int(year)!
        datetime.hour = Int(hour)!
        datetime.minute = Int(minute)!
        datetime.seconds = Int(seconds)!
        
        return datetime
    }
    func getTimeWait(_ arr:OrderFromServer) -> Int{
        let timeOrder:DATETIME = KitchenViewModel.shared.parseTime(arr.DAY, arr.MONTH, arr.YEAR, arr.HOUR, arr.MINUTE, arr.SECONDS)
        let currentTime:DATETIME = KitchenViewModel.shared.getTimeCurrenr()
        let timeWait:Int = CountWaitTime(timeOrder, currentTime)
        return timeWait
    }
}
