//
//  ContentView.swift
//  Devote
//
//  Created by MarthaBakManis on 18/01/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
  // MARK: - PROPERTY
  
  @State var task: String = ""
  
  private var isButtonDisabled: Bool {
    task.isEmpty
  }
  
  // FETCHING DATA
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default
  )
  private var items: FetchedResults<Item>
  
  // MARK: - FUNCTION
  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
      newItem.task = task
      newItem.completion = false
      newItem.id = UUID()
      
      do {
        if !task.isEmpty {
          try viewContext.save()
        }
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      task = ""
      hideKeyboard()
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  // MARK: - BODY
  var body: some View {
    NavigationView {
      ZStack{
        VStack{
          VStack(spacing: 16){
            TextField("Add a task", text: $task)
              .padding()
              .background(
                Color(UIColor.systemGray6)
              )
              .clipShape(RoundedRectangle(cornerRadius:10))
            
            Button(action: {
              addItem()
            }, label: {
              Spacer()
              Text("SAVE")
              Spacer()
            })
            .disabled(isButtonDisabled)
            .padding()
            .font(.headline)
            .foregroundStyle(.white)
            .background(isButtonDisabled ? Color.gray : Color.pink)
            .clipShape(RoundedRectangle(cornerRadius: 10))
          }
          .padding()
          
          List {
            ForEach(items) { item in
              NavigationLink {
                VStack(alignment: .leading){
                  Text(item.task ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                  
                  Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                }
              } label: {
                VStack(alignment: .leading, content: {
                  Text(item.task ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                  
                  Text(item.timestamp!, formatter: itemFormatter)
                })
              }
            }
            .onDelete(perform: deleteItems)
          }
          .listStyle(InsetGroupedListStyle())
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
          .padding(.vertical, 0)
          .frame(maxWidth: 640)
        } //: VSTACK
      } //: ZSTACK
      .onAppear(){
        UITableView.appearance().backgroundColor = UIColor.clear
      }
      .navigationTitle("Daily Tasks")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          EditButton()
        }
      } //: TOOLBAR
      .background(
        BackgroundImageView()
      )
      .background(
        backgroundGradient.ignoresSafeArea(.all)
      )
    } //: NAVIGATION
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
