# **VRV Security**

**VRV Security** is a **Role-Based Access Control (RBAC)** Flutter application designed to help administrators manage roles, permissions, and users efficiently. Built with **Flutter** and integrated with **Firestore**, this project showcases a robust admin dashboard with real-time updates and intuitive UI for managing access control.

---

## **Features**

### **1. Role Management**
- **Add New Roles**: Dynamically create new roles using an intuitive form.
- **Edit Roles**: Modify existing role names and their associated permissions.
- **Delete Roles**: Remove roles safely, with error handling for reliability.

### **2. Permission Management**
- **Real-Time Updates**: Manage and update permissions (Read, Write, Delete) for each role in real-time.
- **Granular Control**: Toggle permissions for individual roles with smooth UI interactions.

### **3. User Management** *(Upcoming Feature)*
- View, edit, and delete users.
- Assign roles to users and manage their access levels.

### **4. Responsive Design**
- Optimized for mobile and desktop devices with a seamless UI experience.

### **5. Firestore Integration**
- Real-time data syncing for roles and permissions using **Firebase Firestore**.

---

## **Tech Stack**

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Firestore
- **State Management**: Stateful Widgets with StreamBuilder
- **Design**: Material Design with custom gradients for enhanced aesthetics

---

## **Setup Instructions**

### **1. Clone the repository**
Run the following commands to clone the repository and navigate to the project directory:
```bash
git clone https://github.com/yourusername/vrv_security.git
cd vrv_security