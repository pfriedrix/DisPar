//
//  lab8.swift
//  DisPar
//
//  Created by Pfriedrix on 18.05.2023.
//

import Foundation

func performPipeCommunication() {
    let pipe = Pipe()
    let writer = pipe.fileHandleForWriting

    let startTime = CFAbsoluteTimeGetCurrent()
    let dataSize = 65_400
    let data = Data(count: dataSize)
    writer.write(data)
    
    let endTime = CFAbsoluteTimeGetCurrent()

    writer.closeFile()
    
    let elapsedTime = endTime - startTime

    let bytesPerSecond = Double(dataSize) / elapsedTime
    let megaBytesPerSecond = bytesPerSecond / 1_000_000

    print("Швидкість передачі даних pipes: \(megaBytesPerSecond) мб/с")
}

