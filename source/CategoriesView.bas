B4J=true
Group=Views
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
' Categories View
' Version 0.30
Sub Class_Globals
	Private App As EndsMeet
End Sub

Public Sub Initialize
	App = Main.App
End Sub

Private Sub ExistInCache (Key As String) As Boolean
	Return MC.ExistInCache(App.ctx, Key)
End Sub

Private Sub ReadFromCache (Key As String) As Object
	Return MC.ReadFromCache(App.ctx, Key)
End Sub

Private Sub WriteToCache (Key As String, Value As Object)
	MC.WriteToCache(App.ctx, Key, Value)
End Sub

Public Sub Show (Req As ServletRequest) As String
	Dim CacheName As String = "Categories Page"
	If ExistInCache(CacheName) = False Then
		WriteToCache(CacheName, CategoriesPage(Req))
	End If
	Dim page1 As MiniHtml = ReadFromCache(CacheName)
	Dim doc As MiniHtml
	doc.Initialize("doctype")
	doc.Append(page1.build)
	Return doc.ToString
End Sub

Public Sub Modal (Action As String, Data As Map) As String
	Select Action
		Case "Add"
			Dim CacheName As String = "Categories Add Modal"
			If ExistInCache(CacheName) = False Then
				WriteToCache(CacheName, ModalAdd)
			End If
		Case "Edit"
			Dim CacheName As String = "Categories Edit Modal"
			If ExistInCache(CacheName) = False Then
				WriteToCache(CacheName, ModalEdit)
			End If
			Dim modal1 As MiniHtml = ReadFromCache(CacheName)
			Dim id1 As MiniHtml = modal1.ChildById("id")
			id1.attr("value", Data.Get("id"))
			Dim input1 As MiniHtml = modal1.ChildById("name")
			input1.attr("value", Data.Get("product_name"))
		Case "Delete"
			Dim CacheName As String = "Categories Delete Modal"
			If ExistInCache(CacheName) = False Then
				WriteToCache(CacheName, ModalDelete)
			End If
			Dim modal1 As MiniHtml = ReadFromCache(CacheName)
			Dim id1 As MiniHtml = modal1.ChildById("id")
			id1.attr("value", Data.Get("id"))
			Dim p1 As MiniHtml = modal1.ChildById("p1")
			p1.text2($"Delete ${Data.Get("product_name")} (${Data.Get("product_code")})?"$)			
	End Select
	Dim modal1 As MiniHtml = ReadFromCache(CacheName)
	Return modal1.build
End Sub

Public Sub Alert (info As AlertInfo) As String
	Return MH.Alert(info)
End Sub

Public Sub Toast (info As ToastInfo, data As List) As String
	Return MH.Toast("categories-container", CategoriesTableFilled(data), info)
End Sub

Public Sub RenderedTable (data As List) As String
	Return CategoriesTableFilled(data).build
End Sub

Private Sub CategoriesPage (Req As ServletRequest) As MiniHtml
	Dim main1 As MainView
	main1.Initialize
	main1.LoadContent(ContainerContent)
	main1.LoadModal(MH.ContainerModal)
	main1.LoadToast(MH.ContainerToast)
	Dim page1 As MiniHtml = main1.Render
	Dim navbarCollapse As MiniHtml = page1.ChildById("navbarCollapse")
	Dim navitem1 As MiniHtml = navbarCollapse.ChildByIndex(0)
	If 1 = Req.GetSession.GetAttribute("admin") Then
		MH.NavLinkItem("Home", "/", "bi bi-house me-2", "Home").up(navitem1)
		If App.api.EnableHelp Then MH.NavLinkItem("API", "/help", "bi bi-house me-2", "API").up(navitem1)
		MH.NavLinkItem("Sign Out", "/logout", "bi-box-arrow-right", "Sign Out").up(navitem1)
	End If	
	Return page1
End Sub

Private Sub ContainerContent As MiniHtml
	Dim row1 As MiniHtml = MH.Div
	row1.cls("row mt-3 text-center align-items-center justify-content-center")
	Dim col1 As MiniHtml = MH.Div.up(row1).cls("col-md-12 col-lg-6")
	Dim form1 As MiniHtml = MH.Form.up(col1).cls("form mb-3")
	Dim row2 As MiniHtml = MH.Div.up(form1).cls("row")
	Dim col2 As MiniHtml = MH.Div.up(row2).cls("col-md-6 col-lg-6 text-start")
	MH.H3.up(col2).text("CATEGORY LIST")
	Dim div1 As MiniHtml = MH.Div.up(row2).cls("col-md-6 col-lg-6")
	Dim div2 As MiniHtml = MH.Div.up(div1).cls("text-end mt-2")
	MH.ButtonAdd("Add Category", "btn btn-success ml-2", "/hx/categories/add", "#modal-content", "click", "#modal-container", "modal").up(div2)
	MH.ContainerHxGet("categories-container", "/hx/categories/table", "load", "Loading...").up(col1)
	Return row1
End Sub

Private Sub CategoriesTableFilled (data As List) As MiniHtml
	Dim CacheName As String = "Categories Table"
	If ExistInCache(CacheName) = False Then
		WriteToCache(CacheName, CategoriesTable)
	End If
	Dim CacheName As String = "Categories Table Row"
	If ExistInCache(CacheName) = False Then
		WriteToCache(CacheName, CategoriesTableRow.ConvertToBytes) ' bytes()
	End If
	Dim table1 As MiniHtml = ReadFromCache("Categories Table")
	Dim tbody1 As MiniHtml = table1.ChildByName("tbody")
	tbody1.Children.Clear
	For Each row As Map In data
		Dim tr1 As MiniHtml = ReadFromCache("Categories Table Row") ' bytes()
		tr1.ChildByIndex(0).text2(row.Get("id"))
		tr1.ChildByIndex(1).text2(row.Get("category_name"))
		tr1.ChildByIndex(2).ChildByIndex(0).attr("hx-get", "/hx/categories/edit/" & row.Get("id"))
		tr1.ChildByIndex(2).ChildByIndex(1).attr("hx-get", "/hx/categories/delete/" & row.Get("id"))
		tr1.up(tbody1)
	Next
	Return table1
End Sub

Public Sub CategoriesTable As MiniHtml
	Dim table1 As MiniHtml = MH.Table
	table1.cls("table table-bordered table-hover rounded small")
	Dim thead1 As MiniHtml = MH.Thead.up(table1).cls("table-light")
	MH.Th.up(thead1).text("#").sty("text-align: right; width: 50px")
	MH.Th.up(thead1).text("Name")
	MH.Th.up(thead1).text("Actions").sty("text-align: center; width: 120px")
	MH.Tbody.up(table1)
	Return table1
End Sub

Public Sub CategoriesTableRow As MiniHtml
	Dim tr1 As MiniHtml = MH.Tr
	Dim td1 As MiniHtml = MH.Td.up(tr1)
	td1.cls("align-middle").sty("text-align: right")
	Dim td2 As MiniHtml = MH.Td.up(tr1)
	td2.cls("align-middle")'.text("{name}")
	Dim td3 As MiniHtml = MH.Td.up(tr1)
	td3.cls("align-middle text-center px-1 py-1")
	MH.AnchorIcon("edit text-primary mx-2", "/hx/categories/edit/{id}", "Edit", "bi bi-pencil").up(td3)
	MH.AnchorIcon("delete text-danger mx-2", "/hx/categories/delete/{id}", "Delete", "bi bi-trash3").up(td3)
	Return tr1
End Sub

Private Sub ModalAdd As MiniHtml
	Dim form1 As MiniHtml = MH.FormHxPost("/hx/categories", "#modal-messages")
	Dim modalHeader As MiniHtml = MH.Div.up(form1).cls("modal-header")
	MH.H5.up(modalHeader).cls("modal-title").text("Add Category")
	MH.ButtonClose.up(modalHeader)
	
	Dim modalBody As MiniHtml = MH.Div.up(form1).cls("modal-body")
	MH.Div.up(modalBody).attr("id", "modal-messages")
	Dim group1 As MiniHtml = MH.FormGroup.up(modalBody)
	MH.RequiredLabel("Name ", "name").up(group1)
	MH.RequiredTextInput("name", "name", "").up(group1)

	Dim modalFooter As MiniHtml = MH.Div.up(form1).cls("modal-footer")
	MH.ButtonSubmit("Create", "btn btn-success px-3").up(modalFooter)
	MH.ButtonCancel("Cancel", "btn btn-secondary px-3").up(modalFooter)
	Return form1
End Sub

Private Sub ModalEdit As MiniHtml
	Dim form1 As MiniHtml = MH.FormHxPut("/hx/categories", "#modal-messages")
	Dim modalHeader As MiniHtml = MH.Div.up(form1).cls("modal-header")
	MH.H5.up(modalHeader).cls("modal-title").text("Edit Category")
	MH.ButtonClose.up(modalHeader)
	
	Dim modalBody As MiniHtml = MH.Div.up(form1).cls("modal-body")
	MH.Div.up(modalBody).attr("id", "modal-messages")
	MH.HiddenInput("id", "id", "").up(modalBody)
	Dim group1 As MiniHtml = MH.FormGroup.up(modalBody)
	MH.RequiredLabel("Name ", "name").up(group1)
	MH.RequiredTextInput("name", "name", "").up(group1)
	
	Dim modalFooter As MiniHtml = MH.Div.up(form1).cls("modal-footer")
	MH.ButtonSubmit("Update", "btn btn-primary px-3").up(modalFooter)
	MH.ButtonCancel("Cancel", "btn btn-secondary px-3").up(modalFooter)
	Return form1
End Sub

Private Sub ModalDelete As MiniHtml
	Dim form1 As MiniHtml = MH.FormHxDelete("/hx/categories", "#modal-messages")
	Dim modalHeader As MiniHtml = MH.Div.up(form1).cls("modal-header")
	MH.H5.up(modalHeader).cls("modal-title").text("Delete Category")
	MH.ButtonClose.up(modalHeader)
	
	Dim modalBody As MiniHtml = MH.Div.up(form1).cls("modal-body")
	MH.Div.up(modalBody).attr("id", "modal-messages")
	MH.HiddenInput("id", "id", "").up(modalBody)
	MH.P.up(modalBody).Id = "p1"
	
	Dim modalFooter As MiniHtml = MH.Div.up(form1).cls("modal-footer")
	MH.ButtonSubmit("Delete", "btn btn-danger px-3").up(modalFooter)
	MH.ButtonCancel("Cancel", "btn btn-secondary px-3").up(modalFooter)
	Return form1
End Sub