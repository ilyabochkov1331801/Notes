import UIKit

extension Note {
    static func parse(json: [String: Any] ) -> Note? {
        
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String, let content = json["content"] as? String
            else { return nil }
        
        var color: UIColor
        var importance: Importance
        var date: Date?
        
        if let colorComponents = json["color"] as? Array<CGFloat> {
            color = UIColor(red: colorComponents[colorComponentsList.red.rawValue],
                            green: colorComponents[colorComponentsList.green.rawValue],
                            blue: colorComponents[colorComponentsList.blue.rawValue],
                            alpha: colorComponents[colorComponentsList.alpha.rawValue])
        } else {
            color = UIColor.white
        }
        if let importanceString = json["importance"] as? String {
            importance = Importance.init(rawValue: importanceString)!
        } else {
            importance = Note.Importance.normal
        }
        if let dateTimeInterval = json["selfDestructionDate"] as? TimeInterval {
            date = Date.init(timeIntervalSince1970: dateTimeInterval)
        } else {
            date = nil
        }
        return Note(uid: uid,
                    title: title,
                    content: content,
                    color: color,
                    importance: importance,
                    selfDestructionDate: date)
    }
    
    var json: [String: Any] {
        get{
            var jsonDictionary = Dictionary<String, Any>()
            jsonDictionary["uid"] = uid
            jsonDictionary["title"] = title
            jsonDictionary["content"] = content
            if color != UIColor.white {
                jsonDictionary["color"] = color.colorComponents()
            }
            if importance != .normal {
                jsonDictionary["importance"] = importance.rawValue
            }
            if let date = selfDestructionDate {
                jsonDictionary["selfDestructionDate"] = date.timeIntervalSince1970
            }
            return jsonDictionary
        }
    }
}
