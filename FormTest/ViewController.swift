//
//  ViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/20.
//

import UIKit
import Eureka

class NativeEventNavigationController: UINavigationController, RowControllerType {
    var onDismissCallback : ((UIViewController) -> ())?
}

//public protocol PresenterRowType: TypedRowType {
//    associatedtype ProviderType : UIViewController, TypedRowControllerType
//    var presentationMode: PresentationMode<ProviderType>? { get set }
//    var onPresentCallback: ((FormViewController, ProviderType)->())? { get set }
//}
//
//public final class CustomPushRow<T: Equatable>: SelectorRow<PushSelectorCell<T>, SelectorViewController<T>>, RowType {
//
//    public required init(tag: String?) {
//        super.init(tag: tag)
//        presentationMode = .show(controllerProvider: ControllerProvider.callback {
//            return SelectorViewController<T>(){ _ in }
//            }, onDismiss: { vc in
//                _ = vc.navigationController?.popViewController(animated: true)
//        })
//    }
//}


class ViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
    }
    
    private func initializeForm() {

        form +++

            TextRow("标题").cellSetup { cell, row in
                row.title = "标题："
                cell.textField.placeholder = "请输入标题"
            }

            <<< TextRow("地点").cellSetup { cell, row in
                row.title = "地点："
                cell.textField.placeholder = "请输入地点"
            }

            +++

            SwitchRow("全天") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "开始时间")
                    let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "结束时间")

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

            <<< DateTimeInlineRow("开始时间") {
                $0.title = $0.tag
                $0.value = Date()
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "结束时间")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { [weak self] cell, row, inlineRow in
                    inlineRow.cellUpdate() { cell, row in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "全天")
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

            <<< DateTimeInlineRow("结束时间"){
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "开始时间")
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
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "全天")
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

            PushRow<RepeatInterval>("重复") {
                $0.title = $0.tag
                $0.options = RepeatInterval.allCases
                $0.value = .Never
                }.onPresent({ (_, vc) in
                    vc.enableDeselection = false
                    vc.dismissOnSelection = false
                })
            <<< TextAreaRow("描述") {
                $0.placeholder = $0.tag
            }
        
    }
    
    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        (navigationController as? NativeEventNavigationController)?.onDismissCallback?(self)
    }
    
    enum RepeatInterval : String, CaseIterable, CustomStringConvertible {
        case Never = "无"
        case Every_Day = "每天"
        case Every_Week = "每周"
        case Every_Month = "每月"
        case Every_Year = "每年"

        var description : String { return rawValue }
    }
}

