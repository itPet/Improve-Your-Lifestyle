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
    var placeOfHistoryCell = -1
    var dateToSave = ""
    var startDate = ""
    var firstTimeLoading = true
    
    var activeList = -1
    var maxPoints : Float = 0
    var currentPoints : Float = 0
    @IBOutlet weak var toDayTableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsLabel2: UILabel!
    @IBOutlet weak var progressDoneView: UIView!
    @IBOutlet weak var progressLeftView: UIView!
    @IBOutlet weak var todayIcon: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let tbc = tabBarController as! TabBarController
        view.backgroundColor = UIColor.black
        placeOfHistoryCell = tbc.placeOfHistoryCell
        dateToSave = tbc.dateToSave
        startDate = tbc.startDate
        
        toDayTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        calculateMaxPoints()
        updateProgressBar()
        saveHistory()
        updateProgressBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toDayTableView.reloadData()
        updateProgressBar()
        let myIndexPath = IndexPath(row: placeOfHistoryCell, section: 0)
        toDayTableView.scrollToRow(at: myIndexPath, at: .top, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func updateActiveList() {
        for i in 0...listOfTaskLists.count - 1 {
            if listOfTaskLists[i].isActive == true {
                activeList = i
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfTaskLists.count == 0 {
            return 0
        }
        else {
            return listOfTaskLists[activeList].taskList.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == placeOfHistoryCell {
            return 210
        } else if indexPath.row == 0 {
            return 80
        } else if indexPath.row == listOfTaskLists[activeList].taskList.count + 1 {
            if tableView.frame.size.height - CGFloat(210 + (60 * (listOfTaskLists[activeList].taskList.count - placeOfHistoryCell))) < 1 {
                return 0
            } else {
                return tableView.frame.size.height - CGFloat(210 + (60 * (listOfTaskLists[activeList].taskList.count - placeOfHistoryCell)))
            }
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
        let cellWithHistory = Bundle.main.loadNibNamed("TableViewHistoryCell", owner: self, options: nil)?.first as! TableViewHistoryCell
        let emptyCell = Bundle.main.loadNibNamed("EmptyTableViewCell", owner: self, options: nil)?.first as! EmptyTableViewCell
    
        var subtract = 0
        if indexPath.row > placeOfHistoryCell {
            subtract = 1
        }
        if indexPath.row == placeOfHistoryCell {
            updateHistoryView(cellWithHistory: cellWithHistory)
            cellWithHistory.selectionStyle = .none
            return cellWithHistory
        }
        else if indexPath.row == listOfTaskLists[activeList].taskList.count + 1 {
            if firstTimeLoading {
                let myIndexPath = IndexPath(row: placeOfHistoryCell, section: 0)
                tableView.scrollToRow(at: myIndexPath, at: .top, animated: false)
            }
            firstTimeLoading = false
            emptyCell.isUserInteractionEnabled = false
            return emptyCell
        }
        else {
            cell.nameLabel.text = listOfTaskLists[activeList].taskList[indexPath.row - subtract].name
            cell.pointsLabel.text = String(listOfTaskLists[activeList].taskList[indexPath.row - subtract].points)
            cell.cellView.layer.cornerRadius = 15
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tbc = tabBarController as! TabBarController
        
        if indexPath.row > placeOfHistoryCell {
            let elementToMove = listOfTaskLists[activeList].taskList[indexPath.row - 1]
            ref.child(userId).child("lists").child("0").child("tasks").child(String(indexPath.row - 1)).child("completed").setValue("true")
            elementToMove.completed = true
            listOfTaskLists[activeList].taskList.remove(at: indexPath.row - 1)
            listOfTaskLists[activeList].taskList.insert(elementToMove, at: placeOfHistoryCell)
            
            placeOfHistoryCell += 1
        }
        
        if indexPath.row < placeOfHistoryCell {
            let elementToMove = listOfTaskLists[activeList].taskList[indexPath.row]
            elementToMove.completed = false
            ref.child(userId).child("lists").child("0").child("tasks").child(String(indexPath.row)).child("completed").setValue("false")
            listOfTaskLists[activeList].taskList.remove(at: indexPath.row)
            placeOfHistoryCell -= 1
            listOfTaskLists[activeList].taskList.insert(elementToMove, at: placeOfHistoryCell)
        }
        
        tbc.placeOfHistoryCell = placeOfHistoryCell
        ref.child(userId).child("info").child("placeOfHistoryCell").setValue(String(placeOfHistoryCell))
        toDayTableView.reloadData()
        updateProgressBar()
        if indexPath.row > placeOfHistoryCell - 1 && indexPath.row - placeOfHistoryCell < 7 {
            let myIndexPath = IndexPath(row: placeOfHistoryCell, section: 0)
            tableView.scrollToRow(at: myIndexPath, at: .top, animated: false)
            print("select")
        }
    }
    
    func updateHistoryView(cellWithHistory: TableViewHistoryCell) {
        var data: [BarData] = []
        var num = 0

        if listOfHistory.count > 0 {
            if listOfHistory.count > 6 {
                num = 7
            } else {
                num = listOfHistory.count
            }
            for i in 0...(num - 1) {
                let barTitle = listOfHistory[listOfHistory.count - (num-i)].day
                let barValue = listOfHistory[listOfHistory.count - (num-i)].percent
                let pinText = listOfHistory[listOfHistory.count - (num-i)].points
                data.append(BarData.init(barTitle: barTitle, barValue: barValue, pinText: String(pinText)))
            }
            cellWithHistory.chartProgressView.data = data
            cellWithHistory.chartProgressView.barsCanBeClick = false
            cellWithHistory.chartProgressView.barHeight = 150
            cellWithHistory.chartProgressView.maxValue = 100
            cellWithHistory.chartProgressView.barTitleColor = UIColor(red: 0, green: 87/255.0, blue: 180/255.0, alpha: 1)
            cellWithHistory.chartProgressView.progressColor = UIColor(red: 0, green: 249/255.0, blue: 0, alpha: 1)
            cellWithHistory.chartProgressView.emptyColor = UIColor(red: 0, green: 87/255.0, blue: 180/255.0, alpha: 1)
            cellWithHistory.chartProgressView.build()
        }
    }
    
    // MARK: - Help functions
    func calculateMaxPoints() {
        for task in listOfTaskLists[activeList].taskList {
            maxPoints += Float(task.points)
        }
    }
    
    func updateProgressBar() {
        currentPoints = 0
        if placeOfHistoryCell != 0 {
            for i in 0...placeOfHistoryCell-1 {
                currentPoints += Float(listOfTaskLists[activeList].taskList[i].points)
            }
        }
        pointsLabel.text = "\(Int(currentPoints))/\(Int(maxPoints))"
        pointsLabel2.text = "\(Int(currentPoints))/\(Int(maxPoints))"
        progressLeftView.layer.cornerRadius = progressLeftView.frame.size.height / 2
        progressDoneView.layer.cornerRadius = progressDoneView.frame.size.height / 2
        progressDoneView.frame.size.width = CGFloat((Float(progressLeftView.frame.size.width) / maxPoints) * currentPoints)
    }
    
    // MARK: - FireBase
    func saveHistory() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        
        let dateToSaveAsDate = dateFormatter.date(from: dateToSave)
        let currentDateAsString = dateFormatter.string(from: Date())
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
            for i in 0...listOfTaskLists[activeList].taskList.count - 1 {
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
    
    // MARK: - Functions I don't use
    
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
