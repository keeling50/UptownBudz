//
//  CalendarViewModel.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 4/14/24.
//

import SwiftUI
import Foundation
import Combine

struct CalendarEvent: Identifiable {
    var date: Date
    var title: String
    var id = UUID()
}


class CalendarViewModel: ObservableObject {
    @Published var events: [CalendarEvent] = [CalendarEvent(date: Date(), title: "Team Meeting", id: UUID())]
    @Published var month: Date = Date()
        @Published var selectedDate: Date?
        //@Published var eventsForSelectedDate: [CalendarEvent] = []
    
    init() {
            loadPreviewData()
        }

    private func loadPreviewData() {
        let today = Date()
        let calendar = Calendar.current

        // Define events with clear and distinct titles and times
        let eventsData = [
            ("Team Meeting", 0),  // Today
            ("Project Deadline", 1),  // Tomorrow
            ("Anniversary", 7)  // Next week
        ]

        events = eventsData.map { (title, dayOffset) in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            return CalendarEvent(date: date, title: title)
        }
    }

    
    let calendar = Calendar.current

    // Helper function to get the first day of the month
    func firstDayOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }

    // Helper function to get the total number of days in the month
    func numberOfDaysInMonth(for date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    // Function to fetch events for a specific day
        func events(for day: Int, month: Date) -> [CalendarEvent] {
            let dateComponents = DateComponents(year: calendar.component(.year, from: month),
                                                month: calendar.component(.month, from: month),
                                                day: day)
            guard let specificDay = calendar.date(from: dateComponents) else { return [] }

            return events.filter { event in
                calendar.isDate(event.date, inSameDayAs: specificDay)
            }
        }
    
    func date(forDay day: Int, month: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: month)
        components.day = day
        return Calendar.current.date(from: components) ?? month // Fallback to month if computation fails
    }

    // Helper function to find out what day of the week the first of the month is
    func dayOfWeek(for date: Date) -> Int {
        let day = calendar.component(.weekday, from: date) - 1 // Calendar component weekday is 1 based starting at Sunday
        return day == 0 ? 6 : day - 1 // Adjust to make Monday the first day of the week
    }

    // Function to check if there is an event on a particular day
    func eventIndicator(for day: Int, month: Date) -> Bool {
        let startOfMonth = firstDayOfMonth(for: month)
        guard let specificDay = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) else { return false }
        return events.contains { event in
            calendar.isDate(event.date, inSameDayAs: specificDay)
        }
    }

    
    func addEvent(title: String, date: Date) {
            let newEvent = CalendarEvent(date: date, title: title)
            events.append(newEvent)
            events.sort { $0.date < $1.date } // Optional: keep events sorted
        }

//        func fetchEvents(for date: Date) {
//            eventsForSelectedDate = events.filter {
//                calendar.isDate($0.date, inSameDayAs: date)
//            }
//        }

//        func selectDate(_ date: Date) {
//            selectedDate = date
//            fetchEvents(for: date)
//        }
    
}
extension CalendarViewModel {
    // Navigate to the next month
    func nextMonth() {
        month = calendar.date(byAdding: .month, value: 1, to: month)!
    }
    
    // Navigate to the previous month
    func previousMonth() {
        month = calendar.date(byAdding: .month, value: -1, to: month)!
    }
}

