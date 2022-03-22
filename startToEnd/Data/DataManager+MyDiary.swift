//
//  DataManager+MyDiary.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/11.
//

import Foundation
import CoreData
import UIKit

extension DataManager {
    
    // CreateMyDiary
    func createMyDiary(content: String? = nil,
                       insertDate: Date? = Date(),
                       statusImageData: Data?,
                       diaryImageData: Data?,
                       completion: (() -> ())? = nil) {
        mainContext.perform {
            let newDiary = MyDiaryEntity(context: self.mainContext)
            newDiary.content = content
            newDiary.insertDate = insertDate
            
            if let statusImageData = statusImageData {
                newDiary.statusImageData = statusImageData
            }
            
            if let diaryImageData = diaryImageData {
                newDiary.diaryImageData = diaryImageData
            }
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    // FetchMyDiary
    func fetchDiary() {
        mainContext.performAndWait {
            let request: NSFetchRequest<MyDiaryEntity> = MyDiaryEntity.fetchRequest()
            let sortByDateAsc = NSSortDescriptor(key: "insertDate", ascending: false)
            request.sortDescriptors = [sortByDateAsc]
            
            do {
                myDiaryList = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription, "3")
            }
        }
    }
    
    
    // UpdateDiary
    func updateDiary(entity: MyDiaryEntity,
                     content: String?,
                     completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.content = content
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    // DeleteDiary
    func deleteDiary(entity: MyDiaryEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
    
    
    // Save EmotionImage
    func saveEmoImage(imageData: Data?, completion: (() -> ())? = nil) {
        let diary = MyDiaryEntity(context: self.mainContext)
        diary.statusImageData = imageData
        
        self.saveMainContext()
        completion?()
    }
    
    
    // Save DiaryImages
    func saveDiaryImage(data: Data?, completion: (() -> ())? = nil) {
        let diary = MyDiaryEntity(context: self.mainContext)
        diary.diaryImageData = data
        
        self.saveMainContext()
        completion?()
    }
}
