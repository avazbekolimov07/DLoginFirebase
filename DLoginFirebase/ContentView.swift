//
//  ContentView.swift
//  DLoginFirebase
//
//  Created by 1 on 24/09/21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @AppStorage("log_Status") var status = false
    @StateObject var model = ModelData()
    
    var body: some View {
        
        ZStack {
            if status {
                VStack(spacing: 25) {
                    
                    Text("Logged In As \(Auth.auth().currentUser?.email ?? "")")
                    
                    Button {
                        model.logOut()
                    } label: {
                        Text("LogOut")
                            .fontWeight(.bold)
                    } //: BUTTON
                }
            } else {
                LoginView(model: model)
            }
        } //: ZSTACK

    } //: BODY
} //: CONTENT VIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginView : View {
    
    @ObservedObject var model : ModelData
    
    var body: some View {
        ZStack {
            VStack {
            
            Spacer(minLength: 0)
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.height < 750 ? 130 : 200, height: UIScreen.main.bounds.height < 750 ? 130 : 200)
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.top)
            
            VStack(spacing: 4) {
                
                HStack(spacing: 0) {
                    Text("Club")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundColor(.white)
                    Text("Wolf")
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundColor(Color("txt"))
                } //: HSTACK
                
                Text("lets join to our club")
                    .font(.system(size: 10))
                    .foregroundColor(Color.black.opacity(0.3))
                    .fontWeight(.heavy)
            } //: VSTACK
            .padding(.top)
            
            VStack(spacing: 20) {
                CustomTextField(image: "person", placeHolder: "Email", txt: $model.email)
                
                CustomTextField(image: "lock", placeHolder: "Password", txt: $model.password)
            } //: VSTACK
            .padding(.top)
            
            Button {
                model.logIn()
            } label: {
                Text("LOGIN")
                    .fontWeight(.bold)
                    .foregroundColor(Color("bottom"))
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
            .padding(.top,22)
            
            HStack(spacing: 12) {
                Text("Don't have an account?")
                    .foregroundColor(Color.white.opacity(0.7))
                
                Button {
                    model.isSignUp.toggle()
                } label: {
                    Text("Sign up Now")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                } //: BUTTON
            } //: HSTACK
            .padding(.top, 25)
            
            Button {
                model.resetPassword()
            } label: {
                Text("Forget Password")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            } //: BUTTON
            .padding(.vertical, 22)
            
        } //: VSRACK
            
            if model.isLoading {
                LoadingView()
            }
        } //: ZSTACK
        .background(
            LinearGradient(gradient: .init(colors: [
                Color("top"),
                Color("bottom")]),
                           startPoint: .top,
                           endPoint: .bottom
                          )
                .ignoresSafeArea(.all, edges: .all)
        ) //: BACKGROUND
        .fullScreenCover(isPresented: $model.isSignUp) {
            SignUpView(model: model)
        }
        // Alerts
        .alert(isPresented: $model.alert) {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("OK")))
        }
        .alert(isPresented: $model.isLinkSend) {
            Alert(title: Text("Message"), message: Text("Password Reset Link Has Been Sent"), dismissButton: .destructive(Text("OK")))
        }
        
    } //: BODY
} //: LOGIN VIEW

struct CustomTextField : View {
    
    var image : String
    var placeHolder : String
    @Binding var txt : String
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            
            Image(systemName: image)
                .font(.system(size: 24))
                .foregroundColor(Color("bottom"))
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
            
            ZStack {
                if placeHolder == "Password" || placeHolder == "Re-Enter" {
                    SecureField(placeHolder, text: $txt)
                } else {
                    TextField(placeHolder, text: $txt)
                }
            }
            .padding(.horizontal)
            .padding(.leading, 65)
            .frame(height: 60)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
            
        } // ZSTACK
        .padding(.horizontal)
        
    } //BODY
} // CUSTOMTEXTFIELD VIEW

struct SignUpView : View {
    
    @ObservedObject var model : ModelData
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
            
            VStack {
                
                Spacer(minLength: 0)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.height < 750 ? 130 : 200, height: UIScreen.main.bounds.height < 750 ? 130 : 200)
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.top)
                
                VStack(spacing: 4) {
                    
                    HStack(spacing: 0) {
                        Text("New")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundColor(.white)
                        Text("Profile")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundColor(Color("txt"))
                    } //: HSTACK
                    
                    Text("Create a profile for you")
                        .font(.system(size: 10))
                        .foregroundColor(Color.black.opacity(0.3))
                        .fontWeight(.heavy)
                } //: VSTACK
                .padding(.top)
                
                VStack(spacing: 20) {
                    CustomTextField(image: "person", placeHolder: "Email", txt: $model.email_SignUp)
                    
                    CustomTextField(image: "lock", placeHolder: "Password", txt: $model.password_SignUp)
                    
                    CustomTextField(image: "lock", placeHolder: "Re-Enter", txt: $model.reEnterPassword)
                } //: VSTACK
                .padding(.top)
                
                Button {
                    model.signUp()
                } label: {
                    Text("SIGNUP")
                        .fontWeight(.bold)
                        .foregroundColor(Color("bottom"))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.vertical,22)
                
            } //: VSTACK
            
            Button {
                model.isSignUp.toggle()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            } //: BUTTON
            .padding(.trailing)
            .padding(.top, 10)
            if model.isLoading {
                LoadingView()
            }
        })
        .background(
            LinearGradient(gradient: .init(colors: [
                Color("top"),
                Color("bottom")]),
                           startPoint: .top,
                           endPoint: .bottom
                          )
                .ignoresSafeArea(.all, edges: .all)
        ) //: BACKGROUND
        .alert(isPresented: $model.alert) {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("OK"), action: {
                
                // if email link was sent means closing the SignUpView
                if model.alertMsg == "Email Verification Has Been Sent. Verify Your Email ID." {
                    model.isSignUp.toggle()
                    model.email_SignUp = ""
                    model.password_SignUp = ""
                    model.reEnterPassword = ""
                }
            }))
        }
    } //: BODY
} //: SIGN UP VIEW

// MVVM Model

class ModelData : ObservableObject { // cannot be struct
    
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    
    @Published var isLinkSend = false
    
    // Error alert
    @Published var alert = false
    @Published var alertMsg = ""
    
    // User Status
    @AppStorage("log_Status") var status = false
    
    // Loading
    @Published var isLoading = false
    
    // Alert with TextField
    func resetPassword() {
        
        let alert = UIAlertController(title: "Reset Password", message: "Enter Your E-Mail ID To Reset Your Password", preferredStyle: .alert)
        
        alert.addTextField { (password) in
            password.placeholder = "Email"
        }
        
        let proceed = UIAlertAction(title: "Reset", style: .default) { (_) in
          
            // Sending Password Link
            if alert.textFields![0].text! != "" {
                
                withAnimation {
                    self.isLoading.toggle()
                }
                
                Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { error in
                    
                    withAnimation {
                        self.isLoading.toggle()
                    }
                    
                    if error != nil {
                        self.alertMsg = error!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    // Alert User
                    self.alertMsg = "Password Reset Link Has Been Sent"
                    self.alert.toggle()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        // Presenting
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        
        
    } //: FUNC
    
    // Login
    func logIn() {
        
        if email == "" || password == "" {
            self.alertMsg = "Fill the Contents Properly."
            self.alert.toggle()
            return
        }
        
        withAnimation {
            self.isLoading.toggle()
        }
        
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            withAnimation {
                self.isLoading.toggle()
            }
            
            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }
            
            // checking if user is verified or not
            // if not verified means logging out
            
            let user = Auth.auth().currentUser
            if !(user!.isEmailVerified) {
                
                self.alertMsg = "Please Verify Email Address."
                self.alert.toggle()
                // Logging out
                try! Auth.auth().signOut() //: SIGN OUT
                
                return
            }
            
            // Setting user status as true
            withAnimation {
                self.status = true
            }
            
        } //: SIGN IN
    } //: FUNC
    
    // SignUp
    func signUp() {
        
        // Checking
        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == "" {
            self.alertMsg = "Fill Contents Properly."
            self.alert.toggle()
            return
        }
        
        if reEnterPassword != password_SignUp {
            self.alertMsg = "Password Mismatch."
            self.alert.toggle()
            return
        }
        
        withAnimation {
            self.isLoading.toggle()
        }
        
        Auth.auth().createUser(withEmail: email_SignUp,
                               password: password_SignUp) { (result, error) in
            
            withAnimation {
                self.isLoading.toggle()
            }

            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }
            
            // Sending Verification Link
            
            result?.user.sendEmailVerification(completion: { error in
                if error != nil {
                    self.alertMsg = error!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                //Alerting User To Verify Email
                self.alertMsg = "Email Verification Has Been Sent. Verify Your Email ID."
                self.alert.toggle()
            })
        } //: CREATE
        
    } //: FUNC
    
    func logOut() {
        try! Auth.auth().signOut()
        
        withAnimation {
            self.status = false
            
        }
        
        // cleaning all the data
        email = ""
        password = ""
        email_SignUp = ""
        password_SignUp = ""
        reEnterPassword = ""
        
    } //: FUNC
} //: CLASS

struct LoadingView : View {
    
    @State var animation = false
    
    var body: some View {
        
        VStack {
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color("bottom"), lineWidth: 8)
                .frame(width: 75, height: 75)
                .rotationEffect(.init(degrees: animation ? 360 : 0))
                .padding()
            
        } //: VSTACK
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all, edges: .all))
        .onAppear {
            withAnimation(Animation.linear(duration: 1)) {
                animation.toggle()
            }
        }
    } //: BODY
} //: LOADING VIEW
