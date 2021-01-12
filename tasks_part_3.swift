//
//  main.swift
//  FirstCourseFinalTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

let checker = Checker(usersStorageClass: UserStorage.self,
                      postsStorageClass: PostStorage.self)
checker.run()

class User: UserProtocol {
    var id: Identifier
    var username: String
    var fullName: String
    var avatarURL: URL?
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
    
    init(userData: UserInitialData, followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        id = userData.id
        username = userData.username
        fullName = userData.fullName
        avatarURL = userData.avatarURL
        currentUserFollowsThisUser = !(followers.filter { $0.1 == userData.id  && $0.0 == currentUserID}).isEmpty
        currentUserIsFollowedByThisUser = !(followers.filter { $0.0 == userData.id  && $0.1 == currentUserID}).isEmpty
        followsCount = followers.filter { $0.0 == userData.id }.count
        followedByCount = followers.filter { $0.1 == userData.id }.count
    }
    
    init?(userID: GenericIdentifier<UserProtocol>, users: [UserInitialData], followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        if let user = users.first(where: { $0.id == userID }) {
            id = user.id
            username = user.username
            fullName = user.fullName
            avatarURL = user.avatarURL
            currentUserFollowsThisUser = !(followers.filter { $0.1 == user.id  && $0.0 == currentUserID}).isEmpty
            currentUserIsFollowedByThisUser = !(followers.filter { $0.0 == user.id  && $0.1 == currentUserID}).isEmpty
            followsCount = followers.filter { $0.0 == user.id }.count
            followedByCount = followers.filter { $0.1 == user.id }.count
        } else { return nil }
    }
}

class UserStorage: UsersStorageProtocol {
    private var users: [UserInitialData]
    private var followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)]
    private var currentUserID: GenericIdentifier<UserProtocol>
    
    required init?(users: [UserInitialData], followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        guard !users.filter({ $0.id == currentUserID }).isEmpty else { return nil }
        
        self.users = users
        self.followers = followers
        self.currentUserID = currentUserID
    }
    
    var count: Int { return users.count }
    
    
    func currentUser() -> UserProtocol {
        let user = users.first(where: { $0.id == currentUserID })
        return User.init(userData: user!, followers: followers, currentUserID: currentUserID)
    }
    
    func user(with userID: GenericIdentifier<UserProtocol>) -> UserProtocol? {
        guard let user = users.first(where: { $0.id == userID }) else { return nil }
        
        return User.init(userData: user, followers: followers, currentUserID: currentUserID)
    }
    
    func findUsers(by searchString: String) -> [UserProtocol] {
        let needUsers = users.filter { $0.username.contains(searchString) }
        if needUsers.isEmpty { return [] }
        
        return needUsers.map { User.init(userData: $0,followers: followers,currentUserID: currentUserID) }}
    
    
    func follow(_ userIDToFollow: GenericIdentifier<UserProtocol>) -> Bool {
        if let followingUser = users.first(where: { $0.id == userIDToFollow })?.id {
            followers.append((currentUserID, followingUser))
            return true
        } else {
            return false
        }
    }
    
    func unfollow(_ userIDToUnfollow: GenericIdentifier<UserProtocol>) -> Bool {
        if let unfollowingUser = users.first(where: { $0.id == userIDToUnfollow })?.id {
            followers.removeAll(where: { $0.1 == unfollowingUser && $0.0 == currentUserID })
            return true
        } else {
            return false
        }
    }
    
    func usersFollowingUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard users.first(where: { $0.id == userID }) != nil else { return nil }
        return followers.filter { $0.1 == userID }.map { User.init(userID: $0.0, users: users, followers: followers, currentUserID: currentUserID)!}
    }
    
    func usersFollowedByUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard users.first(where: { $0.id == userID }) != nil else { return nil }
        return followers.filter { $0.0 == userID }.map { User.init(userID: $0.1, users: users, followers: followers, currentUserID: currentUserID)!}
    }
}

class Post: PostProtocol {
    var id: Identifier
    var author: GenericIdentifier<UserProtocol>
    var description: String
    var imageURL: URL
    var createdTime: Date
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    
    init(postData: PostInitialData, likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        id = postData.id
        author = postData.author
        description = postData.description
        imageURL = postData.imageURL
        createdTime = postData.createdTime
        currentUserLikesThisPost = !(likes.filter{ $0.1 == postData.id && $0.0 == currentUserID }.isEmpty)
        likedByCount = likes.filter { $0.1 == postData.id }.count
    }
}

class PostStorage: PostsStorageProtocol {
    private var posts: [PostInitialData]
    private var likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)]
    private var currentUserID: GenericIdentifier<UserProtocol>
    
    required init(posts: [PostInitialData], likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        self.posts = posts
        self.likes = likes
        self.currentUserID = currentUserID
    }
    
    var count: Int { posts.count }
    
    func post(with postID: GenericIdentifier<PostProtocol>) -> PostProtocol? {
        guard let post = posts.first(where: { $0.id == postID }) else { return nil }
        
        return Post.init(postData: post, likes: likes, currentUserID: currentUserID)
    }
    
    func findPosts(by authorID: GenericIdentifier<UserProtocol>) -> [PostProtocol] {
        return posts.filter { $0.author == authorID }.map { Post.init(postData: $0, likes: likes, currentUserID: currentUserID) }
    }
    
    func findPosts(by searchString: String) -> [PostProtocol] {
        let needPosts = posts.filter { $0.description.contains(searchString) }
        if needPosts.isEmpty { return [] }
        
        return needPosts.map { Post.init(postData: $0, likes: likes, currentUserID: currentUserID) }
    }
    
    func likePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        if (posts.first(where: { $0.id == postID })?.id) != nil {
            likes.append((currentUserID, postID))
            return true
        } else {
            return false
        }
    }
    
    func unlikePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        if (posts.first(where: { $0.id == postID })?.id) != nil {
            likes.removeAll(where: { $0.0 == currentUserID && $0.1 == postID })
            return true
        } else {
            return false
        }
    }
    
    func usersLikedPost(with postID: GenericIdentifier<PostProtocol>) -> [GenericIdentifier<UserProtocol>]? {
        guard let post = posts.first(where: { $0.id == postID }) else { return nil }
        
        return likes.filter { $0.1 == post.id }.map { $0.0 }
    }
}
