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
                     statusImage: Data? = nil,
                     image: Data? = nil,
                     completion: (() -> ())? = nil) {
        mainContext.perform {
            let newDiary = MyDiaryEntity(context: self.mainContext)
            newDiary.content = content
            newDiary.insertDate = insertDate
            newDiary.statusImage = statusImage
            newDiary.image = image
            
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
                     insertDate: Date?,
                     statusImage: Data? = nil,
                     image: Data? = nil,
                     completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.content = content
            entity.insertDate = insertDate
            entity.statusImage = statusImage
            entity.image = image
            
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
    
    
    /// 이미지를 저장합니다.
    func saveImageData(imageData: Data,
                       completion: (() -> ())? = nil) {
        mainContext.perform {
            let newData = PhotoGalleryEntity(context: self.mainContext)
            newData.imageData = imageData
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    /// 이미지를 Fetch합니다.
    func fetchImageData() {
        mainContext.performAndWait {
            let request: NSFetchRequest<PhotoGalleryEntity> = PhotoGalleryEntity.fetchRequest()
            
            do {
                photoList = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    /// 이미지를 업데이트 합니다.
    func updateImageData(entity: PhotoGalleryEntity,
                         imageData: Data,
                         completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.imageData = imageData
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    /// 이미지를 삭제합니다.
    func deleteImageData(entity: PhotoGalleryEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}
