//
//  File.swift
//  waiterHelper
//
//  Created by HongDang on 3/21/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class ReservationViewModel {
    static var shared = ReservationViewModel()
    
    func GetReservation(completion:@escaping GetReservationHandler){
        ReservationAPI.shared.GetReservation(parameters: [:], headers: nil) { (model) in
                guard let model = model else {
                    completion(nil)
                    return
                }
                completion(model)
            }
        }
    
    
    func CompareDay(_ timeA:DATETIME, _ timeB:DATETIME)-> Bool {
        if (timeA.date == timeB.date && timeA.month == timeB.month && timeA.year == timeB.year ) {
            return true
        }
        return false
    }
    
    func getTimeCurrenr() -> DATETIME{
        var dt = DATETIME(date: 0, month: 0, year: 0, hour: 0, minute: 0, seconds: 0)
        let date = Date()
        let calendar = Calendar.current
        dt.hour = calendar.component(.hour, from: date)
        dt.minute = calendar.component(.minute, from: date)
        dt.date = calendar.component(.day, from: date)
        dt.month = calendar.component(.month, from: date)
        dt.year = calendar.component(.year, from: date)
        return dt
    }
    func parseTime(_ date:String, _ month:String, _ year:String, _ hour:String, _ minute:String) ->DATETIME {
        var datetime = DATETIME(date: 0, month: 0, year: 0, hour: 0, minute: 0, seconds: 0)
        datetime.date = Int(date)!
        datetime.month = Int(month)!
        datetime.year = Int(year)!
        datetime.hour = Int(hour)!
        datetime.minute = Int(minute)!
        return datetime
    }
    func add1Min(_ time:DATETIME) -> DATETIME {
        var temp:DATETIME = time
        if temp.minute < 60 {
            temp.minute += 1
            return temp
        } else if temp.hour < 24 {
            temp.minute = 0
            temp.hour += 1
            return temp
        } else {
            temp.minute = 0
            temp.hour = 0
            return temp
        }

    }
    func CompareHour(_ timeA:DATETIME, _ timeB:DATETIME) -> Int {
        if (timeA.hour < timeB.hour){
            return -1 //timeA < time B
        } else if (timeA.hour == timeB.hour && timeA.minute < timeB.minute) {
            return -1
        } else if ( timeA.hour == timeB.hour && timeA.minute == timeB.minute){
            return 1 // timeA = time B
        }
        return 0 // timeA > time B
    }
    func CountWaitTime(_ timeReserved:DATETIME, _ timeCurrent:DATETIME) -> Int{
        var timeRes = timeReserved
        var timeCur = timeCurrent
        var count:Int = 0
        if !CompareDay(timeReserved, timeCurrent){
            return -1111
        }
        while CompareHour(timeRes, timeCur) != 1 { // ko bang nhau
            if CompareHour(timeCur, timeRes) == -1 { //timeA < time B
                timeCur = add1Min(timeCur)
                count += 1
            }
            if CompareHour(timeCur, timeRes) == 0 {//timeA > time B
                timeRes = add1Min(timeRes)
                count -= 1
            }
        }
        print(count)
        return count
    }
    func checkTimeReserved(_ arr:RESERVATION) -> Bool {
        let timeReserved:DATETIME = ReservationViewModel.shared.parseTime(arr.DAY, arr.MONTH, arr.YEAR, arr.HOUR, arr.MINUTE)
        let currentTime:DATETIME = ReservationViewModel.shared.getTimeCurrenr()
        let timeWait:Int = CountWaitTime(timeReserved, currentTime)
        if timeWait < 16 && timeWait > -2{
            return true
        }
        return false
    }
    

}
