//
//  RepeatViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/20.
//

import UIKit
import Eureka


class RepeatViewController: FormViewController {
    
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
        form +++ SelectableSection<ListCheckRow<String>>("选择重复时间", selectionType: .singleSelection(enableDeselection: false))

        let continents = ["无", "每天", "每周", "每月", "每年"]
            for option in continents {
                form.last! <<< ListCheckRow<String>(option){ listRow in
                    listRow.title = option
                    listRow.tag = option
                    listRow.selectableValue = option
                    listRow.value = nil
                }.onChange { row in
                    if let daySection = self.form.sectionBy(tag: "day"), let weekSection = self.form.sectionBy(tag: "week") {
                        if row.tag == "无" {
                            daySection.hidden = true
                            daySection.evaluateHidden()
                            weekSection.hidden = true
                            weekSection.evaluateHidden()
                        } else if row.tag == "每天" {
                            daySection.hidden = false
                            daySection.evaluateHidden()
                            weekSection.hidden = true
                            weekSection.evaluateHidden()
                        } else if row.tag == "每月" {
                            daySection.hidden = false
                            daySection.evaluateHidden()
                            weekSection.hidden = true
                            weekSection.evaluateHidden()
                        }
                    }
                }
            }
        
        form +++ Section() {
            $0.tag = "day"
        }
        <<< PushRow<String> {
            $0.title = "间隔"
            $0.tag = "间隔"
            let repeatInterval: RepeatInterval = .天
            switch repeatInterval {
            case .天:
                $0.value = "1\(RepeatInterval.天.rawValue)"
                $0.options = returnArray(unit:RepeatInterval.天.rawValue)
            case .月:
                $0.value = "1\(RepeatInterval.月.rawValue)"
                $0.options = returnArray(unit:RepeatInterval.月.rawValue)
            case .年:
                $0.value = "1\(RepeatInterval.年.rawValue)"
                $0.options = returnArray(unit:RepeatInterval.年.rawValue)
            }
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< ButtonRow("直到") { (row: ButtonRow) -> Void in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {  return EveryDayViewController() }),
                                         onDismiss: nil
            )
        }
        
        form +++ Section() {
            $0.tag = "week"
        }
        <<< PushRow<RepeatWeekInterval> {
            $0.title = "间 隔"
            $0.tag = "间 隔"
            $0.value = .一周
            $0.options = RepeatWeekInterval.allCases
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< PushRow<WeekDay> {
            $0.title = "天数"
            $0.tag = "天数"
            $0.value = .星期一
            $0.options = WeekDay.allCases
        }.onPresent({ (_, vc) in
            vc.enableDeselection = false
            vc.dismissOnSelection = false
        })
        <<< ButtonRow("直 到") { (row: ButtonRow) -> Void in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {  return EveryDayViewController() }),
                                         onDismiss: nil
            )
        }
    }
    
    enum RepeatDayInterval:Int,CaseIterable {
        case 一天,两天,三天,四天,五天,六天,七天,八天,九天,十天,十一天,十二天,十三天,十四天,十五天,十六天,十七天,十八天,十九天,二十天,二十一天,二十二天,二十三天,二十四天,二十五天,二十六天,二十七天,二十八天,二十九天,三十天
    }
    
    enum RepeatWeekInterval:Int,CaseIterable {
        case 一周,两周,三周,四周,五周,六周,七周,八周,九周,十周,十一周,十二周,十三周,十四周,十五周,十六周,十七周,十八周,十九周,二十周,二十一周,二十二周,二十三周,二十四周,二十五周,二十六周,二十七周,二十八周,二十九周,三十周
    }
    
    enum WeekDay: String, CaseIterable {
        case 星期日,星期一,星期二,星期三,星期四,星期五,星期六
    }
    
    enum RepeatInterval: String {
        case 天,月,年
    }
    
    func returnArray (unit: String) -> [String] {
        var arr = [String]()
        for i in 1...30 {
            arr.append("\(i)\(unit)")
        }
        return arr
    }
    
}


