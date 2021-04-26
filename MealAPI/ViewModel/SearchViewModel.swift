//
//  SearchViewModel.swift
//  MealAPI
//
//  Created by Darell Legoferdanu on 23/04/21.
//

import SwiftUI
import SwiftyJSON

class SearchViewModel: ObservableObject {
  
  @Published var search = ""
  @Published var meal: [Meal] = []
  @Published var mealFiltered: [Meal] = []
  
  func filterMeal(){
    withAnimation(.linear){
      self.mealFiltered = self.meal.filter{
        return $0.title.lowercased().contains(self.search.lowercased())
      }
    }
  }
  
  init() {
    let url = ""
    
    let sessions = URLSession(configuration: .default)
    
    sessions.dataTask(with: URL(string: url)!){ (data, _, error) in
      //jika ada error
      if error != nil{
        print((error?.localizedDescription)!)
        return
      }
      
      let json = try! JSON(data: data!)
      let items = json["categories"].array!
      
      for i in items{
        let title = i["strCategory"].stringValue
        let description = i["strCategoryDescription"].stringValue
        let image = i["strCategoryThumb"].stringValue
        
        DispatchQueue.main.async {
          self.meal.append(Meal(title: title, image: image, description: description))
        }
      }
    }.resume()
  }
}
