//
//  ContentView.swift
//  labaaa5
//
//  Created by IPZ-31 on 29.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var selectedCategory = "Все"
    @State private var showAddRecipeView = false
    @State private var showSettingsView = false // для відкриття налаштувань
    
    @AppStorage("backgroundColor") private var backgroundColor = "white"
    @AppStorage("textColor") private var textColor = "black"
    
    let categories = ["Все", "Супи", "Салати", "Десерти"]
    
    var filteredRecipes: [Recipe] {
        selectedCategory == "Все" ? viewModel.recipes : viewModel.filterRecipes(by: selectedCategory)
    }
    
    // Функція для отримання кольору з рядка
    private func getColor(from colorName: String) -> Color {
        switch colorName {
        case "black":
            return .black
        case "blue":
            return .brown
        case "green":
            return .green
        case "red":
            return .red
        case "white":
            return .white
        default:
            return .white
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Фільтрація рецептів
                Picker("Категорія", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Список рецептів
                List {
                    ForEach(filteredRecipes) { recipe in
                        Text(recipe.name)
                            .onTapGesture {
                                // Редагування рецепта
                                showAddRecipeView = true
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteRecipe(id: recipe.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                
                // Кнопка додавання рецепту
                Button(action: {
                    showAddRecipeView = true
                }) {
                    Text("Додати рецепт")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .background(getColor(from: backgroundColor)) // Застосовуємо колір фону
            .foregroundColor(getColor(from: textColor)) // Застосовуємо колір тексту
            .navigationBarTitle("Улюблені рецепти")
            .navigationBarItems(trailing: Button(action: {
                showSettingsView = true // відкриваємо налаштування
            }) {
                Image(systemName: "gearshape.fill") // іконка налаштувань
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $showAddRecipeView) {
                AddRecipeView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView() // Відкриваємо налаштування
            }
        }
    }
}

#Preview {
    ContentView()
}
