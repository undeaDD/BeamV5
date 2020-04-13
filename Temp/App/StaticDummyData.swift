import Foundation

struct StaticDummyData {
    
    static func getListViewData() -> [(Section, [ListModel])] {
        return [
            (Section(title: "Test 1"), [
                ListModel(color: .red),
                ListModel(color: .red),
                ListModel(color: .red),
                ListModel(color: .red),
                ListModel(color: .red)
            ]),
            (Section(title: "Test 2"), [
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
                DetailModel(color: .red)
            ]),
            (Section(title: "Title"), [
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue)
            ])
        ]
    }
}
