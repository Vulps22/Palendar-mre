//
//  AppDelegate.swift
//  palendarDayViewProblems
//
//  Created by Andrew McAllister on 18/08/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let today = CalendarDay(onDay: 12, ofMonth: 10, ofYear: 2021)
        
        /*
            Here we set an event which starts on 12/10/2021 (DD/MM/YYYY)
            and ends early the next day
         
            The DayViewController should display an event container which ends at the bottom of the table view (to represent the event not ending on that day)
         */
        
        
        today.events.append(Event("0", title: "just a test event", date: "12", month: "10", year: "2021", start: "12/10/2021 13:00", end: "13/10/2021 09:00"))
        
        let dayView = DayViewController()
        
        dayView.today = today
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = dayView
        
        return true
    }


}

