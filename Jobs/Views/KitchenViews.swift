//
//  KitchenViews.swift
//  Jobs
//
//  Created by Daniel Watson on 04.01.24.
//
import SwiftUI
import Combine  // If needed for Combine functionality


// KitchensViewModel
class KitchensViewModel: ObservableObject {
    private var miseboxUserManager = MiseboxUserManager()
    @Published var miseboxUser: MiseboxUserManager.MiseboxUser
    
    private var kitchenManager = KitchenManager()
    
    @Published var kitchens: [Kitchen] = []
    @Published var myKitchens: [Kitchen] = []
    @Published var globalKitchens: [Kitchen] = []
    
    @Published var newKitchen = KitchenManager.Kitchen()
    
    init(miseboxUser: MiseboxUserManager.MiseboxUser) {
        self.miseboxUser = miseboxUser
        loadKitchens()
    }
    
    struct Kitchen: Identifiable {
        var id: String
        var name: String
        
        init(from kitchen: KitchenManager.Kitchen) {
            self.id = kitchen.id
            self.name = kitchen.name
        }
        
        init(from miseboxKitchen: MiseboxUserManager.Kitchen) {
            self.id = miseboxKitchen.id
            self.name = miseboxKitchen.name
        }
        
        func toMiseboxKitchen() -> MiseboxUserManager.Kitchen {
            return MiseboxUserManager.Kitchen(id: self.id, name: self.name)
        }
    }
    func loadKitchens() {
        kitchenManager.collectionListener { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fullKitchens):
                    self?.kitchens = fullKitchens.map(Kitchen.init)
                    if let filteredKitchens = self?.globalkitchensFilter(fullKitchens) {
                        self?.globalKitchens = filteredKitchens
                    }
                case .failure(let error):
                    print("Error fetching kitchens: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func createKitchen(miseboxUserId: String) async {
        let kitchenId = try? await kitchenManager.createKitchen(kitchen: newKitchen)
        let localKitchen = Kitchen(from: newKitchen)
        miseboxUserManager.addKitchenToUser(kitchen: localKitchen.toMiseboxKitchen(), miseboxUserId: miseboxUserId)
    }
    
    func makePrimary(kitchen: Kitchen) {
        let isKitchenInMyKitchens = miseboxUser.kitchens.contains(where: { $0.id == kitchen.id })

        if isKitchenInMyKitchens {
            miseboxUserManager.setAsPrimaryKitchen(userId: miseboxUser.id, kitchen: kitchen.toMiseboxKitchen())
    
        } else {
            print("Kitchen is not in myKitchens")
        }
    }

    func addToKitchens(kitchen: Kitchen) {
        miseboxUserManager.addKitchenToUser(kitchen: kitchen.toMiseboxKitchen(), miseboxUserId: miseboxUser.id)

        if miseboxUser.primaryKitchen == nil {
            miseboxUserManager.setAsPrimaryKitchen(userId: miseboxUser.id, kitchen: kitchen.toMiseboxKitchen())
        }
    }

    
    func printKitchenName(kitchen: Kitchen) {
        print("Tapped on kitchen: \(kitchen.name)")
    }
    func printKitchenId(kitchen: Kitchen) {
        print("Tapped on kitchen: \(kitchen.id)")
    }
    
    func globalkitchensFilter(_ kitchens: [KitchenManager.Kitchen]) -> [Kitchen] {
        let myKitchenIDs = miseboxUser.kitchens.map { $0.id }
        
        let filteredKitchens = kitchens.filter { kitchen in
            !myKitchenIDs.contains(kitchen.id)
        }
        
        return filteredKitchens.map { Kitchen(from: $0) }
    }
}

struct PrimaryKitchenCell: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser

    var body: some View {
        HStack {
            Image(systemName: "star.fill") // Gold star icon
                .foregroundColor(.yellow) // Gold color
            Text("Primary Kitchen name: \(miseboxUser.primaryKitchen?.name ?? "non")")
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

struct KitchenDashboard: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @StateObject var vm: KitchensViewModel
    
    @Binding  var navigationPath: NavigationPath

    
    var body: some View {
        
        PrimaryKitchenCell()
        
        Section(header: Text("Create Kitchen")) {
            CreateKitchenView(vm: vm)
        }
        
        Section(header: Text("My Kitchens")) {
            KitchensList(kitchens: miseboxUser.kitchens.map(KitchensViewModel.Kitchen.init), onRowTap: { kitchen in
                vm.makePrimary(kitchen: kitchen)
            })
        }
        
        
        Section(header: Text("Global Kitchens")) {
            KitchensList(kitchens: vm.globalKitchens , onRowTap: { kitchen in
                vm.addToKitchens(kitchen: kitchen)
            })
            
        }
        .navigationTitle("Kitchens Dashboard")
    }
}


struct CreateKitchenView: View {
    @EnvironmentObject var session: Session
    @ObservedObject var vm: KitchensViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Kitchen Details")) {
                TextField("Kitchen Name", text: $vm.newKitchen.name)
            }
            Section {
                Button("Create Kitchen") {
                    Task {
                        await vm.createKitchen(miseboxUserId: session.miseboxUserId)
                    }
                }
            }
        }
        .navigationTitle("Create Kitchen")
    }
}


struct KitchensList: View {
    var kitchens: [KitchensViewModel.Kitchen]
    var onRowTap: (KitchensViewModel.Kitchen) -> Void

    var body: some View {
        List(kitchens) { kitchen in
            KitchenRow(kitchen: kitchen, onRowTap: {
                onRowTap(kitchen)
            })
        }
    }
}

struct KitchenRow: View {
    var kitchen: KitchensViewModel.Kitchen
    var onRowTap: () -> Void

    var body: some View {
        HStack {
            Text(kitchen.name)
                .onTapGesture {
                    onRowTap()
                }
        }
    }
}
struct KitchenDashboard_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            NavigationStack {
                kitchenDashboardPreviewWithKitchen()
                    .previewDisplayName("With Primary Kitchen")
            }
            NavigationStack {
                kitchenDashboardPreviewWithoutKitchen()
                    .previewDisplayName("Without Primary Kitchen")
            }
        }
    }

    static func kitchenDashboardPreviewWithKitchen() -> some View {
        let primaryKitchen = MiseboxUserManager.Kitchen(id: "kitchen-123", name: "Gourmet Haven")
        let kitchens = [
            primaryKitchen,
            MiseboxUserManager.Kitchen(id: "kitchen-456", name: "Culinary Corner"),
            MiseboxUserManager.Kitchen(id: "kitchen-789", name: "Chef's Delight")
        ]

        return setupKitchenDashboard(primaryKitchen: primaryKitchen, kitchens: kitchens)
    }

    static func kitchenDashboardPreviewWithoutKitchen() -> some View {
        return setupKitchenDashboard(primaryKitchen: nil, kitchens: [])
    }

    static func setupKitchenDashboard(primaryKitchen: MiseboxUserManager.Kitchen?, kitchens: [MiseboxUserManager.Kitchen]) -> some View {
        let miseboxUser = MiseboxUserManager.MiseboxUser()
        miseboxUser.id = "12345"
        miseboxUser.name = "Dave"
        miseboxUser.role = "Chef"
        miseboxUser.verified = true
        miseboxUser.primaryKitchen = primaryKitchen
        miseboxUser.kitchens = kitchens
        miseboxUser.accountProviders = ["Email", "Google"]

        return KitchenDashboard(vm: KitchensViewModel(miseboxUser: miseboxUser), navigationPath: .constant(NavigationPath()))
            .environmentObject(miseboxUser)
    }
}
