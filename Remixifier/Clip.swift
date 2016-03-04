//
//  Clip.swift
//  Remixifier
//

import Foundation
class Clip: NSObject, NSCoding {
    static var key: String = "Clips"
    static var schema: String = "recordClips2"
//    static var PathWay = NSURL()
    var objective: String
    var audioURL: NSURL
    var createdAt: NSDate
    
    // use this init for creating a new Task
    init(obj: String,audio_url: NSURL) {
        objective = obj
        createdAt = NSDate()
        audioURL = audio_url
    }
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objective, forKey: "objective")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
        aCoder.encodeObject(audioURL,forKey: "audioURL")
    }
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        objective = aDecoder.decodeObjectForKey("objective") as! String
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        audioURL = aDecoder.decodeObjectForKey("audioURL") as! NSURL
        super.init()
    }
    // MARK: - Queries
    static func all() -> [Clip] {
        var clips = [Clip]()
        let path = Database.dataFilePath("recordClips2")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                clips = unarchiver.decodeObjectForKey(Clip.key) as! [Clip]
                unarchiver.finishDecoding()
            }
        }
        return clips
    }
    func save() {
        var clipsFromStorage = Clip.all()
        var exists = false
        for var i = 0; i < clipsFromStorage.count; ++i {
            if clipsFromStorage[i].createdAt == self.createdAt {
                clipsFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            clipsFromStorage.append(self)
        }
        Database.save(clipsFromStorage, toSchema: Clip.schema, forKey: Clip.key)
    }
    
    func deleteRow() {
        var clipsFromStorage = Clip.all()
        print(self.createdAt)
        for var i = 0; i < clipsFromStorage.count; ++i {
            print(clipsFromStorage[i], clipsFromStorage[i].createdAt)
            if clipsFromStorage[i].createdAt == self.createdAt {
                print(self, self.createdAt, clipsFromStorage[i], "OH NO I'm GETTING DELETEDDDD")
                clipsFromStorage.removeAtIndex(i)
            }
        }
        Database.save(clipsFromStorage, toSchema: Clip.schema, forKey: Clip.key)
    }
    
    
    func destroy() {
        var clipsFromStorage = Clip.all()
        for var i = 0; i < clipsFromStorage.count; ++i {
            if clipsFromStorage[i].createdAt == self.createdAt {
                clipsFromStorage.removeAtIndex(i)
            }
        }
        Database.save(clipsFromStorage, toSchema: Clip.schema, forKey: Clip.key)
    }
}