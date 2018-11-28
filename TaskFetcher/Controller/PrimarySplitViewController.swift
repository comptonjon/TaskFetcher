//
//  PrimarySplitViewController.swift
//  TaskFetcher
//
//  Created by Jonathan Compton on 11/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class PrimarySplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
        
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }


}
