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

let progressColor = UIColor(red: 92/255, green: 221/255, blue: 103/255, alpha: 1)
let notProgressColor = UIColor(red: 62/255, green: 62/255, blue: 62/255, alpha: 1)
let viewControllerBackgroundColor = UIColor.black
let tableViewBackgroundColor = UIColor.black
let headerAndFooterColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1)
let cellColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1)
let taskBackgroundColor = UIColor(red: 62/255, green: 62/255, blue: 62/255, alpha: 1)
let normalTextColor = UIColor.white
let completedTextColor = UIColor(red: 146/255, green: 219/255, blue: 129/255, alpha: 1)
let tabBarButtonColor = UIColor(red: 51/255, green: 120/255, blue: 246/255, alpha: 1)

class ToDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var placeOfHistoryCell = -1
    var dateToSave = ""
    var firstTimeLoading = true
    var newDay = 0
    var fakeCurrentDate = 20180424
    
    var activeList = -1
    var maxPoints : Float = 0
    var currentPoints : Float = 0
    @IBOutlet weak var toDayTableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsLabel2: UILabel!
    @IBOutlet weak var progressDoneView: UIView!
    @IBOutlet weak var progressLeftView: UIView!
    @IBOutlet weak var todayIcon: UITabBarItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        ref = Database.database().reference()
        let tbc = tabBarController as! TabBarController
        dateToSave = tbc.dateToSave
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        setColors()
        updateActiveList()
        
        if activeList == -1 || listOfTaskLists[activeList].taskList.count == 0 {
            setProgressBarToZero()
        } else {
            updatePlaceOfHistoryCell()
            toDayTableView.tableFooterView = UIView(frame: CGRect.zero)
            saveHistory()
            updateProgressBar()
        }
        toDayTableView.reloadData()
    }
    
    override func awakeFromNib() {
        print("awake")
    }
    
    override func viewDidLayoutSubviews() {
        if activeList != -1 {
            if listOfTaskLists[activeList].taskList.count != 0 {
                updateProgressBar()
            }
        } else {
            setProgressBarToZero()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Updatefunctions
    func updateActiveList() {
        activeList = -1
        if listOfTaskLists.count != 0 {
            for i in 0...listOfTaskLists.count - 1 {
                if listOfTaskLists[i].isActive == true {
                    activeList = i
                }
            }
        }
    }
    
    func updatePlaceOfHistoryCell() {
        var counter = 0
        for task in listOfTaskLists[activeList].taskList {
            if task.completed {
                counter += 1
                print("counter: \(counter)")
            }
        }
        placeOfHistoryCell = counter
        print("placeOf...: \(placeOfHistoryCell)")
    }
    
    func setProgressBarToZero() {
        pointsLabel.text = "0/0"
        pointsLabel2.text = "0/0"
        progressLeftView.layer.cornerRadius = progressLeftView.frame.size.height / 2
        progressDoneView.layer.cornerRadius = progressDoneView.frame.size.height / 2
        progressDoneView.frame.size.width = CGFloat(0)
    }
    
    func updateProgressBar() {
        currentPoints = 0
        maxPoints = 0
        if activeList != -1 {
            if listOfTaskLists[activeList].taskList.count != 0 {
                for task in listOfTaskLists[activeList].taskList {
                    if task.completed {
                        currentPoints += Float(task.points)
                    }
                    maxPoints += Float(task.points)
                }
            }
        }
        pointsLabel.text = "\(Int(currentPoints))/\(Int(maxPoints))"
        pointsLabel2.text = "\(Int(currentPoints))/\(Int(maxPoints))"
        progressLeftView.layer.cornerRadius = progressLeftView.frame.size.height / 2
        progressDoneView.layer.cornerRadius = progressDoneView.frame.size.height / 2
        progressDoneView.frame.size.width = CGFloat((Float(progressLeftView.frame.size.width) / maxPoints) * currentPoints)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfTaskLists.count == 0 || activeList == -1 || listOfTaskLists[activeList].taskList.count == 0 {
            return 0
        }
        else {
            return listOfTaskLists[activeList].taskList.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastRow = listOfTaskLists[activeList].taskList.count + 1
        
        if indexPath.row == placeOfHistoryCell {
            return 260
        }
        else if indexPath.row == lastRow {
            if tableView.frame.size.height - CGFloat(210 + (60 * (listOfTaskLists[activeList].taskList.count - placeOfHistoryCell))) < 1 {
                return 0
            } else {
                return tableView.frame.size.height - CGFloat(210 + (60 * (listOfTaskLists[activeList].taskList.count - placeOfHistoryCell)))
            }
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
        let cellWithHistory = Bundle.main.loadNibNamed("TableViewHistoryCell", owner: self, options: nil)?.first as! TableViewHistoryCell
        let emptyCell = Bundle.main.loadNibNamed("EmptyTableViewCell", owner: self, options: nil)?.first as! EmptyTableViewCell
        
        let lastCell = listOfTaskLists[activeList].taskList.count + 1
        
        if indexPath.row < placeOfHistoryCell {
            cell.nameLabel.text = listOfTaskLists[activeList].taskList[indexPath.row].name
            cell.nameLabel.textColor = UIColor(red: 122/255, green: 221/255, blue: 117/255, alpha: 1)
            
            cell.pointsLabel.text = String(listOfTaskLists[activeList].taskList[indexPath.row].points)
            cell.pointsLabel.textColor = UIColor(red: 122/255, green: 221/255, blue: 117/255, alpha: 1)
            
            cell.cellView.backgroundColor = UIColor(red: 33/255, green: 53/255, blue: 33/255, alpha: 1)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == placeOfHistoryCell {
            updateHistoryView(cellWithHistory: cellWithHistory)
            cellWithHistory.selectionStyle = .none
            return cellWithHistory
        }
        else if indexPath.row > placeOfHistoryCell && indexPath.row < lastCell {
            cell.nameLabel.text = listOfTaskLists[activeList].taskList[indexPath.row - 1].name
            cell.pointsLabel.text = String(listOfTaskLists[activeList].taskList[indexPath.row - 1].points)
            cell.selectionStyle = .none
            return cell
        }
        else { //lastCell
            if firstTimeLoading {
                let myIndexPath = IndexPath(row: placeOfHistoryCell, section: 0)
                tableView.scrollToRow(at: myIndexPath, at: .top, animated: false)
            }
            firstTimeLoading = false
            emptyCell.isUserInteractionEnabled = false
            return emptyCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < placeOfHistoryCell { //Make task uncompleted
            for _ in 1...10 {
                print("")
            }
            print("uncomplete nr: \(indexPath.row)")
            listOfTaskLists[activeList].taskList[indexPath.row].completed = false
            ref.child(userId).child("lists").child("0").child("tasks").child(String(indexPath.row)).child("completed").setValue("false")
        }
        else if indexPath.row > placeOfHistoryCell { //Make task completed
            listOfTaskLists[activeList].taskList[indexPath.row - 1].completed = true
            ref.child(userId).child("lists").child("0").child("tasks").child(String(indexPath.row - 1)).child("completed").setValue("true")
            for _ in 1...10 {
                print("")
            }
            print("complete nr: \(indexPath.row - 1)")
        }
        listOfTaskLists[activeList].taskList.sort()
        sortFireBaseList()
        updatePlaceOfHistoryCell()
        toDayTableView.reloadData()
        updateProgressBar()
        
        if indexPath.row > placeOfHistoryCell - 1 && indexPath.row - placeOfHistoryCell < 7 { // Scroll to historyCell
            let myIndexPath = IndexPath(row: placeOfHistoryCell, section: 0)
            tableView.scrollToRow(at: myIndexPath, at: .top, animated: false)
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
            cellWithHistory.chartProgressView.barsCanBeClick = true
            cellWithHistory.chartProgressView.barHeight = 150
            cellWithHistory.chartProgressView.maxValue = 100
            cellWithHistory.chartProgressView.barTitleColor = normalTextColor
            cellWithHistory.chartProgressView.progressColor = progressColor
            cellWithHistory.chartProgressView.emptyColor = notProgressColor
            cellWithHistory.chartProgressView.build()
        }
    }
    
    
    // MARK: - FireBase
    func saveHistory() {
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.dateFormat = "yyyyMMdd"
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "EEE"
        
        let dateToSaveAsDate = dateFormatterYear.date(from: dateToSave)
        let currentDateAsString = dateFormatterYear.string(from: Date())
        let currentDate = dateFormatterYear.date(from: currentDateAsString)
        let dayToSaveAsString = dateFormatterDay.string(from: dateToSaveAsDate!)
        
        let timeDifference = dateToSaveAsDate?.timeIntervalSince(currentDate!)
        let differenceInDays = Int(-(timeDifference! / 86400))
        
        if differenceInDays > 0 {
            // Save history from dateToSave
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("points").setValue(String(Int(currentPoints)))
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("percent").setValue(String((currentPoints / maxPoints)*100))
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("date").setValue(dateToSave)
            ref.child(userId).child("history").child(String(listOfHistory.count)).child("day").setValue(dayToSaveAsString)
            listOfHistory.append(OneDaysHistory(points: Int(currentPoints), percent: (currentPoints / maxPoints)*100, date: dateToSave, day: dayToSaveAsString))
            
            //Set all tasks to uncompleted
            for i in 0...listOfTaskLists.count - 1 {
                if listOfTaskLists[i].taskList.count != 0 {
                    for a in 0...listOfTaskLists[i].taskList.count - 1 {
                        listOfTaskLists[i].taskList[a].completed = false
                        ref.child(userId).child("lists").child(String(i)).child("tasks").child(String(a)).child("completed").setValue("false")
                    }
                }
            }
            dateToSave = currentDateAsString
            ref.child(userId).child("info").child("dateToSave").setValue(String(currentDateAsString))
        }
        if differenceInDays > 1 {
            var myComponent = DateComponents()
            for i in 1...differenceInDays - 1 {
                myComponent.day = i-differenceInDays
                let newDate = Calendar.current.date(byAdding: myComponent, to: currentDate!)
                let newDateAsString = dateFormatterYear.string(from: newDate!)
                let newDayAsString = dateFormatterDay.string(from: newDate!)
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("points").setValue("0")
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("percent").setValue("0.0")
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("date").setValue(newDateAsString)
                ref.child(userId).child("history").child(String(listOfHistory.count)).child("day").setValue(newDayAsString)
                listOfHistory.append(OneDaysHistory(points: Int(0), percent: 0.0, date: newDateAsString, day: newDayAsString))
            }
        }
        newDay = 0
        updatePlaceOfHistoryCell()
        updateProgressBar()
        toDayTableView.reloadData()
        let myIndexPath = IndexPath(row: placeOfHistoryCell, section: 0)
        toDayTableView.scrollToRow(at: myIndexPath, at: .top, animated: false)
    }
    
    func sortFireBaseList() {
        ref.child(userId).child("lists").child(String(activeList)).child("tasks").removeValue()
        for i in 0...listOfTaskLists[activeList].taskList.count - 1 {
            let completed = String(listOfTaskLists[activeList].taskList[i].completed)
            let name = listOfTaskLists[activeList].taskList[i].name
            let points = String(listOfTaskLists[activeList].taskList[i].points)
            ref.child(userId).child("lists").child(String(activeList)).child("tasks").child(String(i)).child("completed").setValue(completed)
            ref.child(userId).child("lists").child(String(activeList)).child("tasks").child(String(i)).child("name").setValue(name)
            ref.child(userId).child("lists").child(String(activeList)).child("tasks").child(String(i)).child("points").setValue(points)
        }
    }
    
    
    // MARK: - Colors
    func setColors() {
        progressDoneView.backgroundColor = progressColor
        progressLeftView.backgroundColor = notProgressColor
        view.backgroundColor = viewControllerBackgroundColor
        navigationBar.backgroundColor = headerAndFooterColor
        toDayTableView.backgroundColor = tableViewBackgroundColor
    }
    
    // MARK: - Functions I don't use
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
