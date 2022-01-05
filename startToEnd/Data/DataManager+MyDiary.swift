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
    func createDiary(content: String? = nil,
                     insertDate: Date? = Date(),
                     statusImageUrl: URL,
                     diaryImageUrl: URL,
                     completion: (() -> ())? = nil) {
        mainContext.perform {
            let newDiary = MyDiaryEntity(context: self.mainContext)
            newDiary.content = content
            newDiary.insertDate = insertDate
            
            let statusImageUrlStr = try? String(contentsOf: statusImageUrl)
            newDiary.statusImageUrl = statusImageUrlStr
            
            let diaryImageUrlStr = try? String(contentsOf: diaryImageUrl)
            newDiary.diaryImageUrl = diaryImageUrlStr

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
                print(error.localizedDescription)
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
    func saveEmotionImage(url: URL,
                          completion: (() -> ())? = nil) {
        let diary = MyDiaryEntity(context: self.mainContext)
        let urlString = try? String(contentsOf: url)
        diary.statusImageUrl = urlString
        
        self.saveMainContext()
        completion?()
    }
    
    
    // Save DiaryImages
    func saveDiaryImages(url: URL,
                         completion: (() -> ())? = nil) {
        let diary = MyDiaryEntity(context: self.mainContext)
        let urlString = try? String(contentsOf: url)
        diary.diaryImageUrl = urlString
        
        self.saveMainContext()
        completion?()
    }
}
