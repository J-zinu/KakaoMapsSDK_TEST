//
//  SamplesTableViewController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/01.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit

class SamplesTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        let title: UILabel = UILabel()
        title.text = "KakaoMapsSDK Samples"
        
        self.navigationItem.titleView = title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sampleGroups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleGroups[section].samples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        cell.textLabel?.text = sampleGroups[indexPath.section].samples[indexPath.row].title
        cell.detailTextLabel?.text = sampleGroups[indexPath.section].samples[indexPath.row].className
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sampleName = sampleGroups[indexPath.section].samples[indexPath.row].className
        showSample(sampleName)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        headerView.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60)
        
        let label: UILabel = UILabel()
        label.frame = headerView.bounds.inset(by: UIEdgeInsets(top: 0, left: tableView.separatorInset.left, bottom: 0, right: 0))
        label.text = sampleGroups[section].title
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func showSample(_ name: String) {
        let container: SampleContainerViewController = self.storyboard!.instantiateViewController(identifier: "SampleContainer")
        container.sampleToLoad = name
        let navController: UINavigationController = UINavigationController(rootViewController: container)
        
        container.navigationItem.leftItemsSupplementBackButton = true
        container.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.splitViewController?.showDetailViewController(navController, sender: nil)        
    }    
}

