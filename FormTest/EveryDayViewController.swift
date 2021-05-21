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
        form +++
            PushRow<String> {
                $0.title = "间隔"
            }
            <<< PushRow<String> {
                $0.title = "直到"
            }
    }


}
