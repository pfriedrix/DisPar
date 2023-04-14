//
//  main.swift
//  DisPar
//
//  Created by Pfriedrix on 12.04.2023.
//

import Foundation
import Dispatch


protocol SocialNetworkable {
    var likes: Int { get set }
    func like()
    func unlike()
}

class SocialNetwork: SocialNetworkable {
    var likes: Int = 0
    
    func like() {
        likes += 1
        printLikes()
    }
    
    func unlike() {
        if likes > 0 {
            likes -= 1
            printLikes()
        }
    }
    
    func printLikes() {
        print("Likes: \(likes)")
    }
}

let socialNetwork = SocialNetwork()

let dispatchGroup = DispatchGroup()


DispatchQueue.concurrentPerform(iterations: 5) { _ in
    socialNetwork.like()
}

DispatchQueue.concurrentPerform(iterations: 5) { _ in
    socialNetwork.unlike()
}


class SocialNetworkSecured: SocialNetwork {
    private let lock = NSLock()
    
    override func like() {
        lock.lock()
        defer { lock.unlock() }
        super.like()
    }
    
    override func unlike() {
        lock.lock()
        defer { lock.unlock() }
        super.unlike()
    }
    
    override func printLikes() {
        print("Likes secured: \(likes)")
    }
}

let socialNetworkSecured = SocialNetworkSecured()

DispatchQueue.concurrentPerform(iterations: 5) { _ in
    socialNetworkSecured.like()
}

DispatchQueue.concurrentPerform(iterations: 5) { _ in
    socialNetworkSecured.unlike()
}

class Listener {
    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(handle), name: Notification.Name("listener"), object: nil)
    }
    
    @objc func handle(notification: Notification) {
        print("---- NEW NOTIFICATION ----")
        if let data = notification.userInfo as? [String: String] {
            print("msg: \(data["msg"] ?? "")")
        }
    }
}

class Sender {
    func send() {
        NotificationCenter.default.post(name: Notification.Name("listener"), object: nil, userInfo: ["msg": "Hello"])
    }
}

let listener = Listener()
let sender = Sender()

sender.send()

class SocialNetworkSemofored: SocialNetwork {
    private let semaphore = DispatchSemaphore(value: 1)
    
    override func like() {
        semaphore.wait()
        defer { semaphore.signal() }
        super.like()
    }
    
    override func unlike() {
        semaphore.wait()
        defer { semaphore.signal() }
        super.unlike()
    }
    
    override func printLikes() {
        print("Likes semofored: \(likes)")
    }
}

let socialNetworkSemafored = SocialNetworkSemofored()

DispatchQueue.concurrentPerform(iterations: 5) { _ in
    socialNetworkSemafored.like()
}

DispatchQueue.concurrentPerform(iterations: 5) { _ in
    socialNetworkSemafored.unlike()
}


dispatchGroup.wait()



signal(SIGINT) { signal in
    print("SIGINT received")
    exit(0)
}

while true {
    print("processing")
    sleep(1)
}


