import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var profiles: FetchedResults<UserProfile>
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        ScrollView(.vertical) {
            ForEach(profiles, id: \.self.id) { profile in
                ZStack {
                    Rectangle()
                        .padding()
                        .foregroundColor(.clear)
                    VStack {
                        if !profiles.isEmpty,
                            let photoData = profile.photoData,
                            let image = UIImage(data: photoData) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .padding(.top)
                        }
                        if let name = profile.name {
                            Text(name)
                                .foregroundColor(.cyan)
                                .bold()
                                .font(.title)
                        }
                        if let address = profile.address {
                            Text(address)
                                .foregroundColor(.black)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                        }
                        if let status = profile.status {
                            Group {
                                switch status {
                                case "none":
                                    HStack(spacing: 60) {
                                        decisionView(isPositive: false) {
                                            updateRecord(profile: profile, status: "declined")
                                        }
                                        
                                        decisionView(isPositive: true) {
                                            updateRecord(profile: profile, status: "accepted")
                                        }
                                    }
                                case "accepted":
                                    ZStack {
                                        Color.cyan
                                        Text("Accepted")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                            .padding(.vertical)
                                    }
                                    .cornerRadius(10)
                                case "declined":
                                    ZStack {
                                        Color.cyan
                                        Text("Declined")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                            .padding(.vertical)
                                    }
                                    .cornerRadius(10)
                                default: EmptyView()
                                }
                            }
                            .padding(.bottom, status == "none" ? 16 : .zero)
                        }
                        
                    }
                }
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1)
                )
                .padding()
            }
        }.onAppear {
            viewModel.fetchProfiles()
        }
        .onReceive(viewModel.$profiles) { newProfiles in
            if profiles.isEmpty && newProfiles.count == 10 {
                newProfiles.forEach { profile in
                    addItem(profile: profile.0, photoData: profile.1)
                }
            }
        }
    }
    
    private func decisionView(isPositive: Bool, action: @escaping () -> Void) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .frame(width: 60, height: 60)
            Button(action: action) {
                if isPositive {
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 30, height: 24)
                } else {
                    Image(systemName: "multiply")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 30)
                .stroke(.cyan, lineWidth: 3)
        )
    }

    private func addItem(profile: Profile, photoData: Data) {
        withAnimation {
            let newItem = UserProfile(context: viewContext)
            newItem.name = "\(profile.name.first) \(profile.name.last)"
            newItem.address = "\(profile.location.street.number), \(profile.location.street.name), \(profile.location.state)"
            newItem.photoData = photoData
            newItem.status = "none"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func updateRecord(profile: UserProfile, status: String) {
        withAnimation {
            // Update the property of the selected item
            profile.status = status
            
            // Save the changes
            do {
                try viewContext.save()
            } catch {
                // Handle the Core Data error
                print("Failed to save changes: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
