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
    
    func initForm () {
        form +++ SelectableSection<ListCheckRow<String>>("选择重复时间", selectionType: .singleSelection(enableDeselection: true))

        let continents = ["无", "每天", "每周", "每月", "每年"]
        for option in continents {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.title = option
                listRow.tag = option
                listRow.selectableValue = option
                listRow.value = nil
            }
            .onChange { row in
                if row.tag == "无" {
                    if let section = self.form.sectionBy(tag: "test")
                    {
                        section.hidden = true
                        section.evaluateHidden()
                    }
                } else if row.tag == "每天" {
                    if let section = self.form.sectionBy(tag: "test")
                    {
                        section.hidden = false
                        section.evaluateHidden()
                    }
                    if let everyDayrow = self.form.rowBy(tag: "天数") {
                        everyDayrow.hidden = true
                        everyDayrow.evaluateHidden()
                    }
                } else if row.tag != "无" || row.tag != "每天" {
                    if let section = self.form.sectionBy(tag: "test")
                    {
                        section.hidden = false
                        section.evaluateHidden()
                    }
                    if let everyDayrow = self.form.rowBy(tag: "天数") {
                        everyDayrow.hidden = false
                        everyDayrow.evaluateHidden()
                    }
                }
            }
            
        }
        
        form +++ Section() {
            $0.tag = "test"
        }
        <<< PushRow<String> {
            $0.title = "间隔"
            $0.tag = "间隔"
        }
        <<< PushRow<String> {
            $0.title = "天数"
            $0.tag = "天数"
        }
        <<< PushRow<String> {
            $0.title = "直到"
            $0.tag = "直到"
        }
    }
    


}
