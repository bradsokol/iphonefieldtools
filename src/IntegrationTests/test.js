UIALogger.logStart("Starting Test");
UIATarget.logElementTree();
UIATarget.localTarget().delay(5);
var app = UIATarget.localTarget().frontMostApp();
var mainWindow = app.mainWindow();
var rootView = mainWindow.elements[1];
UIALogger.logPass("Done!");
//  var textfields = view.textFields();
//  if (textfields.length != 2) {
//	  UIALogger.logFail("Wrong number of text fields");
//  } else {
//	  UIALogger.logPass("Right number of text fields");
//  }
//  var passwordfields = view.secureTextFields();
//  if (passwordfields.length != 1) {
//	  UIALogger.logFail("Wrong number of password fields");
//  } else {
//	  UIALogger.logPass("Right number of password fields");
//  }
//  textfields["username"].setValue("tturner");
//  passwordfields[0].setValue("tod");
//  view.buttons()["logon"].tap();
//  var errorVal = view.staticTexts()["error"].value();
//  if (errorVal != "Invalid User Name or Password") {
//	  UIALogger.logFail("Did Not Get Invalid Username Error: " + errorVal);
//  } else {
//	  UIALogger.logPass("Username Error Detected");
//  }