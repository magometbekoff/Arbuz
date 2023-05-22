//
//  ContentView.swift
//  Arbuz
//
//  Created by Magomet Bekov on 23.05.2023.
//

import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    var selected: Bool = false
    var unit: Unit
    var quantity: Int = 1
    var volume: Double = 0.0
    var weight: Double = 0.0
    var image: UIImage?
    var showQuantity: String
    var isSelectable: Bool = true
}

enum Unit {
    case quantity
    case volume
    case weight
}

struct ContentView: View {
    @State private var products: [Product] = [
        Product(name: "СМЕТАНА", unit: .quantity, image: UIImage(named: "smetana"), showQuantity: "300г"),
        Product(name: "МАЛИНА", unit: .quantity, image: UIImage(named: "malina"), showQuantity: "125г"),
        Product(name: "КУКУРУЗА", unit: .quantity, image: UIImage(named: "kukuruza"), showQuantity: "212мл"),
        Product(name: "ХЛЕБ", unit: .quantity, image: UIImage(named: "hleb"), showQuantity: "320г"),
        Product(name: "ПОМИДОРЫ", unit: .quantity, image: UIImage(named: "pomidor"), showQuantity: "1кг"),
        Product(name: "ОГУРЦЫ", unit: .quantity, image: UIImage(named: "ogurec"), showQuantity: "1кг")
    ]
    
    @State private var selectedProducts: [Product] = []
    @State private var buttonScale: CGFloat = 1.0
    @State private var isShowingNotification = false
    @State private var isShowingError = false
    @State private var isOrderFormPresented = false
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        TabView {
            // MARK: Первое меню - список продуктов
            VStack {
                ScrollView {
                    Text("ПРОДУКТЫ")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        Section {
                            ForEach(products) { product in
                                VStack(spacing: 10) {
                                    if let image = product.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                    }
                                    
                                    Text(product.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 1) {
                                            switch product.unit {
                                            case .quantity:
                                                Stepper(value: $products[productIndex(product)].quantity, in: 1...10) {
                                                    Text(" \(products[productIndex(product)].quantity)")
                                                        .font(.callout)
                                                }
                                                .padding(.vertical)
                                            case .volume:
                                                Text("Объем: \(String(format: "%.1f", product.volume))")
                                            case .weight:
                                                Text("Вес: \(String(format: "%.1f", product.weight))")
                                            }
                                            
                                            Text(product.showQuantity)
                                        }
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        toggleProductSelection(product: product)
                                    }) {
                                        Label(product.selected ? "Выбрано" : "Выбрать", systemImage: product.selected ? "checkmark.circle.fill" : "cart.badge.plus")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .padding(.vertical)
                                            .padding(.horizontal, 5)
                                            .background(product.selected ? Color.green : Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.1))
                                )
                                .padding(.horizontal)
                            }
                        }
                        
                    }
                    
                }
                //MARK: Добавляет продукты в корзину
                Button(action: {
                    addSelectedProducts()
                }) {
                    Text("Добавить в корзину")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    
                }
                .padding()
                .scaleEffect(buttonScale)
                .onTapGesture {
                    withAnimation {
                        buttonScale = 0.4
                    }
                }
                //MARK: При добавлении продуктов в корзину "всплывает" соответствующее оповещение
                .alert(isPresented: $isShowingNotification) {
                    Alert(title: Text("Выбранные товары добавлены в корзину"), dismissButton: .default(Text("OK")))
                }
            }
            .tabItem {
                Label("Продукты", systemImage: "bag")
            }
            
            // MARK: Второе меню - список выбранных продуктов
            VStack {
                ScrollView {
                    Text("КОРЗИНА")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 5)], spacing: 5) {
                        
                        Section {
                            ForEach(selectedProducts) { product in
                                VStack{
                                    if let image = product.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                    }
                                    
                                    Text(product.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(product.showQuantity)
                                        .font(.subheadline)
                                    Text("Количество: \(product.quantity)")
                                    
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.1))
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                
                Button(action: {isOrderFormPresented.toggle()
                }) {
                    Text("Оформить заказ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            //MARK: Открывает модальный контроллер для завершения заказа
            .sheet(isPresented: $isOrderFormPresented) {
                OrderFormView()
            }
            .tabItem {
                Label("Корзина", systemImage: "cart")
            }
        }
    }
    
    //MARK: Переключение выбранных продуктов
    func toggleProductSelection(product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            if products[index].isSelectable {
                products[index].selected.toggle()
            }
        }
    }
    
    //MARK: Добавление выбранных продуктов в корзину
    func addSelectedProducts() {
        let selected = products.filter { $0.selected }
        selectedProducts.append(contentsOf: selected)
        isShowingNotification = true
        
    }
    
    //MARK: Поиск индекса продукта по id
    func productIndex(_ product: Product) -> Int {
        products.firstIndex(where: { $0.id == product.id }) ?? 0
    }
}
