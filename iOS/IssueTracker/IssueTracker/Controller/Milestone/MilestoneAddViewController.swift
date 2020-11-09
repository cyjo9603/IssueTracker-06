//
//  LabelAddViewController.swift
//  IssueTracker
//
//  Created by eunjeong lee on 2020/11/09.
//

import UIKit

final class MilestoneAddViewController: UIViewController {

    @IBOutlet private weak var addView: AddView!
    @IBOutlet private weak var addViewCenterYConstraint: NSLayoutConstraint!
    private let dataSource = MilestoneAddViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddView()
    }
    
    private func configureAddView() {
        addView.delegate = self
        addView.dataSource = dataSource
    }
    
    private func save(milestone: Milestone) {
        dismiss(animated: false, completion: nil)
    }
}

extension MilestoneAddViewController: AddViewDelegate {
    
    func closeButtonTouched(_ addView: AddView) {
        dismiss(animated: false, completion: nil)
    }
    
    func saveButtonTouched(_ addView: AddView, inputTexts: [String : String]) {
        guard let milestone = MilestoneDataProvider.createMilestone(milestoneDictionary: inputTexts)
        else {
            return
        }
        save(milestone: milestone)
    }
}
