//
//  ViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/20.
//

import UIKit
import Eureka

class ViewController: FormViewController, RepeatDateDelegate {
    
    var repeatInfo = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
    }
    
    func extractRepeatDate(info: [String : Any], type: String) {
        self.repeatInfo = info
        if let row: ButtonRow = self.form.rowBy(tag: "repeat") {
            row.cellStyle = .value1
            row.cellUpdate { cell, row in
               row.value = type
               cell.detailTextLabel?.text = type
            }
        }
    }
    
    private func initializeForm() {

        form +++

            TextRow("summary").cellSetup { cell, row in
                row.title = "标题："
                cell.textField.placeholder = "请输入标题"
            }

            <<< TextRow("location").cellSetup { cell, row in
                row.title = "地点："
                cell.textField.placeholder = "请输入地点"
            }

            +++

            SwitchRow("isAllDay") {
                $0.title = "全天"
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "startDate")
                    let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "endDate")

                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .medium
                        startDate.dateFormatter?.timeStyle = .none
                        endDate.dateFormatter?.dateStyle = .medium
                        endDate.dateFormatter?.timeStyle = .none
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .short
                        startDate.dateFormatter?.timeStyle = .short
                        endDate.dateFormatter?.dateStyle = .short
                        endDate.dateFormatter?.timeStyle = .short
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }

            <<< DateTimeInlineRow("startDate") {
                $0.title = "开始时间"
                $0.value = Date()
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "endDate")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate() { cell, row in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "isAllDay")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }

            <<< DateTimeInlineRow("endDate"){
                $0.title = "结束时间"
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "startDate")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate { cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "isAllDay")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
                }
        form +++

            ButtonRow() { (row: ButtonRow) -> Void in
                row.tag = "repeat"
                row.title = "重复"
                row.cellStyle = .value1
                row.presentationMode = .show(controllerProvider: ControllerProvider.callback(builder: {
                                                                                                let vc = RepeatViewController()
                                                                                                vc.repeatDelegate = self
                                                                                                return vc }), onDismiss: nil)
            }.cellSetup({ cell, row in
                row.cellStyle = .value1
                cell.detailTextLabel?.text = "无"
            })
        form +++
            
            TextAreaRow("description") {
                $0.placeholder = "描述"
            }
    }
}




