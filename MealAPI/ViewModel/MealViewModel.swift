//
//  MealViewModel.swift
//  MealAPI
//
//  Created by Darell Legoferdanu on 19/04/21.
//


import Foundation
import Combine
import SwiftyJSON

class MealViewModel: ObservableObject {
  @Published var data = [Meal]()
  
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
          self.data.append(Meal(title: title, image: image, description: description))
        }
      }
    }.resume()
  }
}
