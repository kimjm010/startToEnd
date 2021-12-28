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
                     insertDate: Date = Date(),
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
                     content: String,
                     insertDate: Date,
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
    
    // saveImage
    func saveImages(imageData: Data,
                    completion: (() -> ())? = nil) {
        let image: UIImage? = nil
        
        mainContext.perform {
            let photoObject = NSEntityDescription.insertNewObject(forEntityName: "PhotoGallery", into: self.mainContext) as! PhotoGalleryEntity
            photoObject.image = image?.jpegData(compressionQuality: 1) as Data?
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    func retrieveImagesData() -> [PhotoGalleryEntity] {
        var photos = [PhotoGalleryEntity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<PhotoGalleryEntity> = PhotoGalleryEntity.fetchRequest()
            
            do {
                photos = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return photos
    }
}
