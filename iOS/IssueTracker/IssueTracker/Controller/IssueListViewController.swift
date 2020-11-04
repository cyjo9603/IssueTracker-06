//
//  ViewController.swift
//  IssueTracker
//
//  Created by 박태희 on 2020/10/27.
//

import UIKit

protocol IssueListViewControllerDelegate: class {
    func issueId(_ id: String)
}

final class IssueListViewController: UIViewController {

    @IBOutlet private weak var issueListCollectionView: UICollectionView!
    private var selectedIndexPath: IndexPath?
    
    private lazy var issueListCollectionViewDataSource: IssueListCollectionViewDataSource = {
        IssueListCollectionViewDataSource(
            collectionView: issueListCollectionView,
            data: MockupData.data)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureIssueListCollectionView()
        removeNavigationBarUnderLine()
    }
    
    private func configureIssueListCollectionView() {
        issueListCollectionView.delegate = self
        issueListCollectionView.dataSource = issueListCollectionViewDataSource
        issueListCollectionView.configureTapGesture(target: self, action: #selector(cellTouched(_:)))
    }
    
    private func removeNavigationBarUnderLine() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cellTouched(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: issueListCollectionView)
        guard let indexPath = issueListCollectionView.indexPathForItem(at: point) else { return }
        selectedIndexPath = indexPath
        moveToIssueDetailViewController()
    }
    
    private func moveToIssueDetailViewController() {
        performSegue(withIdentifier: Constant.issueDetailSegue, sender: nil)
    }
    
    @IBSegueAction func presentIssueDeatilViewController(_ coder: NSCoder) -> IssueDetailViewController? {
        let issueDetailViewController = IssueDetailViewController(coder: coder)
        guard let selectedIndexPath = selectedIndexPath,
              let issueId = MockupData.data[safe: selectedIndexPath.row]?.id
        else {
            return issueDetailViewController
        }
        issueDetailViewController?.issueId(issueId)
        return issueDetailViewController
    }
}

extension IssueListViewController: UICollectionViewDelegate {}

extension IssueListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: issueListCollectionView.bounds.width, height: Metric.cellHeight)
    }
}

private extension IssueListViewController {
    enum Constant {
        static let issueDetailSegue: String = "IssueDetailSegue"
    }
    
    enum Metric {
        static let cellHeight: CGFloat = 100
    }
}