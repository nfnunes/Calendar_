//
//  ViewController.swift
//  Calendar
//
//  Created by Nuno on 23/06/2017.
//  Copyright © 2017 Nuno. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SpreadsheetView

class WeekVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate{
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var weekSchedule: SpreadsheetView!
    
    let ousideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    let formatter = DateFormatter()
    let days = ["MON", "TUE", "WED", "THUY", "FRI", "SAT", "SUN"]
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
                     UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    let hours = ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00",
                 "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    let data = [
        ["", "", "Take medicine", "", "", "", "", "", "", "", "", "", "", "Movie with family", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Leave for cabin", "", "", "", "", "Lunch with Tim", "", "", "", "", "", "", "", "", "", "", "", "", "", "",  "", "", "", "", "", "",],
        ["", "", "", "", "Downtown parade", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Fireworks show", "", "", "",  "", "", "", "", "", ""],
        ["", "", "", "", "", "Family BBQ", "", "", "", "", "", "", "", "", "", "", "", "", "", "",  "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",  "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "Return home", "", "", "", "", "", "",  "", "", "", "", "", ""]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        setupCalendarView()
        //calendarView.scrollToDate(Date())
        weekSchedule.dataSource = self
        weekSchedule.delegate = self
        
        weekSchedule.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        weekSchedule.intercellSpacing = CGSize(width: 4, height: 1)
        weekSchedule.gridStyle = .none
        
        weekSchedule.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        weekSchedule.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        weekSchedule.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weekSchedule.flashScrollIndicators()
    }
    
    func setupCalendarView(){
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected{
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected{
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = ousideMonthColor
            }
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + days.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + hours.count
    }
    /*func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        let timeCellWidth = weekSchedule.bounds.size.width / 8
        return timeCellWidth
    }*/
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        let cellWidth = weekSchedule.bounds.size.width / 9
        
        if case 0 = column {
            return cellWidth
        } else {
            return cellWidth
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 24
        } else {
            return 35
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1...(days.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = days[indexPath.column - 1]
            cell.label.textColor = dayColors[indexPath.column - 1]
            return cell
        }  else if case (0, 1...(hours.count + 1)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = hours[indexPath.row - 1]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
        } else if case (1...(days.count + 1), 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            let text = data[indexPath.column - 1][indexPath.row - 1]
            if !text.isEmpty {
                cell.label.text = text
                let color = dayColors[indexPath.column - 1]
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            return cell
        }
        return nil
    }
}

extension WeekVC: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")! //not use force in final app!
        let endDate = formatter.date(from: "2017 12 31")! //not use force in final app!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1, firstDayOfWeek: DaysOfWeek(rawValue: 2))
        return parameters
    }
    
}


extension WeekVC: JTAppleCalendarViewDelegate{
    
    //Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}
/*
extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}*/
