//
//  RocksDBBackupTests.swift
//  ObjectiveRocks
//
//  Created by Iska on 17/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

import XCTest

class RocksDBBackupTests : RocksDBTests {

	func testSwift_Backup_Create() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		rocks.setData(Data("value 3"), forKey: Data("key 3"))

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.close()

		let exists = NSFileManager.defaultManager().fileExistsAtPath(self.backupPath)
		XCTAssertTrue(exists)
	}

	func testSwift_Backup_BackupInfo() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		rocks.setData(Data("value 3"), forKey: Data("key 3"))

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.close()

		let backupInfo = backupEngine.backupInfo()

		XCTAssertNotNil(backupInfo)
		XCTAssertEqual(backupInfo.count, 1);

		let info = backupInfo[0] as! RocksDBBackupInfo

		XCTAssertEqual(info.backupId, 1 as UInt32)
	}

	func testSwift_Backup_BackupInfo_Multiple() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 3"), forKey: Data("key 3"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.close()

		let backupInfo = backupEngine.backupInfo()

		XCTAssertNotNil(backupInfo)
		XCTAssertEqual(backupInfo.count, 3);

		XCTAssertEqual(backupInfo[0].backupId, 1 as UInt32)
		XCTAssertEqual(backupInfo[1].backupId, 2 as UInt32)
		XCTAssertEqual(backupInfo[2].backupId, 3 as UInt32)
	}

	func testSwift_Backup_PurgeBackups() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 3"), forKey: Data("key 3"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.close()

		do {
			try backupEngine.purgeOldBackupsKeepingLast(2)
		} catch _ {
		}

		let backupInfo = backupEngine.backupInfo()

		XCTAssertNotNil(backupInfo)
		XCTAssertEqual(backupInfo.count, 2);

		XCTAssertEqual(backupInfo[0].backupId, 2 as UInt32)
		XCTAssertEqual(backupInfo[1].backupId, 3 as UInt32)
	}

	func testSwift_Backup_DeleteBackup() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 3"), forKey: Data("key 3"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.close()

		do {
			try backupEngine.deleteBackupWithId(2)
		} catch _ {
		}

		let backupInfo = backupEngine.backupInfo()

		XCTAssertNotNil(backupInfo)
		XCTAssertEqual(backupInfo.count, 2);

		XCTAssertEqual(backupInfo[0].backupId, 1 as UInt32)
		XCTAssertEqual(backupInfo[1].backupId, 3 as UInt32)
	}

	func testSwift_Backup_Restore() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		rocks.setData(Data("value 3"), forKey: Data("key 3"))

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 10"), forKey: Data("key 1"))
		rocks.setData(Data("value 20"), forKey: Data("key 2"))
		rocks.setData(Data("value 30"), forKey: Data("key 3"))

		rocks.close()

		do {
			try backupEngine.restoreBackupToDestinationPath(self.restorePath)
		} catch _ {
		}

		let backupRocks = RocksDB(path: restorePath)

		XCTAssertEqual(backupRocks.dataForKey(Data("key 1")), Data("value 1"))
		XCTAssertEqual(backupRocks.dataForKey(Data("key 2")), Data("value 2"))
		XCTAssertEqual(backupRocks.dataForKey(Data("key 3")), Data("value 3"))

		backupRocks.close()
	}

	func testSwift_Backup_Restore_Specific() {
		rocks = RocksDB(path: self.path, andDBOptions: { (options) -> Void in
			options.createIfMissing = true
		})

		let backupEngine = RocksDBBackupEngine(path: self.backupPath)

		rocks.setData(Data("value 1"), forKey: Data("key 1"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 2"), forKey: Data("key 2"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.setData(Data("value 3"), forKey: Data("key 3"))
		do {
			try backupEngine.createBackupForDatabase(rocks)
		} catch _ {
		}

		rocks.close()

		do {
			try backupEngine.restoreBackupWithId(1, toDestinationPath: self.restorePath)
		} catch _ {
		}

		var backupRocks = RocksDB(path: restorePath)

		XCTAssertEqual(backupRocks.dataForKey(Data("key 1")), Data("value 1"))
		XCTAssertNil(backupRocks.dataForKey(Data("key 2")))
		XCTAssertNil(backupRocks.dataForKey(Data("key 3")))

		backupRocks.close()

		do {
			try backupEngine.restoreBackupWithId(2, toDestinationPath: self.restorePath)
		} catch _ {
		}

		backupRocks = RocksDB(path: restorePath)

		XCTAssertEqual(backupRocks.dataForKey(Data("key 1")), Data("value 1"))
		XCTAssertEqual(backupRocks.dataForKey(Data("key 2")), Data("value 2"))
		XCTAssertNil(backupRocks.dataForKey(Data("key 3")))

		backupRocks.close()
	}
}
