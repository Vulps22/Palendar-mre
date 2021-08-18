import UIKit

class DayViewController: UITableViewController {
    
    var drawEvent:Event? = nil
    var events: [EventContainerView] = []
    var today: CalendarDay?
    
    var allDayLabel: UIView = UIView()
    
    let cellID: String = "event"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
       // setupView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        for i in -1...23 {
            drawTime(i)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doLoad()
        
    }
    
    func doLoad(){
        
        self.setupView() //This calls the drawEvent Function where the bug is located
        self.tableView.reloadData()
    }

    func setConstraints(){
        allDayLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        allDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        allDayLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        allDayLabel.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        
       /* tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true*/
    }
    
    func buildView(){
        view.backgroundColor = .white
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupView(){
        for event in events{
            event.removeFromSuperview()
        }
        sortEventsByTime()
        for event in today!.events{
                events.append(drawEvent(event))
            }// end drawdrawEvent loop
        }
    
    
    func sortEventsByTime(){
        guard var sortedEvents = today?.events
        else{
           return
        }
        var sorted = false
        while !sorted {
            sorted = true
            for (index, event) in (sortedEvents.enumerated()){
                print(sortedEvents.count)
                if(index == 0){
                }else{
                    let thisTime = event.getStartTime().split(separator: ":" )
                    let lastTime = sortedEvents[index-1].getStartTime().split(separator: ":")
                    //if hours are less than
                    if(Int(thisTime[0])! < Int(lastTime[0])!){
                        sorted = false
                        let poppedTime = event
                        sortedEvents.remove(at: index)
                        sortedEvents.insert(poppedTime, at: index-1)
                    }else{
                        if(Int(thisTime[0]) == Int(lastTime[0]) && Int(thisTime[1])! < Int(lastTime[1])!){
                            sorted = false
                            let poppedTime = event
                            sortedEvents.remove(at: index)
                            sortedEvents.insert(poppedTime, at: index-1)
                        }
                    }
                }
            }
        }
        today?.events = sortedEvents
    }
    
    func drawTime(_ index: Int){
        if(index == -1){
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: (50 * (index+1)) - 25, width: 30, height: 50)  )
            label.text = String(format: "%02d", index)
            tableView.addSubview(label)
        }
    }
    
    func drawEvent(_ event:Event) -> EventContainerView{
        
        
        let start = makeMinutes(from: event.getStartTime()) //return an integer representing the time as the number of minutes into the day -- e.g. 1AM would be 60, 2AM would be 120 etc
        let end = makeMinutes(from: event.getEndTime())
        
        let tableLength = 50*25//I wish i had commented on why i used this sum, but i truly have no recollection of what this represents now ---- perhaps the cell height * number of hours in the day (including 0)?
        
        let breakdown = CGFloat(tableLength) / CGFloat(1500) //split the table into it's minutes
        
        let startPoint: CGFloat = breakdown * CGFloat(start + 60) // multiply by the start time to push the event down the view
        
        let duration = CGFloat(end) - CGFloat(start) //The duration of the event as a number of minutes
        
        let endpoint = breakdown * duration
        
       let eventView = EventContainerView(forEvent: event, today: self) //The view the user will see and interact with for each event
           eventView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(eventView)
        //activate constriants
        eventView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: startPoint).isActive = true
        
        eventView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30).isActive = true
    
        eventView.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -50).isActive = true
        
        
        /*This is where the bug is occuring*/
        
        if(event.bridgesDays == true){//if the event ends tomorrow or later then set the bottom anchor rather than the height
            if(today!.date == Int(event.getEndDay())! && today!.month == Int(event.getEndMonth())! && today!.year == Int(event.getEndYear())!){
               //this is today and the event should end as normal
                print("Event ends today")
                eventView.heightAnchor.constraint(equalToConstant: endpoint).isActive = true
            }else{
                print("Event Does Not End Today")
                //Event does not end today and should end at the bottom of the view
                eventView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
            }
        }else{
            //just a normal day at the office, Nothing complex about this beautiful line of code.
            //day ends on the same day as it starts -> Has not given me a headache (yet)
            print("No bridging")
            eventView.heightAnchor.constraint(equalToConstant: endpoint).isActive = true
        }
            return eventView
    }
    
    //MARK: TableView data sources
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        return cell
    }//end function
    
    //MARK: Helper functions
    
    func makeMinutes(from: String) -> Int{
        
        let time = from.split(separator: ":")
        
        let htm:Int = Int(String(describing: time[0]))! * 60 //hour to minutes
        
        let minutes = htm + Int(String(describing: time[1]))!
        
        return minutes
        
    }
    
    
    
}
