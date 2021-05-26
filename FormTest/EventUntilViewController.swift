//
//  EveryDayViewController.swift
//  FormTest
//
//  Created by 朱晓瑾 on 2021/5/21.
//

import UIKit
import Eureka

protocol EventUntilDelegate: AnyObject {
    func eventUntil(until: String?, specDate: String?, untilType: UntilType)
}

class EventUntilViewController: FormViewController {
    
    var untilType = UntilType.none
    weak var delegate: EventUntilDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavLeftButton()
        initForm()
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
        var until:String?
        var specDate:String?
        if let foreverRow: ListCheckRow<String> = form.rowBy(tag: "永远"), let specDateRow: DateRow = form.rowBy(tag: "sepcDate") {
            if foreverRow.value != nil {
                until = foreverRow.value!
            } else if specDateRow.value != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "YYYY年MM月dd日"
                specDate = dateFormat.string(from:specDateRow.value!)
            }
        }
        delegate?.eventUntil(until: until, specDate: specDate, untilType: untilType)
        self.navigationController?.popViewController(animated: true)
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
            $0.tag = "sepcDate"
            $0.title = "截止日期"
            $0.value = Date()
        }.onChange({ row in
            if row.value?.compare(Date()) == .orderedAscending {
                row.cell!.backgroundColor = .red
            }
            else{
                row.cell!.backgroundColor = .white
            }
            row.updateCell()
        })
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        var until:String?
//        var specDate:String?
//        if let foreverRow: ListCheckRow<String> = form.rowBy(tag: "永远"), let specDateRow: DateRow = form.rowBy(tag: "sepcDate") {
//            if foreverRow.value != nil {
//                until = foreverRow.value!
//            } else if specDateRow.value != nil {
//                let dateFormat = DateFormatter()
//                dateFormat.dateFormat = "YYYY年MM月dd日"
//                specDate = dateFormat.string(from:specDateRow.value!)
//            }
//        }
//        delegate?.eventUntil(until: until, specDate: specDate, untilType: untilType)
//    }
}
