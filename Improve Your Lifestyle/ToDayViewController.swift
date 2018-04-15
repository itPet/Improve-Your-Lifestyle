//
//  ToDayViewController.swift
//  Improve Your Lifestyle
//
//  Created by Peter Karlsson on 2018-03-28.
//  Copyright © 2018 Peter Karlsson. All rights reserved.
//

import UIKit
import Firebase
import ChartProgressBar

class ToDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var userId = ""
    var placeOfHistoryCell = 0
    var dateToSave = ""
    var startDate = ""
    
    //För att få tag på rätt element i TaskList behövs det substraheras 1 när man skriver till celler nedanför statistiken.
    var subtract = 0
    var maxPoints : Float = 0.0
    var currentPoints : Float = 0.0
    @IBOutlet weak var toDayTableView: UITableView!
    @IBOutlet weak var statistics: ChartProgressBar!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let tbc = tabBarController as! TabBarController
        
        placeOfHistoryCell = tbc.placeOfHistoryCell
        userId = tbc.userId
        dateToSave = tbc.dateToSave
        startDate = tbc.startDate
        
        toDayTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        calculateMaxPoints()
        updateProgressBar()
        saveHistory()
        updateProgressBar()
        updateHistoryView()
        //progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        //progressBar.transform = CGAffineTransform(scaleX: 1, y: 20)

        
    }
    
    func updateHistoryView() {
        var data: [BarData] = []
        var num = 0
        
        if listOfHistory.count > 6 {
            num = 7
        } else {
            num = listOfHistory.count
        }
        for i in 0...(num - 1) {
            let barTitle = listOfHistory[listOfHistory.count - (num-i)].day
            let barValue = listOfHistory[listOfHistory.count - (num-i)].percent / 10
            let pinText = listOfHistory[listOfHistory.count - (num-i)].points
            data.append(BarData.init(barTitle: barTitle, barValue: barValue, pinText: String(pinText)))
        }
        statistics.data = data
        statistics.barsCanBeClick = true
        statistics.maxValue = 10.0
        statistics.build()
    }
    
    func saveHistory() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        
        let dateToSaveAsDate = dateFormatter.date(from: dateToSave)
        let currentDateAsString = "20180430"//dateFormatter.string(from: Date())
        let currentDate = dateFormatter.date(from: currentDateAsString)
        
        let timeDifference = dateToSaveAsDate?.timeIntervalSince(currentDate!)
        let differenceInDays = Int(-(timeDifference! / 86400))
        if differenceInDays > 0 {
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("points").setValue(String(Int(currentPoints)))
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("percent").setValue(String((currentPoints / maxPoints)*100))
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("date").setValue(dateToSave)
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("day").setValue(dayFormatter.string(from: dateToSaveAsDate!))
            listOfHistory.append(OneDaysHistory(points: Int(currentPoints), percent: (currentPoints / maxPoints)*100, date: dateToSave, day: dayFormatter.string(from: dateToSaveAsDate!)))
            placeOfHistoryCell = 0
            dateToSave = currentDateAsString
            ref.child(userId).child("info").child("placeOfHistoryCell").setValue("0")
            ref.child(userId).child("info").child("dateToSave").setValue(String(currentDateAsString))
            for i in 0...listOfTaskLists[0].taskList.count - 1 {
                ref.child(userId).child("lists").child("0").child("tasks").child(String(i)).child("completed").setValue("false")
            }
        }
        if differenceInDays > 1 {
            print(differenceInDays)
            var myComponent = DateComponents()
            for i in 1...differenceInDays - 1 {
                myComponent.day = i-differenceInDays
                let newDate = Calendar.current.date(byAdding: myComponent, to: currentDate!)
                let newDateAsString = dateFormatter.string(from: newDate!)
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("points").setValue("0")
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("percent").setValue("0.0")
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("date").setValue(newDateAsString)
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("day").setValue(dayFormatter.string(from: newDate!))
                listOfHistory.append(OneDaysHistory(points: Int(0), percent: 0.0, date: newDateAsString, day: dayFormatter.string(from: newDate!)))
            }
        }
    }
    
    func calculateMaxPoints() {
        for task in listOfTaskLists[0].taskList {
            maxPoints += Float(task.points)
        }
    }
    
    func updateProgressBar() {
        currentPoints = 0
        if placeOfHistoryCell != 0 {
            for i in 0...placeOfHistoryCell-1 {
                currentPoints += Float(listOfTaskLists[0].taskList[i].points)
            }
        }
        pointsLabel.text = "\(Int(currentPoints))/\(Int(maxPoints))"
        progressBar.progress = currentPoints / maxPoints
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfTaskLists.count == 0 {
            return 0
        }
        else {
            return listOfTaskLists[0].taskList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDayCell", for: indexPath)
        let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        subtract = 0
        
        if indexPath.row > placeOfHistoryCell {
            subtract = 1
        }
        if indexPath.row == placeOfHistoryCell {
            historyCell.backgroundColor = UIColor.red
            historyCell.textLabel?.text = "Statistik"
            return historyCell
        }
        else {
            cell.textLabel?.text = listOfTaskLists[0].taskList[indexPath.row - subtract].name
            cell.detailTextLabel?.text = String(listOfTaskLists[0].taskList[indexPath.row - subtract].points)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ref = Database.database().reference()
        let tbc = tabBarController as! TabBarController
        
        if indexPath.row > placeOfHistoryCell {
            let elementToMove = listOfTaskLists[0].taskList[indexPath.row - 1]
            ref.child(userId).child("lists").child("0").child("tasks").child(String(indexPath.row - 1)).child("completed").setValue("true")
            elementToMove.completed = true
            listOfTaskLists[0].taskList.remove(at: indexPath.row - 1)
            listOfTaskLists[0].taskList.insert(elementToMove, at: placeOfHistoryCell)
            
            placeOfHistoryCell += 1
        }
        
        if indexPath.row < placeOfHistoryCell {
            let elementToMove = listOfTaskLists[0].taskList[indexPath.row]
            elementToMove.completed = false
            ref.child(userId).child("lists").child("0").child("tasks").child(String(indexPath.row)).child("completed").setValue("false")
            listOfTaskLists[0].taskList.remove(at: indexPath.row)
            placeOfHistoryCell -= 1
            listOfTaskLists[0].taskList.insert(elementToMove, at: placeOfHistoryCell)
        }
        
        tbc.placeOfHistoryCell = placeOfHistoryCell
        ref.child(userId).child("info").child("placeOfHistoryCell").setValue(String(placeOfHistoryCell))
        toDayTableView.reloadData()
        updateProgressBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
