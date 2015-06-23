//
//  ConversationMoreView.swift
//  Yep
//
//  Created by NIX on 15/6/24.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class ConversationMoreView: UIView {

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        return view
        }()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 60
        view.scrollEnabled = false
        return view
        }()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        makeUI()
    }

    func makeUI() {

        addSubview(containerView)
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)

        containerView.addSubview(tableView)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)

        let viewsDictionary = [
            "containerView": containerView,
            "tableView": tableView,
        ]

        // layout for containerView

        let containerViewConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let containerViewConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)

        NSLayoutConstraint.activateConstraints(containerViewConstraintsH)
        NSLayoutConstraint.activateConstraints(containerViewConstraintsV)

        // layour for tableView

        let tableViewConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)

        let tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: 0)

        let tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 300)

        NSLayoutConstraint.activateConstraints(tableViewConstraintsH)
        NSLayoutConstraint.activateConstraints([tableViewBottomConstraint, tableViewHeightConstraint])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ConversationMoreView: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

