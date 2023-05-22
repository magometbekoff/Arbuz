//
//  OrderFormView.swift
//  Arbuz
//
//  Created by Magomet Bekov on 23.05.2023.
//

import SwiftUI
import iPhoneNumberField

struct OrderFormView: View {
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var selectedDay: String = ""
    @State private var selectedDeliveryPeriod: String = ""
    @State private var subscriptionTerm: Int = 1
    @State private var subscriptionStart = Date()
    @State var isEditing: Bool = false
    @Environment(\.presentationMode) private var presentationMode
    
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    let deliveryPeriods = ["Утро 9:00-12:30", "День 12:30-17:00", "Вечер 17:00-23:00"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Контактные данные")) {
                    iPhoneNumberField("Номер телефона", text: $phoneNumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .foregroundColor(.systemBlue)
                        .clearButtonMode(.whileEditing)
                        .shadow(color: isEditing ? .accentColor : .white, radius: 5)
                    TextField("Адрес", text: $address)
                }
                
                Section(header: Text("Доставка")) {
                    DatePicker("Дата первой доставки", selection: $subscriptionStart, displayedComponents: .date)
                    
                    Picker("День недели", selection: $selectedDay) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                        }
                    }
                    
                    Picker("Период доставки", selection: $selectedDeliveryPeriod) {
                        ForEach(deliveryPeriods, id: \.self) { period in
                            Text(period)
                        }
                    }
                }
                
                Section(header: Text("Подписка")) {
                    Stepper(value: $subscriptionTerm, in: 1...12) {
                        Text("Срок подписки: \(subscriptionTerm) месяц(ев)")
                    }
                }
            }
            .navigationTitle("Оформление заказа")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        // MARK: Обработка сохранения данных заказа
                        // ...
                        
                        withAnimation {  // MARK: Закрытие модального представления
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}
