//
//  EveryDayViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/21.
//

import UIKit
import Eureka

class EveryDayViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initForm()
    }
    
    func initForm() {
        form +++ SelectableSection<ListCheckRow<String>>("重复直到", selectionType: .singleSelection(enableDeselection: false))

        let continents = ["永远", "特定日期"]
        for option in continents {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.title = option
                listRow.tag = option
                listRow.selectableValue = option
                listRow.value = nil
            }.onChange { row in
                if let section = self.form.sectionBy(tag: "Date") {
                    if row.tag == "特定日期" {
                        section.hidden = false
                        section.evaluateHidden()
                    }else if row.tag == "永远" {
                        section.hidden = true
                        section.evaluateHidden()
                    }
                }
            }
        }
        
        form +++ Section() {
            $0.tag = "Date"
            $0.hidden = true
            $0.evaluateHidden()
        }
            <<< DateRow(){
                $0.title = "截止日期"
                $0.value = Date()
            }
    }
}
