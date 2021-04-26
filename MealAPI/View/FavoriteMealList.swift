//
//  FavoriteMealList.swift
//  MealAPI
//
//  Created by Darell Legoferdanu on 21/04/21.
//


import SwiftUI
import SDWebImageSwiftUI

struct FavoriteMealList: View {
  
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(entity: FavoriteMeal.entity(), sortDescriptors: []) var favoriteMeal: FetchedResults<FavoriteMeal>
  
  var body: some View {
    NavigationView{
      VStack{
        List{
          ForEach(favoriteMeal, id: \.self){ item in
            NavigationLink(destination: FavoriteMealDetail(data: item)){
              HStack{
                //jika fotonya ada
                if item.image != ""{
                  WebImage(url: URL(string: item.wrappedImage)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 170)
                    .background(Image("loader")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 60, height: 30))
                    .cornerRadius(10)
                }
                else{
                  Image("loader")
                    .resizable()
                    .frame(width: 120, height: 170)
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 10){
                  Text(item.wrappedTitle).fontWeight(.bold)
                  
                  Text(item.wrappedDesc).font(.caption)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                }
              }
            }
          }.onDelete(perform: deleteMealList)
          
        }
      }
      .navigationBarTitle(Text("Favorite Meal"))
      
    }.navigationViewStyle(StackNavigationViewStyle())
  }
  
  private func deleteMealList(at offsest: IndexSet){
    for index in offsest{
      let favorite = favoriteMeal[index]
      moc.delete(favorite)
      
      do{
        try moc.save()
      } catch{
        print(error)
      }
    }
  }
}


struct FavoriteMealList_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteMealList()
  }
}
