//
//  SampleSplitViewController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/03.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit

class SampleSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isCollapsed == false {
            self.preferredDisplayMode = .primaryOverlay
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preferredDisplayMode = .automatic
    }
}
