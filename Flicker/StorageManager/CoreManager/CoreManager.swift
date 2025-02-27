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
    var favoritePost: [PostItem] = []
    
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
            notifyUpdate()
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
                parent.id = UUID().uuidString
                parent.date = Date()
                post.parent = parent
            }
            saveContext()
            fetchPosts()
            }catch {
                print(error.localizedDescription)
        }
    }
    
    func getFavoritePosts(){
        let bool = NSNumber (booleanLiteral: true)
        let req = PostItem.fetchRequest()
        req.predicate = NSPredicate(format: "isFavorite = %@", bool as CVarArg)
        do {
            let favoritePosts = try persistentContainer.viewContext.fetch(req)
            self.favoritePost = favoritePosts
        }
        catch {
            print (error.localizedDescription)
        }
    }
    
    func deletePostDataWithPhotos() {
        let fetchRequest: NSFetchRequest<PostData> = PostData.fetchRequest()
        
        do {
            let allPostsData = try persistentContainer.viewContext.fetch(fetchRequest)
            
            for postData in allPostsData {
                // Проверяем, есть ли в этом PostData хотя бы один PostItem с фото
                if let postItems = postData.items as? Set<PostItem>,
                   postItems.contains(where: { $0.photos != nil }) {
                    persistentContainer.viewContext.delete(postData)
                }
            }
            
            print("Удалены все PostData, содержащие посты с фото")
            saveContext()
            fetchPosts()
        } catch {
            print("Ошибка при удалении PostData: \(error.localizedDescription)")
        }
    }
    
    private func notifyUpdate() {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .dataDidUpdate, object: nil)
            }
        }

}
