//
//  ContentView.swift
//  Habit Track
//
//  Created by Furkan Eken on 24.11.2022.
//

import SwiftUI

struct Activity: Codable, Identifiable, Equatable {
    var id = UUID()
    var title = ""
    var count = 0
    var description = ""
}

class Activities: ObservableObject {
    @Published var activitylist = [Activity()]
}

struct ContentView: View {
    @State private var showingSheet = false
    @State private var started = true
    
    @StateObject private var activities = Activities()
    @State private var newActivity = Activity()
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var body: some View {
        NavigationView {
                List {
                        Section {
                            ForEach(activities.activitylist, id: \.id) { habbit in
                                NavigationLink {
                                    HabbitView(activity: habbit, activities: activities)
                                } label: {
                                    Text(habbit.title)
                                }
                            }.onDelete(perform: removeRows)
                        }
                }
                .onAppear(perform: start)
                .frame(minHeight: minRowHeight * 2)
                .navigationTitle("Habit Tracker")
                .toolbar {
                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    VStack {
                        HStack {
                            Spacer()
                            Button("ADD") {
                                addHabbit()
                                showingSheet.toggle()
                            }
                        }
                        .padding([.top, .horizontal], 20)
                        
                        Section {
                            TextField("Enter Title", text:$newActivity.title)
                            TextField("Enter Description", text:$newActivity.description)
                        }
                        .padding([.horizontal, .top])
                        
                        Spacer()
                    }
                }.onDisappear(){
                    code()
                }
        }
    }
    func addHabbit() {
        activities.activitylist.insert(newActivity, at: 0)
        newActivity = Activity()
        
        code()
    }
    
    func start() {
        if started {
            decode()
        }
        started = false
    }
    
    func removeRows(at offsets: IndexSet) {
        activities.activitylist.remove(atOffsets: offsets)
        
        code()
        
    }
    
    func code() {
        if let encoded = try? encoder.encode(activities.activitylist) {
            defaults.set(encoded, forKey: "SavedActivities")
        }
    }
    
    func decode() {
        if let savedActivities = defaults.object(forKey: "SavedActivities") as? Data {
            if let loadedActivities = try? decoder.decode([Activity].self, from: savedActivities){
                activities.activitylist = loadedActivities
            }
        } else {
            activities.activitylist.remove(at: 0)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
