//
//  ContentView.swift
//  iExpense
//
//  Created by Nestor Trillo on 3/22/21.
//



//  LIBRABRIES
import SwiftUI

struct ExpenseItem: Identifiable, Codable {
	var id = UUID()
	let name = String
	let type = String
	let amount = Int
}

class Expenses: ObservableObject {
	@Published var items: [ExpenseItem]{
		didSet {
			let encoder = JSONEncoder()
			if let encoded = try? encoder.encode(items) {
				UserDefaults.standard.set(encoded, forKey: "items")
			}
		}
	}
	
	init() {
		if let items = UserDefaults.standard.data(forKey: "items"){
			let decoder = JSONDecoder()
			if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
				self.items = decoded
				return
			}
		}
		
		self.items = []
	}
}

struct ContentView: View {
	// VARS
	@ObservedObject var expenses = Expenses()
	@State private var showingAddExpense = false

	var body: some View {
		NavigationView{
				List{
					ForEach(expenses.items){ item in
						HStack{
							VStack(alignment: .leading){
								Text(item.name)
									.font(.headline)
								Text(item.type)
							}
							
							Spacer()
							Text("$\(item.amount)")
						}
					}
					.onDelete(perform: removeItems)
				}
				.navigationBarTitle("iExpense")
				.navigationBarItems(trailing:
										Button(action: {
											self.showingAddExpense = true
										}){
											Image(systemName: "plus")
										}
				)
				.sheet(isPresented: $showingAddExpense) {
					AddView(expenses: self.expenses)
				}
		}
	}
	
	//  FUNCTIONS
	func removeItems(at offsets: IndexSet){
		expenses.items.remove(atOffsets: offsets)
	}
}


//  PREVIEW
struct ContentView_Preview: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
