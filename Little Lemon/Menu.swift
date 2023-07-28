import Foundation
import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Dish.entity(), sortDescriptors: []) var dishes: FetchedResults<Dish>
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State var selectedCategory: String = ""
    @State var searchText: String = ""
    @StateObject var viewModel = DishViewModel()
    
    func getMenuData() {
        let serverURLString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        guard let url = URL(string: serverURLString) else {
            print("Invalid server URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let menuList = try JSONDecoder().decode(MenuList.self, from: data)
                let context = PersistenceController.shared.container.viewContext
                
                // Clear the database before saving new data
                PersistenceController.shared.clear()
                
                for menuItem in menuList.menu {
                    let dish = Dish(context: context)
                    dish.title = menuItem.title
                    dish.image = menuItem.image
                    dish.price = menuItem.price
                }
                
                try context.save()
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()}
    
    var body: some View {
        VStack {
            Header()
            HeroSection(searchText: $searchText, showSearchField: true)
            MenuBreakdown(selectedCategory: $selectedCategory)
            List(dishes) { dish in
                HStack {
                    Text("\(dish.title ?? "Title")")
                    Text("$\(dish.price ?? "Price")")
                    AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            if selectedCategory.isEmpty {
                return NSPredicate(value: true)
            }
            else {
                return NSPredicate(format: "category CONTAINS[cd] %@", selectedCategory)
            }
        }
        else {
            let predicate1 = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            let predicate2 = NSPredicate(format: "category CONTAINS[cd] %@", selectedCategory)
            return NSCompoundPredicate(type: .or, subpredicates: [predicate1, predicate2])
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        let descriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        return [descriptor]
    }
}



struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
