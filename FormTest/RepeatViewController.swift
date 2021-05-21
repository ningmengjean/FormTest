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
                listRow.selectableValue = option
                listRow.value = nil
            }.onChange({ [weak self] row in
                let nonRow: ListCheckRow<String>? = self?.form.rowBy(tag: "无")
                let dayRow: ListCheckRow<String>? = self?.form.rowBy(tag: "每天")
                let weekRow: ListCheckRow<String>? = self?.form.rowBy(tag: "每周")
                let monthRow: ListCheckRow<String>? = self?.form.rowBy(tag: "每月")
                let yearRow: ListCheckRow<String>? = self?.form.rowBy(tag: "每年")
                let section: Section? = self?.form.sectionBy(tag: "选择间隔时间")
                if nonRow?.selectableValue != nil {
                    section?.hidden = true
                } else if dayRow?.selectableValue  != nil {
                    section?.hidden = false
                }
            })
        }
        
        form +++ Section("选择间隔时间")
            PushRow<String> {
                $0.title = "间隔"
            }
            <<< PushRow<String> {
                $0.title = "天数"
            }
            <<< PushRow<String> {
                $0.title = "直到"
            }
        
    }
}
