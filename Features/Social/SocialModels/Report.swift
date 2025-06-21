//
//  Report.swift
//  VybeMVP
//
//  User reporting model for content moderation and App Store compliance
//

import Foundation
import FirebaseFirestore

/**
 * Report model for user-generated content moderation
 * Allows users to report inappropriate posts, comments, or other users
 */
struct Report: Codable, Identifiable {
    @DocumentID var id: String?
    
    let reporterId: String          // Firebase UID of user making the report
    let reporterName: String        // Display name of reporter
    let reportedContentId: String   // ID of the reported content (post, comment, etc.)
    let reportedUserId: String      // Firebase UID of the user being reported
    let reportedUserName: String    // Display name of reported user
    let contentType: ReportContentType  // Type of content being reported
    let reason: ReportReason        // Reason for the report
    let customReason: String?       // Custom reason if "other" is selected
    let description: String?        // Additional details from reporter
    let timestamp: Date
    let status: ReportStatus        // Current status of the report
    let reviewedBy: String?         // Admin who reviewed the report
    let reviewedAt: Date?           // When the report was reviewed
    let resolution: String?         // What action was taken
    
    init(
        reporterId: String,
        reporterName: String,
        reportedContentId: String,
        reportedUserId: String,
        reportedUserName: String,
        contentType: ReportContentType,
        reason: ReportReason,
        customReason: String? = nil,
        description: String? = nil
    ) {
        self.reporterId = reporterId
        self.reporterName = reporterName
        self.reportedContentId = reportedContentId
        self.reportedUserId = reportedUserId
        self.reportedUserName = reportedUserName
        self.contentType = contentType
        self.reason = reason
        self.customReason = customReason
        self.description = description
        self.timestamp = Date()
        self.status = .pending
        self.reviewedBy = nil
        self.reviewedAt = nil
        self.resolution = nil
    }
}

/**
 * Types of content that can be reported
 */
enum ReportContentType: String, CaseIterable, Codable {
    case post = "post"
    case comment = "comment"
    case user = "user"
    case reaction = "reaction"
    
    var displayName: String {
        switch self {
        case .post:
            return "Post"
        case .comment:
            return "Comment"
        case .user:
            return "User Profile"
        case .reaction:
            return "Reaction"
        }
    }
}

/**
 * Predefined reasons for reporting content
 */
enum ReportReason: String, CaseIterable, Codable {
    case spam = "spam"
    case harassment = "harassment"
    case hateSpeech = "hate_speech"
    case inappropriateContent = "inappropriate_content"
    case misinformation = "misinformation"
    case impersonation = "impersonation"
    case violatesTerms = "violates_terms"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .spam:
            return "Spam"
        case .harassment:
            return "Harassment or Bullying"
        case .hateSpeech:
            return "Hate Speech"
        case .inappropriateContent:
            return "Inappropriate Content"
        case .misinformation:
            return "False Information"
        case .impersonation:
            return "Impersonation"
        case .violatesTerms:
            return "Violates Terms of Service"
        case .other:
            return "Other"
        }
    }
    
    var description: String {
        switch self {
        case .spam:
            return "Unwanted repetitive content or promotional material"
        case .harassment:
            return "Content that targets or intimidates another user"
        case .hateSpeech:
            return "Content that promotes hatred based on identity"
        case .inappropriateContent:
            return "Content that is offensive or not suitable for our community"
        case .misinformation:
            return "Content that spreads false or misleading information"
        case .impersonation:
            return "User is pretending to be someone else"
        case .violatesTerms:
            return "Content that violates our Terms of Service"
        case .other:
            return "Please describe the issue in detail"
        }
    }
}

/**
 * Status of a report in the moderation system
 */
enum ReportStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case reviewing = "reviewing"
    case resolved = "resolved"
    case dismissed = "dismissed"
    
    var displayName: String {
        switch self {
        case .pending:
            return "Pending Review"
        case .reviewing:
            return "Under Review"
        case .resolved:
            return "Resolved"
        case .dismissed:
            return "Dismissed"
        }
    }
    
    var color: String {
        switch self {
        case .pending:
            return "orange"
        case .reviewing:
            return "blue"
        case .resolved:
            return "green"
        case .dismissed:
            return "gray"
        }
    }
} 