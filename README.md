# Description

**Flutter Sample**

A sample Flutter application that demonstrates Joget DX integration.

Workable actions:

- Enter into an account
- Login & logout
- View and update profile
- CRM and ISR
	- View and submit Form
	- View and filter List

## lib/

### App
This folder contains all the widgets related to Joget DX apps (e.g. CRM, ISR, etc.). 

#### App.dart
It handles the rendering of the Joget DX app. Meaning, it contains the navigation bar, title of the app, and content of the app (e.g. List, Form, etc.).

#### AppCard.dart
It acts as a button in which the user can tap on it to navigate to a particular Joget DX app.

#### AppCardGrid.dart
It holds all the AppCard widgets and displays them in a grid view.

#### AppContent.dart
This is where the content of the app is displayed. In the navigation bar, when the users selects a Form, this widget is triggered to process the rendering of the Form and displays them accordingly.

### Auth.dart
This folder contains all the widgets related to pages that expects authentication from the user.

#### Start.dart
In here, the user is expected to enter their Joget DX account URL so that the application can make API calls accordingly.

#### Login.dart
It expects the username and password of the user so that it can display the information according to their status, e.g. anonymous, logged in, and admin.

### Configuration
The folder contains all the widgets that handles configurations/settings in the application.

#### APIBuilderSettings.dart
It handles the setting and saving of the credentials required to make API requests to the API Builder plugin.

#### Profile.dart
It handles the setting and saving of the user profile details.

### CrudMenu
This folder contains all the widgets related to List.

#### Filters
This sub folder contains all the widgets that function as filters for the List (e.g. Pagination, Text Field, Options, etc.).

#### CrudMenu.dart
This is where the content of the List is displayed, which includes the filters, list actions, and the table itself.

### Dashboard
This folder contains all the widgets related to dashboard. The dashboard is the first page the user will see when they have logged in to the Flutter app.

#### Home.dart
This is where all the Joget DX apps (e.g. CRM, ISR, etc.) can be seen. Besides that, the user can also view information such as their name and email address. They can also navigate to the Profile page. Finally, the user can perform logout action from here.

### Drawer
This folder contains all the widgets that appears on side drawers throughout the app. Currently, there are two side drawers in the application, Home and App page.

#### CategoryItem.dart
This widget resides on the side drawer of App page. It represents a category from the navigation bar in a particular Joget DX app. This widget is usually stored in a list because there will be many categories in a navigation bar.

#### ProfileSection.dart
This widget resides on the side drawer of Home page. It displays the user information. If they are logged in, their name, email address, profile settings button, and logout button will be displayed. Otherwise, their name and login button will be displayed.

### FormMenu
This folder contains all the widgets related to Form.

#### Elements
This folder contains all form element widgets. It is even broken down into subfolders where according to the type of the form element.

#### Validator
This folder contains all validator widgets. So far, there is only one validator which is the DefaultValidator.

#### FormMenu.dart
This is where the process of retrieving the JSON definition of the form and mapping them into widgets happens. Then, the Form is displayed to the user in which they can perform submission.

### UI
This folder contains all widgets that contributes to the user interface of the application.

#### Loading.dart
It displays a white animated circular loading indicator with faded black background. This widget is displayed whenever an API call is made.

### Utilities
This folder contains crucial functionalities and components used by the application.

#### API.dart
This contains all the API calls that can be made to the API Builder and Flutter API plugin.

#### Functions.dart
This contains specific functions and classes used by the application. Example: storing/retrieving values in/from local storage, extracting inner text contained in a HTML string, etc.

#### Global.dart
This contains the global variables which can be accessed and modified by all classes in the application.

### main.dart
This serves as the entry point for the application, where the execution of the application begins.

## flutter_api
An API plugin that provides more specific functionalities for the integration.

### getFormID
Pass processDefId of a RunProcess to get the formId it is linked to.

### getSelectBoxOptions
Get options value of a FormMenu from the options binder or default options.

### getHashValue
Pass a hash variable string to get its value.

# Getting Help

JogetOSS is a community-led team for open source software related to the [Joget](https://www.joget.org) no-code/low-code application platform.
Projects under JogetOSS are community-driven and community-supported.
To obtain support, ask questions, get answers and help others, please participate in the [Community Q&A](https://answers.joget.org/).

# Contributing

This project welcomes contributions and suggestions, please open an issue or create a pull request.

Please note that all interactions fall under our [Code of Conduct](https://github.com/jogetoss/repo-template/blob/main/CODE_OF_CONDUCT.md).

# Licensing

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

NOTE: This software may depend on other packages that may be licensed under different open source licenses.
