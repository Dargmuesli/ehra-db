VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Public pformnameDict As New Scripting.Dictionary

Private Sub Class_Initialize()
    Dim formnameDict As New Scripting.Dictionary
    
    Dim volunteersDict As New Scripting.Dictionary
    Dim helpOffersSpecificationsDict As New Scripting.Dictionary
    Dim personsDict As New Scripting.Dictionary
    Dim accommodationsDict As New Scripting.Dictionary
    Dim supportcirclesDict As New Scripting.Dictionary
    
    volunteersDict.Add "cmbPersonid", "Person ID"
    volunteersDict.Add "cmbSupportcircle", "Support Circle"
    volunteersDict.Add "lstHelpoffers", "Help Offers"
    volunteersDict.Add "txtBeginning", "Beginning"
    volunteersDict.Add "txtEnding", "Ending"
    volunteersDict.Add "lstTargetgroups", "Target Groups"
    helpOffersSpecificationsDict.Add "cmbCategory", "Help Offer Category"
    helpOffersSpecificationsDict.Add "txtSpecification", "Help Offer Specification"
    personsDict.Add "cmbSalutation", "Salutation"
    personsDict.Add "txtTitle", "Title"
    personsDict.Add "txtFirstname", "First Name"
    personsDict.Add "txtLastname", "Last Name"
    personsDict.Add "txtPhonenumber", "Phone Number"
    personsDict.Add "txtMobilephonenumber", "Mobile Phone Number"
    personsDict.Add "txtEmailaddress", "E-Mail Address"
    personsDict.Add "txtStreet", "Street"
    personsDict.Add "cmbPostalcode", "Postal Code"
    personsDict.Add "txtPosition", "Position"
    personsDict.Add "lstLanguages", "Languages"
    personsDict.Add "cmbVolunteercertificate", "Volunteer Certificate"
    personsDict.Add "txtNotes", "Notes"
    personsDict.Add "chkContacted", "Contacted"
    personsDict.Add "chkReplied", "Replied"
    accommodationsDict.Add "cmbType", "Type"
    accommodationsDict.Add "txtName", "Accommodation Name"
    accommodationsDict.Add "txtStreet", "Street"
    accommodationsDict.Add "cmbPostalcode", "Postal Code"
    accommodationsDict.Add "txtCapacity", "Capacity"
    accommodationsDict.Add "cmbWardrobe", "Wardrobe"
    accommodationsDict.Add "cmbMaincontactpersonid", "Main Contact Person ID"
    accommodationsDict.Add "lstMainemployeeids", "Main Employee IDs"
    accommodationsDict.Add "txtNotes", "Notes"
    supportcirclesDict.Add "txtName", "Support Circle"
    supportcirclesDict.Add "lstVolunteercontactpersonids", "Volunteer Contact Person IDs"
    
    formnameDict.Add "Form Sec Input Volunteers", volunteersDict
    formnameDict.Add "Form Sec Input Help-Offer-Specifications", helpOffersSpecificationsDict
    formnameDict.Add "Form Sec Input Persons", personsDict
    formnameDict.Add "Form Sec Input Accommodations", accommodationsDict
    formnameDict.Add "Form Sec Input Support-Circles", supportcirclesDict
    
    Set pformnameDict = formnameDict
End Sub

