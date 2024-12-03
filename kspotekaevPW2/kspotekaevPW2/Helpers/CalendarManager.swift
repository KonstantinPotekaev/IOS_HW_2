import EventKit

final class CalendarManager {
    
    private let eventStore = EKEventStore()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                if let error = error {
                    print("Error requesting full access to calendar: \(error)")
                    completion(false)
                    return
                }
                completion(granted)
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                if let error = error {
                    print("Error requesting access to calendar: \(error)")
                    completion(false)
                    return
                }
                completion(granted)
            }
        }
    }
    
    func addEvent(event: CalendarEventModel, completion: @escaping (String?) -> Void) {
        let createEvent: () -> Void = {
            let newEvent = EKEvent(eventStore: self.eventStore)
            newEvent.title = event.title
            newEvent.startDate = event.startDate
            newEvent.endDate = event.endDate
            newEvent.notes = event.notes
            newEvent.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(newEvent, span: .thisEvent)
                completion(newEvent.eventIdentifier) // Возвращаем идентификатор
            } catch {
                print("Failed to save event: \(error)")
                completion(nil)
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                if let error = error {
                    print("Error requesting full access: \(error)")
                    completion(nil)
                    return
                }
                if granted {
                    createEvent()
                } else {
                    completion(nil)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                if let error = error {
                    print("Error requesting access: \(error)")
                    completion(nil)
                    return
                }
                if granted {
                    createEvent()
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func deleteEvent(with identifier: String, completion: @escaping (Bool) -> Void) {
        guard let event = eventStore.event(withIdentifier: identifier) else {
            completion(false)
            return
        }
        
        do {
            try eventStore.remove(event, span: .thisEvent)
            completion(true)
        } catch {
            print("Failed to remove event: \(error)")
            completion(false)
        }
    }
}
