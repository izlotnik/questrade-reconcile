REM *****************************************************************************

Function RATEFROM( sSheet As String, sCAD As String, sUSD As String ) As Double
	oSheet = ThisComponent.Sheets.getByName( sSheet )
	dCAD = oSheet.getCellRangeByName( sCAD ).getValue( )
	dUSD = oSheet.getCellRangeByName( sUSD ).getValue( )
	RATEFROM = dCAD / dUSD
End Function

REM *****************************************************************************

Function EXCHANGERATE( ) As Double
	oNamedRange = ThisComponent.NamedRanges.getByName( "Exchange_Rate" )
	oCell = oNamedRange.getReferredCells( )
	EXCHANGERATE = oCell.getValue( )
End Function

REM *****************************************************************************

Function SEARCHDESCRIPTOR( oRange As Object, sTarget As String ) As Object
	oDescriptor = oRange.createSearchDescriptor( )
	oDescriptor.setSearchString( sTarget )
	oDescriptor.SearchCaseSensitive = true
	oDescriptor.SearchWords = true
	SEARCHDESCRIPTOR = oDescriptor
End Function

REM *****************************************************************************

Function FINDCELL( oSheet As Object, sRange As String, sTarget As String ) As Object
	Dim oRange, oDescriptor As Object
	oRange = oSheet.getCellRangeByName( sRange )
	oDescriptor = SEARCHDESCRIPTOR( oRange, sTarget )
	FINDCELL = oRange.findFirst( oDescriptor )
End Function

REM *****************************************************************************

Function COLUMNFROM( oCell As Object ) As Long
	COLUMNFROM = oCell.getCellAddress( ).Column
End Function

REM *****************************************************************************

Function ROWFROM( oCell As Object ) As Long
	ROWFROM = oCell.getCellAddress( ).Row
End Function

REM *****************************************************************************

Function COLUMN( oSheet As Object, sRange As String, sTarget As String ) As Long
	COLUMN = COLUMNFROM( FINDCELL( oSheet, sRange, sTarget ) )
End Function

REM *****************************************************************************

Function ROW( oSheet As Object, sRange As String, sTarget As String ) As Long
	ROW = ROWFROM( FINDCELL( oSheet, sRange, sTarget ) )
End Function

REM *****************************************************************************

Function MAPVALUE( sAccount As Variant, sSymbol As String, sSheet As String, sRange As String, sColumn As String, bCurrency As Boolean, bTotal As Boolean ) As Double
	Dim dValue, dTotal As Double
	Dim lAccount, lColumn, lSymbol, lCurrency As Long
	Dim oSymbol As Variant
	Dim oSheet, oRange, oDescriptor, oAccount, oValue As Object
	dValue = 0.0
	dTotal = 0.0
	On Local Error GoTo Finalize
	oSheet = ThisComponent.Sheets.getByName( sSheet )
	oRange = oSheet.getCellRangeByName( sRange )
	lAccount = COLUMN( oSheet, "A1:AMJ1", "account" )
	lColumn = COLUMN( oSheet, "A1:AMJ1", sColumn )
	lCurrency = COLUMN( oSheet, "A1:AMJ1", "currency" )
	oDescriptor = SEARCHDESCRIPTOR( oRange, sSymbol )
	oSymbol = oRange.findFirst( oDescriptor )
	While IsNull( oSymbol ) = False
		lSymbol = ROWFROM( oSymbol )
		oAccount = oSheet.getCellByPosition( lAccount, lSymbol )
		If IsNull( sAccount ) or oAccount.getString( ) = sAccount Then
			oValue = oSheet.getCellByPosition( lColumn, lSymbol )
			oCurrency = oSheet.getCellByPosition( lCurrency, ROWFROM( oValue ) )
			dValue = IIF( bCurrency And oCurrency.getString( ) = "USD", oValue.getValue( ) * EXCHANGERATE( ), oValue.getValue( ) )
			dTotal = dTotal + dValue
		End If
		oSymbol = oRange.findNext( oSymbol, oDescriptor )
	Wend
Finalize:
	MAPVALUE = IIF( bTotal, dTotal, dValue )
End Function

REM *****************************************************************************

Function DIVIDENDS( sSymbol As String ) As Double
	Dim dValue, dTotal As Double
	Dim lType, lAmount, lSymbol, lCurrency As Long
	Dim oSymbol As Variant
	Dim oSheet, oRange, oDescriptor, oType, oAmount As Object
	dValue = 0.0
	dTotal = 0.0
	On Local Error GoTo Finalize
	oSheet = ThisComponent.Sheets.getByName( "Activities" )
	oRange = oSheet.getCellRangeByName( "E1:E1048576" )
	lType = COLUMN( oSheet, "A1:AMJ1", "type" )
	lAmount = COLUMN( oSheet, "A1:AMJ1", "netAmount" )
	lCurrency = COLUMN( oSheet, "A1:AMJ1", "currency" )
	oDescriptor = SEARCHDESCRIPTOR( oRange, sSymbol )
	oSymbol = oRange.findFirst( oDescriptor )
	While IsNull( oSymbol ) = False
		lSymbol = ROWFROM( oSymbol )
		oType = oSheet.getCellByPosition( lType, lSymbol )
		If oType.getString( ) = "Dividends" Then
			oAmount = oSheet.getCellByPosition( lAmount, lSymbol )
			oCurrency = oSheet.getCellByPosition( lCurrency, ROWFROM( oAmount ) )
			dValue = IIF( oCurrency.getString( ) = "USD", oAmount.getValue( ) * EXCHANGERATE( ), oAmount.getValue( ) )
			dTotal = dTotal + dValue
		End If
		oSymbol = oRange.findNext( oSymbol, oDescriptor )
	Wend
Finalize:
	DIVIDENDS = dTotal
End Function

REM *****************************************************************************

Function ACCOUNT( sType As String ) As String
	Dim lAccount, lColumn, lRow As Long
	Dim oSheet, oCell As Object
	lAccount = 0.0
	On Local Error GoTo Finalize
	oSheet = ThisComponent.Sheets.getByName( "Accounts" )
	lColumn =  COLUMNFROM( FINDCELL( oSheet, "A1:AMJ1", "number" ) )
	lRow = ROWFROM( FINDCELL( oSheet, "B1:B1048576", sType ) )
	oCell = oSheet.getCellByPosition( lColumn, lRow )
	lAccount = oCell.getString( )
Finalize: 
	ACCOUNT = lAccount
End Function

REM *****************************************************************************

Function UNITVALUE( sSymbol As String ) As Double
	Dim dValue As Double
	dValue = MAPVALUE( Null, sSymbol, "Positions", "D1:D1048576", "currentPrice", true, false )
	UNITVALUE = IIF( dValue = 0.0, MAPVALUE( Null, sSymbol, "Equities", "D1:D1048576", "prevDayClosePrice", true, false ), dValue )
End Function

REM *****************************************************************************

Function UNITQTY( sAccount As String, sSymbol As String ) As Double
	UNITQTY = MAPVALUE( sAccount, sSymbol, "Positions", "D1:D1048576", "openQuantity", false, false )
End Function

REM *****************************************************************************

Function UNITCOST( sAccount As String, sSymbol As String ) As Double
	UNITCOST = MAPVALUE( sAccount, sSymbol, "Positions", "D1:D1048576", "averageEntryPrice", true, false )
End Function

REM *****************************************************************************

Function TOTALCOST( sAccount As String, sSymbol As String ) As Double
	TOTALCOST = MAPVALUE( sAccount, sSymbol, "Positions", "D1:D1048576", "totalCost", true, false )
End Function

REM *****************************************************************************

Function TOTALVALUE( sAccount As String, sSymbol As String ) As Double
	TOTALVALUE = MAPVALUE( sAccount, sSymbol, "Positions", "D1:D1048576", "currentMarketValue", true, false )
End Function

REM *****************************************************************************

Function TOTALYIELD( sSymbol As String ) As Double
	TOTALYIELD = MAPVALUE( Null, sSymbol, "Equities", "D1:D1048576", "yield", false, false ) / 100.0
End Function

REM *****************************************************************************

Function TOTALGAIN( sSymbol As String ) As Double
	TOTALGAIN = MAPVALUE( Null, sSymbol, "Positions", "D1:D1048576", "openPnl", true, true )
End Function

REM *****************************************************************************
