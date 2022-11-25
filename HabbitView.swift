//
//  HabbitView.swift
//  Habit Track
//
//  Created by Furkan Eken on 24.11.2022.
//

import SwiftUI

struct HabbitView: View {
    @State var activity : Activity
    @StateObject var activities : Activities
    @State var newActivity = Activity()
    
    var body: some View {
        VStack {
            List {
                Text(newActivity.title)
                
                Text("Count: \(newActivity.count)")
                
                Text(newActivity.description)
            }
            .onAppear(){
                newActivity = activity
            }
            HStack {
                Spacer()
                
                Button("+") {
                    newActivity.count += 1
                    changeCount()
                }
                
                Spacer()
                
                Button("-") {
                    if newActivity.count != 0 {
                        newActivity.count -= 1
                        changeCount()
                    }
                }
                Spacer()
            }
        }
    }
    func changeCount() {
        if let Index = activities.activitylist.firstIndex(of: activity) {
            activities.activitylist[Index] = newActivity
            activity = newActivity
        } else {
            fatalError("sıçtın")
        }
    }
}

