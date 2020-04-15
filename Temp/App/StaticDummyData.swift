import Foundation

struct StaticDummyData {
    
    static func getListViewData() -> [(Section, [ListModel])] {
        return [
            (Section(title: "Test 1"), [
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue),
                ListModel(color: .blue)
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
                DetailModel(color: .red),
                DetailModel(color: .red),
                DetailModel(color: .red),
                DetailModel(color: .red),
                DetailModel(color: .red)
            ]),
            (Section(title: "Related 1"), [
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue)
            ]),
            (Section(title: "Related 2"), [
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue),
                DetailModel(color: .blue)
            ])
        ]
    }
}
