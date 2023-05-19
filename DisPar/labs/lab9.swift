//
//  lab9.swift
//  DisPar
//
//  Created by Pfriedrix on 19.05.2023.
//

import Foundation
import Network

func acceptClientConnection(listener: NWListener) {
    listener.newConnectionHandler = { newConnection in
        newConnection.start(queue: DispatchQueue(label: "client"))
        newConnection.receiveMessage { data, _, _, _ in
            if let data = data {
                print("Отримано \(data.count) байтів")
            }
        }
    }
    
    listener.start(queue: DispatchQueue(label: "listener"))
}

func sendToServer(connection: NWConnection, data: Data) {
    connection.send(content: data, completion: .idempotent)
}

func track() {
    let listener = try! NWListener(using: .tcp, on: 8000)
    acceptClientConnection(listener: listener)

    let connection = NWConnection(host: "localhost", port: 8000, using: .tcp)
    connection.start(queue: DispatchQueue(label: "connection"))

    let dataSize = 100_000_000
    let dataToWrite = Data(count: dataSize)
    let startTime = CFAbsoluteTimeGetCurrent()

    sendToServer(connection: connection, data: dataToWrite)

    let endTime = CFAbsoluteTimeGetCurrent()

    let elapsedTime = endTime - startTime

    let bytesPerSecond = Double(dataSize) / elapsedTime
    let megabytesPerSecond = bytesPerSecond / 1_000_000

    print("Швидкість передачі даних sockets: \(megabytesPerSecond) мб/с")
}
