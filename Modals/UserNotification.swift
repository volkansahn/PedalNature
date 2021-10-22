//
//  UserNotification.swift
//  PedalNature
//
//  Created by Volkan on 2.10.2021.
//

import Foundation
import UIKit

struct UserNotification{
    let type: notificationType
    let text: String
    let user: User
}

enum notificationType{
    case like(post: UserRoute)
    case follow(state: FollowState)
}
