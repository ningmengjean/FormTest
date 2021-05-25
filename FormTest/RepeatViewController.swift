//
//  RepeatViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/20.
//

import UIKit
import Eureka

class RepeatViewController: FormViewController, EventUntilDelegate {
    
    func eventUntil(until: String?, specDate: String?) {
        if let dayRow: ButtonRow = self.form.rowBy(tag: "dayUntil") {
            dayRow.cellStyle = .value1
            if until != nil {
                dayRow.cellUpdate({ cell, row in
                    cell.detailTextLabel?.text = until
                })
            } else if specDate != nil {
                dayRow.cellUpdate({ cell, row in
                    cell.detailTextLabel?.text = specDate
                })
            }
        } else if let monthRow: ButtonRow = self.form.rowBy(tag: "monthUntil") {
            monthRow.cellStyle = .value1
            if until != nil {
                monthRow.cellUpdate({ cell, row in
                    cell.detailTextLabel?.text = until
                })
            } else if specDate != nil {
                monthRow.cellUpdate({ cell, row in
                    cell.detailTextLabel?.text = specDate
                })
            }
        }
       
    }
    
    weak var delegate: EventUntilDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isBeingPresented || self.isMovingToParent{
            if let row: ListCheckRow<String> = form.rowBy(tag: "无") {
            row.didSelect()
            }
        }
    }
    
    func initForm () {
        
        form +++ SelectableSection<ListCheckRow<String>>("选择重复时间", selectionType: .singleSelection(enableDeselection: false)) {
            $0.tag = "repeat"
        }

        let continents = ["无", "每天", "每周", "每月", "每年"]
        for option in continents {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.title = option
                listRow.tag = option
                listRow.selectableValue = option
                listRow.value = nil
            }.onChange { row in
                if let daySection = self.form.sectionBy(tag: "daySection"), let weekSection = self.form.sectionBy(tag: "weekSection"),
                   let monthSection = self.form.sectionBy(tag: "monthSection"),let yearSection = self.form.sectionBy(tag: "yearSection"){
                    if row.tag == "无" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "每天" {
                        daySection.hidden = false
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "每周" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = false
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "每月" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = false
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "每年" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = false
                        yearSection.evaluateHidden()
                    }
                }
            }
        }
        
        form +++ Section() { section in
            section.tag = "daySection"
        }
        <<< PushRow<String> {
            $0.title = "间隔"
            $0.tag = "dayInterval"
            $0.value = "1\(RepeatInterval.天.rawValue)"
            $0.options = self.returnArray(unit:RepeatInterval.天.rawValue)
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< ButtonRow() { (row: ButtonRow) -> Void in
            row.tag = "dayUntil"
            row.title = "直到"
            row.cellStyle = .value1
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
                                                                                            let vc = EventUntilViewController()
                                                                                            vc.delegate = self
                                                                                            return vc }), onDismiss: nil)
        }
        
        form +++ Section() { section in
            section.tag = "monthSection"
        }
        <<< PushRow<String> {
            $0.title = "间隔"
            $0.tag = "monthInterval"
            $0.value = "1\(RepeatInterval.月.rawValue)"
            $0.options = self.returnArray(unit:RepeatInterval.月.rawValue)
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< ButtonRow() { (row: ButtonRow) -> Void in
            row.tag = "monthUntil"
            row.title = "直到"
            row.cellStyle = .value1
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
                                                                                            let vc = EventUntilViewController()
                                                                                            vc.delegate = self
                                                                                            return vc }), onDismiss: nil)
        }
        
        form +++ Section() { section in
            section.tag = "yearSection"
        }
        <<< PushRow<String> {
            $0.title = "间隔"
            $0.tag = "yearInterval"
            $0.value = "1\(RepeatInterval.年.rawValue)"
            $0.options = self.returnArray(unit:RepeatInterval.年.rawValue)
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< ButtonRow() { (row: ButtonRow) -> Void in
            row.tag = "yearUntil"
            row.title = "直到"
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {  return EventUntilViewController() }),
                                         onDismiss: nil
            )
        }
        
        form +++ Section() {
            $0.tag = "weekSection"
        }
        <<< PushRow<String> {
            $0.title = "间隔"
            $0.tag = "weekInterval"
            $0.value = "1\(RepeatInterval.周.rawValue)"
            $0.options = self.returnArray(unit:RepeatInterval.周.rawValue)
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< PushRow<WeekDay> {
            $0.title = "天数"
            $0.tag = "dayCount"
            $0.value = .星期一
            $0.options = WeekDay.allCases
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< ButtonRow() { (row: ButtonRow) -> Void in
            row.tag = "weekUntil"
            row.title = "直到"
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {  return EventUntilViewController() }),
                                         onDismiss: nil
            )
        }
    }
    
    enum WeekDay: String, CaseIterable {
        case 星期日,星期一,星期二,星期三,星期四,星期五,星期六
    }
    
    enum RepeatInterval: String {
        case 天,周,月,年
    }
    
    func returnArray (unit: String) -> [String] {
        var arr = [String]()
        for i in 1...30 {
            arr.append("\(i)\(unit)")
        }
        return arr
    }
}


