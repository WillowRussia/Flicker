//
//  CoreManager.swift
//  Flicker
//
//  Created by Илья Востров on 21.12.2024.
//

import Foundation
import CoreData

class CoreManager {
    
    static let shared = CoreManager()
    var allPost: [PostData] = []
    
    private init(){
        self.fetchPosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer (name: "Flicker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try
                context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPosts() { // Функция для загрузки данных
        let request = PostData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor (key: "date", ascending: false)] // Сортировка по дате
        
        do {
            let posts = try persistentContainer.viewContext.fetch(request)
            self.allPost = posts
        } catch {
            print(error.localizedDescription)
        }
    }
    func savePost(post: PostItem){
        // Мы ищем папку постов сегоднешнего дня
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval (-1)
        
        let request = PostData.fetchRequest()
        request.predicate = NSPredicate (format: "date >= %@ AND date <= %@", startOfDay as CVarArg, endOfDay! as CVarArg)
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if !result.isEmpty, let parent = result.first {
                // Если нашелся, то добавляем
                post.parent = parent
            } else {
                // Если нет, то создаем новый
                let parent = PostData(context: persistentContainer.viewContext)
                parent.id = UUID() .uuidString
                parent.date = Date()
                post.parent = parent
            }
            saveContext()
            fetchPosts()
            }catch {
                print(error.localizedDescription)
        }
    }
}
