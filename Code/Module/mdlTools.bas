Attribute VB_Name = "mdlTools"
Option Compare Database
Option Explicit

Private Function InputSanitize(inputString As String) As String
    InputSanitize = Replace(inputString, """", """""")
End Function

Public Function GetSeedValue(strTable As String, strColumn As String) As Long
    Dim cnn As Object
    Dim cat As Object
    Dim col As Object

    Set cnn = CurrentProject.Connection
    Set cat = CreateObject("ADOX.Catalog")
    cat.ActiveConnection = cnn

    Set col = cat.Tables(strTable).Columns(strColumn)
    GetSeedValue = col.Properties("Seed")

    Set col = Nothing
    Set cat = Nothing
    Set cnn = Nothing
End Function

Public Function GetMultiInsertQCollection(insertQString As String) As Collection
    Dim strPattern As String
    Dim regEx As New RegExp
    Dim table As String
    Dim fields As String
    Dim fieldArray
    Dim fieldArrayNew
    Dim values As String
    Dim valueArray
    Dim valueArrayNew
    Dim additionalParts As Dictionary
    Dim isString As Boolean
    Dim i, j As Integer
    Dim k, v As Variant
    Dim multiInsertQCollection As Collection
    
    ' Parse the query
    strPattern = "INSERT INTO (\[.*\]) \((.*)\) VALUES \((.*)\)"
    
    Set additionalParts = New Dictionary
    Set multiInsertQCollection = New Collection
    
    With regEx
        .Pattern = strPattern
    End With
    
    If regEx.test(insertQString) Then
    
        ' Filter the query's parts
        table = regEx.Replace(insertQString, "$1")
        fields = regEx.Replace(insertQString, "$2")
        values = regEx.Replace(insertQString, "$3")
        
        table = Left(table, Len(table) - 1)
        fields = Left(fields, Len(fields) - 1)
        values = Left(values, Len(values) - 1)
    End If
    
    fieldArray = Split(fields, ", ")
    valueArray = Split(values, ", ")
    
    fields = ""
    values = ""
    
    For i = LBound(valueArray) To UBound(valueArray)
        Dim fieldArrayItem As Variant
        Dim valueArrayItem As Variant
        
        fieldArrayItem = fieldArray(i)
        valueArrayItem = valueArray(i)
        valueArrayNew = valueArray
        
        ' Process multi-value fields only
        If InStr(valueArrayItem, ";") Then
            Dim valueParts
            Dim valuePartsNew
            Dim value As Variant
            Dim field As Variant
            
            isString = False
            
            ' Determine the field type
            If Left(valueArrayItem, 1) = "'" Then
                isString = True
                valueArrayItem = Mid(valueArrayItem, 2, Len(valueArrayItem) - 2)
            End If
            
            ' Save values that have to be added separatly
            valueParts = Split(valueArrayItem, ";")
            ReDim Preserve valueParts(UBound(valueParts) - 1)
            j = 0
            
            ' Create field and value arrays without the ones that need to be added separatly
            ReDim valueArrayNew(UBound(valueArray) - 1)
            
            For Each value In valueArray
                If Not value = valueArray(i) Then
                    valueArrayNew(j) = value
                
                    j = j + 1
                End If
            Next
            
            j = 0

            ReDim fieldArrayNew(UBound(fieldArray) - 1)

            For Each field In fieldArray
                If Not field = fieldArray(i) Then
                    fieldArrayNew(j) = field
    
                    j = j + 1
                End If
            Next
            
            ' Save additional parts to append later
            additionalParts.Add i, valueParts
        Else
        
            ' Populate a field-value list of non-additional parts
            If fields <> "" Then
                fields = fields + ", "
                values = values + ", "
            End If
            
            fields = fields + fieldArrayItem
            values = values + valueArrayItem
        End If
    Next
    
    i = 1
    
    fields = Replace(fields, "[Help Offers]", "[Help Offers].Value")
    
    ' Add first sql query without multi-value fields
    multiInsertQCollection.Add "INSERT INTO " & table & " (" & fields & ") VALUES (" & values & ");"
    
    ' Add one sql query for every multi-value's field's values
    For Each k In additionalParts.Keys
        For Each v In additionalParts.Item(k)
            If v <> "" Then
                i = i + 1
                
                If isString Then
                    multiInsertQCollection.Add "INSERT INTO " & table & " (" & fieldArray(k) & ".Value) VALUES ('" & v & "') WHERE ID = (SELECT max(ID) FROM " & table & ");"
                Else
                    multiInsertQCollection.Add "INSERT INTO " & table & " (" & fieldArray(k) & ".Value) VALUES (" & v & ") WHERE ID = (SELECT max(ID) FROM " & table & ");"
                End If
            End If
        Next
    Next
    
    Set GetMultiInsertQCollection = multiInsertQCollection
End Function

Public Function GetControlExists(ctrlName As String, context As Form) As Boolean
    Dim controlExists As Boolean
    Dim ccontrol As Control
    
    controlExists = False

    For Each ccontrol In context.controls
        If ccontrol.name = ctrlName Then
            controlExists = True
            Exit For
        End If
    Next

    GetControlExists = controlExists
End Function

Public Sub ClearAllControls(controls As Collection, context As Form)
    Dim varItem As Variant
    Dim sql As String
    Dim i As Integer
    
    For Each varItem In controls
        If TypeOf varItem Is TextBox Or TypeOf varItem Is ComboBox Then
            'If varItem Is activeControl Then
            '    varItem.Text = ""
            'Else
                varItem.value = ""
            'End If
            If TypeOf varItem Is ComboBox Then
                sql = varItem.RowSource
                varItem.RowSource = ""
                varItem.RowSource = sql
            End If
        ElseIf TypeOf varItem Is ListBox Then
            For i = 0 To varItem.ListCount - 1
                varItem.Selected(i) = False
            Next
            
            ' Jump back to start of list
            varItem.Selected(0) = True
            varItem.Selected(0) = False
            
            Dim secondName As String
            
            If EndsWith(varItem.name, "Ids") Then
                secondName = Left(varItem.name, Len(varItem.name) - 3) & "s"
                
                If GetControlExists(secondName, context) Then
                    UpdatePreviewList context.controls(varItem.name), context.controls(secondName)
                End If
            Else
                secondName = varItem.name + "Prev"
                
                If GetControlExists(secondName, context) Then
                    UpdatePreviewList context.controls(varItem.name), context.controls(secondName)
                End If
            End If
        ElseIf TypeOf varItem Is CheckBox Then
            varItem.value = False
        End If
    Next
End Sub

Public Function EndsWith(str As String, ending As String) As Boolean
     Dim endingLen As Integer
     
     endingLen = Len(ending)
     EndsWith = (Right(Trim(UCase(str)), endingLen) = UCase(ending))
End Function

Public Function HasParent(context As Form) As Boolean
    On Error GoTo handler
    
    HasParent = TypeName(context.parent.name) = "String"
    
    Exit Function
handler:
End Function

Public Sub TryUpdateSaveButton(context As Form)
    If mdlTools.HasParent(context) And (CurrentProject.AllForms("Form Prim Input").IsLoaded Or CurrentProject.AllForms("Form Prim").IsLoaded) Then
        [Form_Form Prim Input].UpdateSaveButton context
    End If
End Sub

Public Sub UpdateIdPreviewText(source As Control, target As Control, fields As String, table As String)
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim cnn As ADODB.Connection
    Dim i As Integer
    Dim fieldArray
    
    target = ""
    
    If source.value <> "" Then
        Set db = CurrentDb
        Set cnn = CurrentProject.Connection
        Set rs = db.OpenRecordset("SELECT " & fields & " FROM " & table & " WHERE [ID] = " & source.value & ";")
        
        fieldArray = Split(fields, ", ")
    
        For i = LBound(fieldArray) To UBound(fieldArray)
            If target <> "" Then
                target = target & " "
            End If
        
            target = target & Nz(rs(fieldArray(i)), "[?]")
        Next
    End If
End Sub

Public Sub UpdatePreviewList(source As Control, target As Control)
    Dim index As Integer
    Dim inString, descString As String
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim cnn As ADODB.Connection
    Dim i As Integer
    Dim fieldArray
    Dim targetString As String
    
    target.RowSource = vbNullString

    With source
        For index = 0 To .ListCount - 1
            If .Selected(index) Then
                target.AddItem .ItemData(index)
            End If
        Next index
    End With
End Sub

Public Sub UpdateIdPreviewList(source As Control, target As Control, fields As String, table As String)
    Dim index As Integer
    Dim inString, descString As String
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim cnn As ADODB.Connection
    Dim i As Integer
    Dim fieldArray
    Dim targetString As String
    Dim element As Variant
    
    With source
        For Each element In .ItemsSelected
            If inString <> "" Then
                inString = inString & ","
            End If
            
            If .ControlSource = "" Then
                inString = inString & .Column(1, element)
            Else
                inString = inString & .Column(2, element)
            End If
        Next element
    End With
        
    target.RowSource = vbNullString

    If inString <> "" Then
        Set db = CurrentDb
        Set cnn = CurrentProject.Connection
        Set rs = db.OpenRecordset("SELECT " & fields & " FROM " & table & " WHERE [ID] IN (" & inString & ");")
    
        Do Until rs.EOF = True
            targetString = ""
            fieldArray = Split(fields, ", ")
            
            For i = LBound(fieldArray) To UBound(fieldArray)
                If targetString <> "" Then
                    targetString = targetString & " "
                End If
            
                targetString = targetString & Nz(rs(fieldArray(i)), "[?]")
            Next
            
            target.AddItem targetString
            rs.MoveNext
         Loop
    End If
End Sub

Public Function ValidateInput(varItem As Variant, context As Form) As Boolean
    Dim valid As Boolean
    Dim index As Integer
    
    valid = False
    
    If TypeOf varItem Is TextBox Or TypeOf varItem Is ComboBox Then
        If varItem Is context.activeControl Then
            If varItem.Text <> "" Then
                valid = True
            End If
        Else
            If varItem.value <> "" Then
                valid = True
            End If
        End If
    ElseIf TypeOf varItem Is ListBox Then
        For index = 0 To varItem.ListCount - 1
            If varItem.Selected(index) Then
                valid = True
                Exit For
            End If
        Next
    ElseIf TypeOf varItem Is CheckBox Then
        If varItem.value = -1 Then
                valid = True
        End If
    End If
    
    ValidateInput = valid
End Function
