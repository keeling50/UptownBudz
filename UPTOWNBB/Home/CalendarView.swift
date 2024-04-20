//
//  CalendarView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 4/14/24.
//
import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var selectedDayEvent: CalendarEvent?
    @State private var month: Date = Date()

    var body: some View {
        VStack {
            // Navigation and Month Display
            monthNavigation
            
            // Day of the Week Headers
            dayOfWeekHeaders
            
            // Days Grid
            daysGrid
            
        }
        .sheet(item: $selectedDayEvent) { event in
            EventDetailsView(event: event)
        }
        .background(Color.white.cornerRadius(25))
        .padding()
        .onReceive(viewModel.$month) { updatedMonth in
            month = updatedMonth
        }
    }
    
    private var monthNavigation: some View {
        HStack {
            Button(action: {
                withAnimation {
                    viewModel.previousMonth()
                }
            }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text("\(month, formatter: monthFormatter)")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.nextMonth()
                }
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }
    
    private var dayOfWeekHeaders: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                Text(day)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var daysGrid: some View {
        let totalDays = viewModel.numberOfDaysInMonth(for: month) + viewModel.dayOfWeek(for: viewModel.firstDayOfMonth(for: month))
        let indices = Array(0..<totalDays)
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(indices, id: \.self) { index in
                DayCell(index: index, viewModel: viewModel, month: month)
                    .onTapGesture {
                        let day = index - viewModel.dayOfWeek(for: viewModel.firstDayOfMonth(for: month)) + 1
                        let dayEvents = viewModel.events(for: day, month: month)
                            if !dayEvents.isEmpty {
                                self.selectedDayEvent = dayEvents.first
                            }
                    }
            }
        }
    }

    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

struct EventDetailsView: View {
    var event: CalendarEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Event: \(event.title)")
                .font(.title)
            Text("Date: \(event.date, formatter: dateFormatter)")
                .font(.headline)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Event Details", displayMode: .inline)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
}


struct DayCell: View {
    let index: Int
    let viewModel: CalendarViewModel
    let month: Date
    
    // Computed properties for clean view logic
    private var day: Int {
        let firstDayOffset = viewModel.dayOfWeek(for: viewModel.firstDayOfMonth(for: month))
        return index >= firstDayOffset ? index - firstDayOffset + 1 : 0
    }
    
    private var isDayInMonth: Bool {
        day > 0
    }
    
    private var hasEvent: Bool {
        isDayInMonth && viewModel.eventIndicator(for: day, month: month)
    }
    
    var body: some View {
        Group {
            if isDayInMonth {
                dayView
            } else {
                EmptyView()
            }
        }
    }
    
    private var dayView: some View {
        VStack {
            // Day display with enhanced UI features
            Text("\(day)")
                .padding(8)
                .background(todayIndicator)  // Custom background to indicate today
                .cornerRadius(5)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.blue, lineWidth: 1)  // Optional: add a border for better visibility
//                )
                .accessibilityLabel("Day \(day)")
                .accessibilityHint(hasEvent ? "Tap to see events" : "No events")
            // Event indicator: Consider customizing based on event type or importance
            if hasEvent {
                Circle()
                    .fill(Color.red)  // Consider using different colors for different event types
                    .frame(width: 10, height: 10)  // Made larger for better visibility
                    .offset(x: 10, y: -8)  // Adjusted for aesthetic balance
                    .animation(.easeIn)  // Smooth transition when events are added or removed
            }
        }
    }

    
    private var todayIndicator: some View {
        let today = Calendar.current.isDate(Date(), inSameDayAs: viewModel.date(forDay: day, month: month))
        return Circle()
            .fill(today ? Color.blue.opacity(0.2) : Color.clear)
            .overlay(
                today ? AnyView(Circle().stroke(Color.blue, lineWidth: 1).padding(-3).animation(.easeInOut(duration: 2).repeatForever())) : AnyView(EmptyView())
            )
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of the ViewModel
        let viewModel = CalendarViewModel()
        // Provide the ViewModel to the CalendarView
        CalendarView(viewModel: viewModel)
            .previewDisplayName("Calendar View")
    }
}
//extension [CalendarEvent]: Identifiable { public var id: [CalendarEvent()] { self } }
