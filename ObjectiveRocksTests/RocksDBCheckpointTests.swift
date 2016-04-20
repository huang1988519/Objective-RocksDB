//
//  RocksDBCheckpointTests.swift
//  ObjectiveRocks
//
//  Created by Iska on 11/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

import XCTest

class RocksDBCheckpointTests : RocksDBTests {

	func testSwift_Checkpoint() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		rocks.setData(Data("value 1"), forKey: Data("key 1"))

		let checkpoint = RocksDBCheckpoint(database: rocks)

		do {
			try checkpoint.createCheckpointAtPath(checkpointPath1)
		} catch _ {
		}

		rocks.setData(Data("value 2"), forKey: Data("key 2"))

		do {
			try checkpoint.createCheckpointAtPath(checkpointPath2)
		} catch _ {
		}

		rocks.close()

		rocks = RocksDB(path: self.checkpointPath1, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		XCTAssertEqual(rocks.dataForKey(Data("key 1")), Data("value 1"))
		XCTAssertNil(rocks.dataForKey(Data("key 2")))

		rocks.close()

		rocks = RocksDB(path: self.checkpointPath2, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		XCTAssertEqual(rocks.dataForKey(Data("key 1")), Data("value 1"))
		XCTAssertEqual(rocks.dataForKey(Data("key 2")), Data("value 2"))
	}
}
