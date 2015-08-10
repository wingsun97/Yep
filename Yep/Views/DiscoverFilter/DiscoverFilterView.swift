//
//  DiscoverFilterView.swift
//  Yep
//
//  Created by NIX on 15/7/8.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit


class DiscoverFilterCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        makeUI()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var colorTitleLabel: UILabel = {
        let label = UILabel()
        return label
        }()

    lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.text = "✓"
        label.textColor = UIColor.yepTintColor()
        return label
        }()

    var colorTitleLabelTextColor: UIColor = UIColor.yepTintColor() {
        willSet {
            colorTitleLabel.textColor = newValue
        }
    }

    enum FontStyle {
        case Light
        case Regular
    }

    var colorTitleLabelFontStyle: FontStyle = .Light {
        willSet {
            switch newValue {
            case .Light:
                colorTitleLabel.font = UIFont(name: "Helvetica-Light", size: 18)!
            case .Regular:
                colorTitleLabel.font = UIFont(name: "Helvetica", size: 18)!
            }
        }
    }

    func makeUI() {

        contentView.addSubview(colorTitleLabel)
        contentView.addSubview(checkLabel)
        colorTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        checkLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

        let centerY = NSLayoutConstraint(item: colorTitleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: colorTitleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)

        NSLayoutConstraint.activateConstraints([centerY, centerX])


        let checkLabelCenterY = NSLayoutConstraint(item: checkLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        let checkLabelTrailing = NSLayoutConstraint(item: checkLabel, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1, constant: -20)

        NSLayoutConstraint.activateConstraints([checkLabelCenterY, checkLabelTrailing])
    }

}

class DiscoverFilterView: UIView {

    let totalHeight: CGFloat = 240

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        }()

    lazy var tableView: UITableView = {
        let view = UITableView()

        view.dataSource = self
        view.delegate = self
        view.rowHeight = 60
        view.scrollEnabled = false

        view.registerClass(DiscoverFilterCell.self, forCellReuseIdentifier: "DiscoverFilterCell")
        view.registerClass(ConversationMoreColorTitleCell.self, forCellReuseIdentifier: "ConversationMoreColorTitleCell")
        return view
        }()


    var currentDiscoveredUserSortStyle: DiscoveredUserSortStyle = .Default {
        didSet {
            tableView.reloadData()
        }
    }
    var filterAction: (DiscoveredUserSortStyle -> Void)?

    var tableViewBottomConstraint: NSLayoutConstraint?

    func showInView(view: UIView) {

        frame = view.bounds

        view.addSubview(self)

        layoutIfNeeded()

        containerView.alpha = 1

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: { _ in
            self.containerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)

        }, completion: { _ in
        })

        UIView.animateWithDuration(0.2, delay: 0.1, options: .CurveEaseOut, animations: { _ in
            self.tableViewBottomConstraint?.constant = 0

            self.layoutIfNeeded()

        }, completion: { _ in
        })
    }

    func hide() {

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: { _ in
            self.tableViewBottomConstraint?.constant = self.totalHeight

            self.layoutIfNeeded()

        }, completion: { _ in
        })

        UIView.animateWithDuration(0.2, delay: 0.1, options: .CurveEaseOut, animations: { _ in
            self.containerView.backgroundColor = UIColor.clearColor()

        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    func hideAndDo(afterHideAction: (() -> Void)?) {

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: { _ in
            self.containerView.alpha = 0

            self.tableViewBottomConstraint?.constant = self.totalHeight

            self.layoutIfNeeded()

        }, completion: { finished in
            self.removeFromSuperview()
        })

        delay(0.1) {
            afterHideAction?()
        }
    }

    var isFirstTimeBeenAddAsSubview = true

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if isFirstTimeBeenAddAsSubview {
            isFirstTimeBeenAddAsSubview = false

            makeUI()

            let tap = UITapGestureRecognizer(target: self, action: "hide")
            containerView.addGestureRecognizer(tap)

            tap.cancelsTouchesInView = true
            tap.delegate = self
        }
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

        let tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1.0, constant: self.totalHeight)

        self.tableViewBottomConstraint = tableViewBottomConstraint

        let tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: self.totalHeight)

        NSLayoutConstraint.activateConstraints(tableViewConstraintsH)
        NSLayoutConstraint.activateConstraints([tableViewBottomConstraint, tableViewHeightConstraint])
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DiscoverFilterView: UIGestureRecognizerDelegate {

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {

        if touch.view != containerView {
            return false
        }

        return true
    }
}


extension DiscoverFilterView: UITableViewDataSource, UITableViewDelegate {

    enum Row: Int {
        case Nearby = 0
        case Time
        case Default
        case Cancel
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let row = Row(rawValue: indexPath.row) {
            switch row {

            case .Nearby:

                let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverFilterCell") as! DiscoverFilterCell

                cell.colorTitleLabel.text = DiscoveredUserSortStyle.Distance.name
                cell.colorTitleLabelTextColor = UIColor.yepTintColor()
                cell.colorTitleLabelFontStyle = .Light

                cell.checkLabel.hidden = !(currentDiscoveredUserSortStyle == .Distance)

                return cell

            case .Time:

                let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverFilterCell") as! DiscoverFilterCell

                cell.colorTitleLabel.text = DiscoveredUserSortStyle.LastSignIn.name
                cell.colorTitleLabelTextColor = UIColor.yepTintColor()
                cell.colorTitleLabelFontStyle = .Light

                cell.checkLabel.hidden = !(currentDiscoveredUserSortStyle == .LastSignIn)

                return cell

            case .Default:

                let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverFilterCell") as! DiscoverFilterCell

                cell.colorTitleLabel.text = DiscoveredUserSortStyle.Default.name
                cell.colorTitleLabelTextColor = UIColor.yepTintColor()
                cell.colorTitleLabelFontStyle = .Light

                cell.checkLabel.hidden = !(currentDiscoveredUserSortStyle == .Default)

                return cell

            case .Cancel:

                let cell = tableView.dequeueReusableCellWithIdentifier("ConversationMoreColorTitleCell") as! ConversationMoreColorTitleCell

                cell.colorTitleLabel.text = NSLocalizedString("Cancel", comment: "")
                cell.colorTitleLabelTextColor = UIColor.yepTintColor()
                cell.colorTitleLabelFontStyle = .Regular
                
                return cell
                
            default:
                break
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let row = Row(rawValue: indexPath.row) {
            
            switch row {
                
            case .Nearby:
                filterAction?(.Distance)
                hide()

            case .Time:
                filterAction?(.LastSignIn)
                hide()

            case .Default:
                filterAction?(.Default)
                hide()

            case .Cancel:
                hide()
                
            default:
                break
            }
        }
    }
}
