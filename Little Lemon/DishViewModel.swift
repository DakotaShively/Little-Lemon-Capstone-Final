//
//  DishViewModel.swift
//  Little Lemon
//
//  Created by Dakota Shively on 7/28/23.
//
import SwiftUI
import CoreData

class DishViewModel: ObservableObject {
    
    @Published var dishes: [Dish] = []
    let url: String = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
    
    func fetchDishes() {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["id"]
        
        do {
            let result = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            dishes = result
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    func getMenuData(_ completionHandler: @escaping (_ fetchedData: [MenuItem]?, _ error: Error?) -> Void) {
        if let newURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: newURL) { (data, urlresponse, error) in
                if error != nil{
                    print("error")
                }
                guard let httpResponse = urlresponse as? HTTPURLResponse, httpResponse.statusCode == 200
                else{
                    fatalError("Error fetching endpoint data")
                }
                
                if let safeData = data {
                    if let fullMenu = self.parseJSON(safeData) {
                        completionHandler(fullMenu.menu, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) -> MenuList? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MenuList.self, from: newsData)
            return decodedData
        }
        catch{
            print("error")
            return nil
        }
    }
    
    func fetchItemsFromNetwork() {
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = PersistenceController.shared.container.viewContext
        
        getMenuData { fetchedData, error in
            backgroundContext.perform {
                if let fetchedDishes = fetchedData {
                    for fetchedItem in fetchedDishes {
                        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
                        do {
                            let existingItems = try backgroundContext.fetch(fetchRequest)
                            if existingItems.contains(where: { item in item.title == fetchedItem.title }) {
                            } else {
                                let newItem = Dish(context: backgroundContext)
                                newItem.title = (fetchedItem.title)
                                newItem.price = fetchedItem.price
                                newItem.image = fetchedItem.image
                            }
                        } catch {
                            print("Error fetching items from Core Data: \(error)")
                        }
                    }
                }
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        self.fetchDishes()
                    }
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }
    }
}
