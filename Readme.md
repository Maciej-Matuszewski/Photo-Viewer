# Photo Viewer
## Author: [Maciej Matuszewski](mailto:maciej.matuszewski@me.com)

***

## Test accounts
### Pinterest:
> email: `maciej.matuszewski+cookpad@me.com`

> password: `password123`

***

## Description

**Photo Viewer** is an application for displaying photos and animations from various services. In the version `1.0`, app supports **Pinterest** and **Giphy**. The biggest advantage of this app is possibility to easy integrate another services by using prepared protocols.

* **Pinterest** has been integrated using the REST API
* **Giphy** has been integrated with the framework provided by service owner

The application consists of three parts:

* **HomeScreen**: *This screen is center of app, here you can find photos downloaded from various services. HomeScreen contains table with photos, search field for query specific photos and refresh controller.*
* **PhotoPreviewScreen**: *Purpose of this screen is presentation photos and animations in full screen. This screen is equipped with gesture recognizers to manipulate and transform photos.*
* **OnboardingScreen**: *This screen is presented on first app use. There are some informations about app and there also we can login to first service. This screen has been made in chat style.*

The application has been made using `MVVM` architecture with parts written in `MVC`.
