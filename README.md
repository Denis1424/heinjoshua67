# Flutter Mobile Application Development Lab Experiments

This repository contains complete Flutter applications, source code, and quick-revision exam cheat sheets ("bone code") for Experiments 1 through 6.

---

## 📚 Experiments Index

### 🍎 [Experiment 1: Working with Widgets and Layouts](./exp1_widgets_and_layouts)
- **Objective**: Design and develop a Flutter application that displays a list of fruit items using `Row`, `Column`, `Container`, `Card`, and `ListView` widgets. Create reusable custom widgets to organize the user interface effectively.
- **Key Widgets**: `Row`, `Column`, `Container`, `Card`, `ListView.builder`, custom `FruitCard`.
- **Exam Snippet**: Included in [exp1_widgets_and_layouts/README.md](./exp1_widgets_and_layouts/README.md).

### 📱 [Experiment 2: Adaptive and Responsive UI Design](./exp2_responsive_ui_design)
- **Objective**: Design and implement a responsive Flutter application for an E-Commerce Product Catalog by creating reusable custom product widgets. Ensure the application adapts to different screen sizes using responsive layout techniques.
- **Key Techniques**: `LayoutBuilder`, responsive breakpoints (<600px vs $\ge$600px), multi-column `GridView.builder`, custom `ProductCard`.
- **Exam Snippet**: Included in [exp2_responsive_ui_design/README.md](./exp2_responsive_ui_design/README.md).

### 🔍 [Experiment 3: Add Interactivity to App – Input and Forms](./exp3_interactive_inputs_search)
- **Objective**: Develop a Flutter application that displays a predefined list of products and allows users to search or filter the products using input widgets, providing an interactive user experience.
- **Key Widgets**: `TextField` with `onChanged`, `ChoiceChip` filters, `RangeSlider`, dynamic filtering via `setState`.
- **Exam Snippet**: Included in [exp3_interactive_inputs_search/README.md](./exp3_interactive_inputs_search/README.md).

### ⛽ [Experiment 4: Form Validation using Stateful Widgets](./exp4_form_validation_calculator)
- **Objective**: Design and implement a Car Mileage Calculator using Flutter Forms, `TextFormField`, Input Widgets, and Stateful Widgets. Validate user inputs and display the calculated mileage dynamically.
- **Key Concepts**: `Form`, `GlobalKey<FormState>`, input field validators, dynamic calculation formulas.
- **Exam Snippet**: Included in [exp4_form_validation_calculator/README.md](./exp4_form_validation_calculator/README.md).

### ☁️ [Experiment 5: Google Cloud Firestore Search & Retrieval](./exp5_cloud_firestore_search)
- **Objective**: Design and implement a Flutter application that retrieves information from Google Cloud Firestore based on user search input and displays the corresponding records dynamically.
- **Key Concepts**: `Firebase.initializeApp()`, `FirebaseFirestore.instance.collection(...)`, range prefix queries, `StreamBuilder<QuerySnapshot>`.
- **Exam Snippet**: Included in [exp5_cloud_firestore_search/README.md](./exp5_cloud_firestore_search/README.md).

### ✏️ [Experiment 6: Update Existing Records in Google Cloud Firestore](./exp6_cloud_firestore_update)
- **Objective**: Develop a Flutter application that allows users to update existing records stored in Google Cloud Firestore based on user input and displays the updated information dynamically.
- **Key Concepts**: `FirebaseFirestore.instance.collection(...).doc(id).update(...)`, interactive edit dialogs, real-time UI synchronization via `StreamBuilder`.
- **Exam Snippet**: Included in [exp6_cloud_firestore_update/README.md](./exp6_cloud_firestore_update/README.md).

---

## 🚀 Running Any Experiment

To run any experiment application locally:

```bash
cd <experiment-folder-name>
flutter run
```
