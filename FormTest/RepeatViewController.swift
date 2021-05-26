//
//  RepeatViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/20.
//

import UIKit
import Eureka

protocol RepeatDateDelegate: AnyObject {
    func extractRepeatDate(info:[String:Any], type: String)
}

enum WeekDay: String, CaseIterable {
    case 星期日,星期一,星期二,星期三,星期四,星期五,星期六
}

enum RepeatInterval: String {
    case 天,周,月,年
}

enum UntilType {
    case day, month, year, week, none
}

class RepeatViewController: FormViewController, EventUntilDelegate {
    
    weak var repeatDelegate: RepeatDateDelegate?
    
    func eventUntil(until: String?, specDate: String?, untilType: UntilType) {
        
        var targetTag = ""
        
        switch untilType {
        case .day:
            targetTag = "dayUntil"
        case .month:
            targetTag = "monthUntil"
        case .year:
            targetTag = "yearUntil"
        case .week:
            targetTag = "weekUntil"
        default:
            break
        }
        if let targetRow: ButtonRow = self.form.rowBy(tag: targetTag) {
            targetRow.cellStyle = .value1
            if until != nil {
                targetRow.cellUpdate({ cell, row in
                    cell.detailTextLabel?.text = until
                    row.value = until
                })
            } else if specDate != nil {
                targetRow.cellUpdate({ cell, row in
                    cell.detailTextLabel?.text = specDate
                    row.value = specDate
                })
            }
        }
    }
    
    weak var delegate: EventUntilDelegate?
    var selectedType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavLeftButton()
        initForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isBeingPresented || self.isMovingToParent{
            if let row: ListCheckRow<String> = form.rowBy(tag: "NONE") {
            row.didSelect()
            }
        }
    }
    
    func setNavLeftButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25 )
        button.setImage(UIImage.init(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 35)));
        view.addSubview(button)
        
        let leftButton = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func tapBack() {
        let repeatInfo = form.values().compactMapValues({$0})
        //print(selectableSection.selectedRow()?.value)
        
        repeatDelegate?.extractRepeatDate(info: repeatInfo, type: selectedType ?? "NONE")
        self.navigationController?.popViewController(animated: true)
    }
    
    func returnArray (unit: String) -> [String] {
        var arr = [String]()
        for i in 1...30 {
            arr.append("\(i)\(unit)")
        }
        return arr
    }
    
    func initForm () {
        
        form +++ SelectableSection<ListCheckRow<String>>("选择重复时间", selectionType: .singleSelection(enableDeselection: false)) {
            $0.tag = "repeat"
        }

        let continents: KeyValuePairs = ["无":"NONE", "每天":"DAILY", "每周":"WEEKLY", "每月":"MONTHLY", "每年":"YEARLY"]
        for (option, value) in continents {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.title = option
                listRow.tag = value
                listRow.selectableValue = option
                listRow.value = nil
            }.onChange { row in
                if let daySection = self.form.sectionBy(tag: "daySection"), let weekSection = self.form.sectionBy(tag: "weekSection"),
                   let monthSection = self.form.sectionBy(tag: "monthSection"),let yearSection = self.form.sectionBy(tag: "yearSection"){
                    if row.tag == "NONE" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "DAILY" {
                        daySection.hidden = false
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "WEEKLY" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = false
                        weekSection.evaluateHidden()
                        monthSection.hidden = true
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "MONTHLY" {
                        daySection.hidden = true
                        daySection.evaluateHidden()
                        weekSection.hidden = true
                        weekSection.evaluateHidden()
                        monthSection.hidden = false
                        monthSection.evaluateHidden()
                        yearSection.hidden = true
                        yearSection.evaluateHidden()
                    } else if row.tag == "YEARLY" {
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
                                                                                            vc.untilType = .day
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
                                                                                            vc.untilType = .month
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
            row.cellStyle = .value1
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
                                                                                            let vc = EventUntilViewController()
                                                                                            vc.delegate = self
                                                                                            vc.untilType = .year
                                                                                            return vc }), onDismiss: nil)
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
            row.cellStyle = .value1
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
                                                                                            let vc = EventUntilViewController()
                                                                                            vc.delegate = self
                                                                                            vc.untilType = .week
                                                                                            return vc }), onDismiss: nil)
        }
    }
    
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
            if let value = (row.section as! SelectableSection<ListCheckRow<String>>).selectedRow()?.baseValue as? String {
                self.selectedType = value
            }
        }
    }
}


