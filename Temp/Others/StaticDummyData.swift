import Foundation

struct StaticDummyData {
    
    static func getListViewData() -> [(Section, [ListModel])] {
        return [
            (Section(title: "Item 1"), [
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue)
            ]),
            (Section(title: "Item 2"), [
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue)
            ])
        ]
    }
    
    static func getDetailViewData() -> [(Section, [DetailModel])] {
        return [
            (Section(title: "Header"), [
                DetailModel(color: .red),
                DetailModel(color: .red),
                DetailModel(color: .red),
                DetailModel(color: .red),
                DetailModel(color: .red)
            ])
        ]
    }
}
