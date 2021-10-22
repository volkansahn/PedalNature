//
//  UserRoute.swift
//  PedalNature
//
//  Created by Volkan on 30.09.2021.
//

import Foundation

struct UserRoute{
    let identifier: String
    let owner: User
    let routeMapImage: URL
    let velocityGraph: URL
    let routeMapThumbnailImage: URL
    let routeContent : [Content]
    let routeName: String
    let routeLength: String
    let routeDuration: String
    let city: String
    let coordinates: [Coordinate]
    let elevations: [Elevation]
    let speeds: [Speed]
    let likeCount : [RouteLikes]
    let comments: [RouteComment]
    let createdDate: Date
    let tagUser: [User]
    let elevationGraph: URL
}

struct RouteLikes{
    let identifier: String
    let postIdentifier: String
    let user: User
}

struct Elevation{
    let elevation: Double
}

struct Speed{
    let speed: Double
}

struct CommentLikes{
    let identifier: String
    let commentIdentifier: String
    let user: User
}

struct RouteComment{
    let identifier: String
    let commentIdentifier: String
    let user: User
    let text: String
    let createdDate: Date
    let likes: [CommentLikes]
    let replyComment : [RouteComment]
}

struct Coordinate{
    let identifier: String
    let routeIdentifier: String
    let latitude: String
    let longitude: String
}

struct User{
    let identifier: String
    let userName: String
    let profilePhoto: URL
    let name: (first: String, last: String)
    let birthDate: Date
    let bio: String
    let counts: UserCounts
    let joinDate: Date
}

struct UserCounts{
    let following: Int
    let followers: Int
    let post: Int
}

struct Content{
    let imageURL : String?
    let videoURL : String?
    let latitude : String
    let longitude : String
}

