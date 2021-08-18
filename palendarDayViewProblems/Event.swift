import Foundation

class Event{
    let id: String
    var title: String?
    var date: String?
    var month: String?
    var year: String?
    var start: String?
    var end: String?
    
    var bridgesDays: Bool = false //true if the event shoujld end on a different day (parties may ent at 1AM the next day for example
    
    init(){
        id = "0"
        bridgesDays = false
    }
    
    init(_ id: String, title: String, date: String, month: String, year: String, start: String, end: String) {
        self.id = id
        self.title = title
        self.date = date
        self.start = start
        self.end = end
        
        self.month = month
        self.year = year
        
        self.bridgesDays = doesEventBridgeDays()
        
    }
    
    
    
    private func doesEventBridgeDays() -> Bool{
        print("start: \(getStartDay()) \(getStartMonth()) \(getStartYear())")
        print("end: \(getEndDay()) \(getEndMonth()) \(getEndYear())")
        if(getStartDay() != getEndDay() || getStartMonth() != getEndMonth() || getStartYear() != getEndYear()){//if the event ends tomorrow or later
            print("bridging Days")
            return true
        }else{
            print("Not Bridging Days")
            return false
        }
    }
    
    
    func getStartDay() -> String{
        let split = start?.split(separator: "/")
        return String(describing: split![0])
        
    }
    func getStartMonth() -> String{
        let split = start?.split(separator: "/")
        return String(describing: split![1])
    }
    func getStartYear() -> String{
        let split = start?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[0])
    }
    func getStartTime() -> String{
        let split = start?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[1])
    }
   
    func getEndDay() -> String{
        let split = end?.split(separator: "/")
        return String(describing: split![0])
    }
    func getEndMonth() -> String{
        let split = end?.split(separator: "/")
        return String(describing: split![1])
    }
    func getEndYear() -> String{
        let split = end?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[0])
    }
    func getEndTime() -> String{
        let split = end?.split(separator: "/")
        let yearTime = split![2].split(separator: " ") // without this split[2] will look like "YYYY HH:mm"
        return String(describing: yearTime[1])
    }

    
    func getStartDate() -> Date{
        
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy HH:mm"
        let r = date.date(from: start!)
        
        return r!
    }
    
    func getEndDate() -> Date{
        
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy HH:mm"
        let r = date.date(from: end!)
        return r!
    }
    
    
    
    
 
}
