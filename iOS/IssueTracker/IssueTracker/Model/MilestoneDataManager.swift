//
//  MilestoneDataProvider.swift
//  IssueTracker
//
//  Created by 박태희 on 2020/11/05.
//

import Foundation

struct MilestoneDataManager {
    
    func post(
        body: Milestone,
        successHandler: ((Int?) -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil) {
        
        guard let url = URL(string: IssueTrackerURL.milestone) else { return }
        HTTPServiceHelper.shared.post(
            url: url,
            body: body,
            responseKeyID: Milestone.Key.milestoneID,
            successHandler: {
                successHandler?($0.id)
            },
            errorHandler: {
                errorHandler?($0)
            }
        )
    }
        
    func put(
        body: Milestone,
        successHandler: ((Bool) -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil) {
        
        guard let url = URL(string: "\(IssueTrackerURL.milestone)/\(body.id)") else { return }
        HTTPServiceHelper.shared.put(url: url, body: body, successHandler: {
            successHandler?($0)
        },
        errorHandler: {
            errorHandler?($0)
        })
    }
    
    
    func get(
        successHandler: ((Milestones?) -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil) {
        
        guard let url = IssueTrackerURL.milestones else { return }
        HTTPServiceHelper.shared.get(url: url, responseType: Milestones.self, successHandler: {
            guard let milestones = $0 else {
                successHandler?(nil)
                return
            }
            successHandler?(Milestones(milestones: milestones))
        }, errorHandler: {
            errorHandler?($0)
        })
    }
    
    func getIssues(
        name: String,
        successHandler: ((Issues?) -> Void)? = nil,
        errorHandler: ((Error) -> Void)? = nil) {
        
        let processedName = name.processedBlank
        var urlString = IssueTrackerURL.issues
        urlString.append(processedName)
        guard let url = URL(string: urlString) else {
            return }
        HTTPServiceHelper.shared.get(url: url, responseType: Issues.self, successHandler: {
            guard let issues = $0 else {
                successHandler?(nil)
                return
            }
            successHandler?(Issues(issues: issues))
        }, errorHandler: {
            errorHandler?($0)
        })
    }
}

extension MilestoneDataManager {
    
    static func createMilestone(
        _ milestone: Milestone? = nil,
        milestoneDictionary: [String: String]) -> Milestone? {
        
        guard let title = milestoneDictionary[Milestone.Key.title],
              let completeDate = milestoneDictionary[Milestone.Key.completeDate],
              let description = milestoneDictionary[Milestone.Key.description]
        else {
            return nil
        }
        let id = milestone != nil ? (milestone?.id) ?? .zero : .zero
        return Milestone(
            date: completeDate,
            description: description,
            id: id,
            isOpen: 1,
            name: title
        )
    }
}

private extension MilestoneDataManager {
    
    enum IssueTrackerURL {
        static let milestone: String = "https://issue-tracker.cf/api/milestone"
        static let milestones = URL(string: "http://issue-tracker.cf/api/milestones")
        static let issues: String = "http://issue-tracker.cf/api/issues?milestone="
    }
}
