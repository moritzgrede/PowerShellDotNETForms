<#
.NOTES
Author: Moritz Grede
Last Edit: 2020-02-17
Version 1.0 - initial script
Version 1.1 - changed module name, added checkboxes
Version 2.0 - added radiobuttons, redid all functions with clearer parameter-statements
Version 2.1 - added inversion of booleans
Version 3.0 - added parameter sets, included layout functionality
Version 3.1 - added message, input & choice boxes
#>

# Adding .NET Framework type Forms to PowerShell
Add-Type -AssemblyName System.Windows.Forms

<#
.SYNOPSIS
Creates new color.

.DESCRIPTION
This function creates a new color based on red, green and blue integers between 0 and 255. 0 being lowest and 255 being highest.

.PARAMETER RGB
The x-coordinate (horizontal position).

.EXAMPLE
PS C:\> New-Color -RGB @(0,128,255)
PS C:\> New-Color -Red 0 -Green 128 -Blue 255
#>
Function New-Color {
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Array')][System.Object[]] $RGB,
        [Parameter(ParameterSetName = 'Single')][ValidateRange(0, 255)][Int16] $Red = 0,
        [Parameter(ParameterSetName = 'Single')][ValidateRange(0, 255)][Int16] $Green = 0,
        [Parameter(ParameterSetName = 'Single')][ValidateRange(0, 255)][Int16] $Blue = 0
    )

    # Create and return color
    Switch ( $PSCmdlet.ParameterSetName ) {
        'Array' {
            $Color = [System.Drawing.Color]::FromArgb(255, $RGB[0], $RGB[1], $RGB[2])
        }
        'Single' {
            $Color = [System.Drawing.Color]::FromArgb(255, $Red, $Green, $Blue)
        }
    }
    If ( $null -ne $Color ) { Return $Color }
    Else { Return [System.Drawing.Color]::Empty }
}

<#
.SYNOPSIS
Create new drawing point.

.DESCRIPTION
This function creates a new drawing point using two given coordinates as integers.

.PARAMETER X
X-coordinate (horizontal position).

.PARAMETER Y
Y-coordinate (vertical position).

.EXAMPLE
PS C:\> New-DrawingPoint -X 5 -Y 5
#>
Function New-DrawingPoint {
    Param (
        [Parameter(Mandatory = $true)][ValidateNotNull()][Int] $X,
        [Parameter(Mandatory = $true)][ValidateNotNull()][Int] $Y
    )

    # Create and return a system drawing point
    Return New-Object System.Drawing.Point($X,$Y)
}

<#
.SYNOPSIS
Create a new form.

.DESCRIPTION
This function creates a new form.

.PARAMETER Title
Title of the window.

.PARAMETER WindowState
State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

.PARAMETER StartPosition
Start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

.PARAMETER HideInTaskbar
Wether to hide the icon in taskbar.

.PARAMETER Height
Height of the form.

.PARAMETER Width
Width of the form.

.PARAMETER AutoSize
Wether the window should automatically resize depending on its content.

.PARAMETER Font
Default font for all later components in the form.

.PARAMETER FrontColor
Default foreground color for all later components in the form.

.EXAMPLE
PS C:\> New-Form -Title 'Form' -WindowState 'Normal' -StartPosition 'CenterScreen' -Height 200 -Width 400 -AutoSize -Font (New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Regular))
#>
Function New-Form {
    Param (
        [String] $Title = '',
        [ValidateSet('Normal', 'Maximized', 'Minimized')][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet('CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent')][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen,
        [Switch] $HideInTaskbar,
        [Int] $Height = 0,
        [Int] $Width = 0,
        [Switch] $AutoSize,
        [System.Drawing.Font] $Font = ( New-Object System.Drawing.Font( "Consolas", 12, [System.Drawing.FontStyle]::Regular ) ),
        [System.Drawing.Color] $FrontColor = [System.Drawing.Color]::BLACK
    )

    # Invert boolean
    $HideInTaskbar = -not $HideInTaskbar

    # Create form
    $Form               = New-Object System.Windows.Forms.Form
    $Form.Text          = $Title
    $Form.WindowState   = $WindowState
    $Form.StartPosition = $StartPosition
    $Form.ShowInTaskbar = $HideInTaskbar
    $Form.Height        = $Height
    $Form.Width         = $Width
    $Form.AutoSize      = $AutoSize
    $Form.Padding       = 10
    $Form.Font          = $Font
    $Form.ForeColor     = $FrontColor

    # Return created form
    Return $Form
}

<#
.SYNOPSIS
Create a new panel.

.DESCRIPTION
This function creates a new panel.

.PARAMETER X
X-coordinate (horizontal position) of the panel.

.PARAMETER Y
Y-coordinate (vertical position) of the panel.

.PARAMETER Height
Height of the panel.

.PARAMETER Width
Width of the panel.

.PARAMETER AutoSizeMode
How the panel should grow when AutoSize is enabled. Can be 'GrowAndShrink' or 'GrowOnly'

.PARAMETER AutoSize
Wether or not the panel should automatically change size depending on its content.

.PARAMETER AutoScroll
Wether to always show the scrollbar in the panel.

.PARAMETER TableLayout
Creates a TableLayoutPanel. Shorthand is New-TableLayoutPanel

.PARAMETER FlowLayout
Creates a FlowLayoutPanel. Shorthand is New-FlowLayoutPanel

.EXAMPLE
PS C:\> New-Panel -X 5 -Y 5 -Height 100 -Width 150 -AutoSizeMode 'GrowOnly' -AutoSize
PS C:\> New-Panel -AutoSize -TableLayout
PS C:\> New-Panel -AutoSize -FlowLayout
#>
Function New-Panel {
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Manual')][ValidateNotNullOrEmpty()][int] $X,
        [Parameter(Mandatory = $true, ParameterSetName = 'Manual')][ValidateNotNullOrEmpty()][int] $Y,
        [Parameter(Mandatory = $false, ParameterSetName = 'Manual')][ValidateNotNullOrEmpty()][Int] $Height = 0,
        [Parameter(Mandatory = $false, ParameterSetName = 'Manual')][ValidateNotNullOrEmpty()][Int] $Width = 0,
        [ValidateNotNull()][Int] $Padding = 0,
        [ValidateSet('GrowAndShrink', 'GrowOnly')][System.Windows.Forms.AutoSizeMode] $AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink,
        [Switch] $AutoSize,
        [Switch] $AutoScroll,
        [Parameter(Mandatory = $true, ParameterSetName = 'TableLayout')][Switch] $TableLayout,
        [Parameter(Mandatory = $true, ParameterSetName = 'FlowLayout')][Switch] $FlowLayout
    )

    # Create panel
    Switch ( $PSCmdlet.ParameterSetName ) {
        'Manual' {
            $Panel          = New-Object System.Windows.Forms.Panel
            $Panel.Location = New-DrawingPoint -X $X -Y $Y
            $Panel.Height   = $Height
            $Panel.Width    = $Width
        }

        'TableLayout' {
            $Panel      = New-Object System.Windows.Forms.TableLayoutPanel
            $Panel.Dock = [System.Windows.Forms.DockStyle]::Fill
        }

        'FlowLayout' {
            $Panel      = New-Object System.Windows.Forms.FlowLayoutPanel
            $Panel.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }

    # Set panel properties
    $Panel.AutoScroll   = $AutoScroll
    $Panel.AutoSize     = $AutoSize
    $Panel.AutoSizeMode = $AutoSizeMode
    $Panel.BorderStyle  = 'FixedSingle'
    $Panel.Padding      = $Padding

    # Return created panel
    Return $Panel
}

<#
.SYNOPSIS
Create a new panel.

.DESCRIPTION
This function creates a new table layout panel.

.PARAMETER AutoSizeMode
How the panel should grow when AutoSize is enabled. Can be 'GrowAndShrink' or 'GrowOnly'

.PARAMETER AutoSize
Wether or not the panel should automatically change size depending on its content.

.PARAMETER AutoScroll
Wether to always show the scrollbar in the panel.

.EXAMPLE
PS C:\> New-TableLayoutPanel -AutoSize
#>
Function New-TableLayoutPanel {
    Param (
        [ValidateSet('GrowAndShrink', 'GrowOnly')][System.Windows.Forms.AutoSizeMode] $AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink,
        [Switch] $AutoSize,
        [Switch] $AutoScroll
    )

    # Call panel function and return created panel
    Return ( New-Panel -TableLayout -AutoSizeMode $AutoSizeMode -AutoSize:$AutoSize -AutoScroll:$AutoScroll )
}

<#
.SYNOPSIS
Create a new panel.

.DESCRIPTION
This function creates a new flow layout panel.

.PARAMETER AutoSizeMode
How the panel should grow when AutoSize is enabled. Can be 'GrowAndShrink' or 'GrowOnly'

.PARAMETER AutoSize
Wether or not the panel should automatically change size depending on its content.

.PARAMETER AutoScroll
Wether to always show the scrollbar in the panel.

.EXAMPLE
PS C:\> New-FlowLayoutPanel -AutoSize
#>
Function New-FlowLayoutPanel {
    Param (
        [ValidateSet('GrowAndShrink', 'GrowOnly')][System.Windows.Forms.AutoSizeMode] $AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink,
        [Switch] $AutoSize,
        [Switch] $AutoScroll
    )

    # Call panel function and return created panel
    Return ( New-Panel -FlowLayout -AutoSizeMode $AutoSizeMode -AutoSize:$AutoSize -AutoScroll:$AutoScroll )
}

<#
.SYNOPSIS
Create a new label.

.DESCRIPTION
This function creates a new label.

.PARAMETER X
X-coordinate (horizontal position) of the label.

.PARAMETER Y
Y-coordinate (vertical position) of the label.

.PARAMETER Text
Text to be displayed.

.PARAMETER Height
Height of the label.

.PARAMETER Width
Width of the label.

.PARAMETER FrontColor
Foreground color of the label.

.PARAMETER BackColor
Background color of the label.

.PARAMETER Align
Where to align the labels content. Can be 'Top', 'Middle' or 'Bottom' directly followed by 'Left', 'Center' or 'Right'. First defines vertical position, second horizontal.

.PARAMETER AutoSize
Wether or not the label should automatically change size depending on its content.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-Label -X 5 -Y 5 -Text 'Label' -Height 20 -Width 100 -FrontColor 'BLACK' -Align 'MiddleLeft'
#>
Function New-Label {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [Parameter(Mandatory = $true)][ValidateNotNull()][String] $Text,
        [Int] $Height = 0,
        [Int] $Width = 0,
        [String] $FrontColor = $null,
        [String] $BackColor = $null,
        [ValidateSet( 'TopLeft', 'TopCenter', 'TopRight', 'MiddleLeft', 'MiddleCenter', 'MiddleRight', 'BottomLeft', 'BottomCenter', 'BottomRight' )][System.Drawing.ContentAlignment] $Align = [System.Drawing.ContentAlignment]::MiddleLeft,
        [Switch] $AutoSize,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Create label
    $Label              = New-Object System.Windows.Forms.Label
    $Label.AutoSize     = $AutoSize
    $Label.BackColor    = $BackColor
    $Label.ForeColor    = $FrontColor
    $Label.Height       = $Height
    $Label.Location     = New-DrawingPoint -X $X -Y $Y
    $Label.Text         = $Text
    $Label.TextAlign    = $Align
    $Label.Width        = $Width

    # Return created label
    Return $Label
}

<#
.SYNOPSIS
Create a new textbox.

.DESCRIPTION
This function creates a new textbox.

.PARAMETER X
X-coordinate (horizontal position) of the textbox.

.PARAMETER Y
Y-coordinate (vertical position) of the textbox.

.PARAMETER Text
Text to be displayed in the textbox.

.PARAMETER Height
Height of the textbox.

.PARAMETER Width
Width of the textbox.

.PARAMETER FrontColor
Foreground color of the textbox.

.PARAMETER BackColor
Background color of the textbox.

.PARAMETER Align
Where to align the textboxes content. Can be 'Top', 'Middle' or 'Bottom' directly followed by 'Left', 'Center' or 'Right'. First defines vertical position, second defines horizontal.

.PARAMETER Disabled
Disables the textbox.

.PARAMETER ReadOnly
Textbox will not be editable.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-TextBox -X 5 -Y 5 -Height 20 -Width 150 -FrontColor 'BLACK' -Align 'MiddleLeft'
#>
Function New-TextBox {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [String] $Text = '',
        [Int] $Height = 0,
        [Int] $Width = 0,
        [System.Drawing.Color] $FrontColor = [System.Drawing.Color]::Empty,
        [System.Drawing.Color] $BackColor = [System.Drawing.Color]::Empty,
        [ValidateSet('TopLeft','TopCenter','TopRight','MiddleLeft','MiddleCenter','MiddleRight','BottomLeft','BottomCenter','BottomRight')][System.Windows.Forms.HorizontalAlignment] $Align = [System.Windows.Forms.HorizontalAlignment]::Left,
        [Switch] $Disabled,
        [Switch] $ReadOnly,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create textbox
    $Textbox            = New-Object System.Windows.Forms.TextBox
    $Textbox.BackColor  = $BackColor
    $Textbox.Dock       = [System.Windows.Forms.DockStyle]::Fill
    $Textbox.Enabled    = $Disabled
    $Textbox.ForeColor  = $FrontColor
    $Textbox.Height     = $Height
    $Textbox.Location   = New-DrawingPoint -X $X -Y $Y
    $Textbox.ReadOnly   = $ReadOnly
    $Textbox.Text       = $Text
    $Textbox.TextAlign  = $Align
    $Textbox.Width      = $Width
    
    # Return created textbox
    Return $Textbox
}

<#
.SYNOPSIS
Create a new button.

.DESCRIPTION
This function creates a new button.

.PARAMETER X
X-coordinate (horizontal position) of the button.

.PARAMETER Y
Y-coordinate (vertical position) of the button.

.PARAMETER Text
Text to be displayed in the button.

.PARAMETER Height
Height of the button.

.PARAMETER Width
Width of the button.

.PARAMETER Disabled
Disables the button.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-Button -X 5 -Y 5 -Text 'Button' -Height 20 -Width 100
#>
Function New-Button {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [String] $Text = '',
        [Int] $Height = 0,
        [Int] $Width = 0,
        [Switch] $Disabled,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create the button
    $Button             = New-Object System.Windows.Forms.Button
    $Button.Dock        = [System.Windows.Forms.DockStyle]::Fill
    $Button.Enabled     = $Disabled
    $Button.Height      = $Height
    $Button.Location    = New-DrawingPoint -X $X -Y $Y
    $Button.Text        = $Text
    $Button.Width       = $Width
    
    # Return the button
    Return $Button
}

<#
.SYNOPSIS
Create a new listbox.

.DESCRIPTION
This function creates a new listbox.

.PARAMETER X
X-coordinate (horizontal position) of the listbox.

.PARAMETER Y
Y-coordinate (vertical position) of the listbox.

.PARAMETER Height
Height of the listbox.

.PARAMETER Width
Width of the listbox.

.PARAMETER ColWidth
Width of the displayed column(s).

.PARAMETER SelectionMode
Can be 'MultiExtended' (multiple may be selected, modifier keys CTRL & SHIFT may be used), 'MultiSimple' (multiple may be selected), 'None' (nothing can be selected) or 'One' (one item may be selected).

.PARAMETER Disabled
Disables the listbox.

.PARAMETER AutoSize
Adjust the listboxes size depending on its content.

.PARAMETER Sorted
Sort the listbox.

.PARAMETER MultiCol
Allow multiple columns.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-ListBox -X 5 -Y 5 -Height 300 -Width 200 -ColWidth 100 -SelectionMode 'One' -AutoSize -Sorted -MultiCol
#>
Function New-ListBox {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [Int] $Height = 0,
        [Int] $Width = 0,
        [Int] $ColWidth = $Width,
        [ValidateSet('MultiExtended','MultiSimple','None','One')][System.Windows.Forms.SelectionMode] $SelectionMode = [System.Windows.Forms.SelectionMode]::One,
        [Switch] $Disabled,
        [Switch] $AutoSize,
        [Switch] $Sorted,
        [Switch] $MultiCol,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create listbox
    $ListBox                = New-Object System.Windows.Forms.ListBox
    $ListBox.AutoSize       = $AutoSize
    $ListBox.ColumnWidth    = $ColWidth
    $ListBox.Dock           = [System.Windows.Forms.DockStyle]::Fill
    $ListBox.Enabled        = $Disabled
    $ListBox.Height         = $Height
    $ListBox.Location       = New-DrawingPoint -X $X -Y $Y
    $ListBox.MultiColumn    = $MultiCol
    $ListBox.SelectionMode  = $SelectionMode
    $ListBox.Sorted         = $Sorted
    $ListBox.Width          = $Width

    # Return created listbox
    Return $ListBox
}

<#
.SYNOPSIS
Create a new dropdown.

.DESCRIPTION
This function creates a new dropdown.

.PARAMETER X
X-coordinate (horizontal position) of the dropdown.

.PARAMETER Y
Y-coordinate (vertical position) of the dropdown.

.PARAMETER Height
Height of the dropdown.

.PARAMETER Width
Width of the dropdown.

.PARAMETER MaxDropItems
Amount of items to display when dropped down.

.PARAMETER AutoSize
Automatically adjust the dropdowns size depending on its content.

.PARAMETER Disabled
Disables the dropdown list.

.PARAMETER Sorted
Sort the dropdown items.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-Dropdown -X 5 -Y 5 -Height 20 -Width 200 -DropHeight 100 -DropWidth 300 -ItemHeight 20 -MaxDropItems 10 -Sorted
#>
Function New-Dropdown {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [Int] $Height = 0,
        [Int] $Width = 0,
        [Int] $MaxDropItems = 1,
        [Switch] $AutoSize,
        [Switch] $Disabled,
        [Switch] $Sorted,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create dropdown
    $Dropdown                   = New-Object System.Windows.Forms.ComboBox
    $Dropdown.AutoSize          = $AutoSize
    $Dropdown.Dock              = [System.Windows.Forms.DockStyle]::Fill
    $Dropdown.Enabled           = $Disabled
    $Dropdown.Height            = $Height
    $Dropdown.Location          = New-DrawingPoint -X $X -Y $Y
    $Dropdown.MaxDropDownItems  = $MaxDropItems
    $Dropdown.Sorted            = $Sorted
    $Dropdown.Width             = $Width

    # Return created dropdown
    Return $Dropdown
}

<#
.SYNOPSIS
Create a new checkbox.

.DESCRIPTION
This function creates a new checkbox.

.PARAMETER X
X-coordinate (horizontal position) of the radio button.

.PARAMETER Y
Y-coordinate (vertical position) of the radio button.

.PARAMETER Text
Text to be displayed behind the radio button.

.PARAMETER Height
Height of the radio button.

.PARAMETER Width
Width of the radio button.

.PARAMETER Checked
Checkbox is initially checked.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-Checkbox -X 5 -Y 5 -Text 'Box' -Height 20 -Width 200 -Checked
#>
Function New-Checkbox {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [String] $Text = '',
        [Int] $Height = 0,
        [Int] $Width = 0,
        [Switch] $Checked,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Create checkbox
    $Checkbox           = New-Object System.Windows.Forms.CheckBox
    $Checkbox.Checked   = $Checked
    $Checkbox.Dock      = [System.Windows.Forms.DockStyle]::Fill
    $Checkbox.Height    = $Height
    $Checkbox.Location  = New-DrawingPoint -X $X -Y $Y
    $Checkbox.Text      = $Text
    $Checkbox.Width     = $Width

    # Return checkbox
    Return $Checkbox
}

<#
.SYNOPSIS
Create a new radio button.

.DESCRIPTION
This function creates a new radio button.

.PARAMETER X
X-coordinate (horizontal position) of the radio button.

.PARAMETER Y
Y-coordinate (vertical position) of the radio button.

.PARAMETER Text
Text to be displayed behind the radio button.

.PARAMETER Height
Height of the radio button.

.PARAMETER Width
Width of the radio button.

.PARAMETER Checked
Radio button is initally checked.

.PARAMETER Disabled
Disables the radio button.

.PARAMETER AutoSize
Automatically adjust the radio buttons size depending on the content.

.PARAMETER Dock
If in a Table- or FlowLayoutPanel, where to dock the label to.

.EXAMPLE
PS C:\> New-RadioButton -X 5 -Y 5 -Text 'Button' -Height 20 -Width 200 -Checked -AutoSize
#>
Function New-RadioButton {
    Param (
        [Int] $X = 0,
        [Int] $Y = 0,
        [String] $Text = '',
        [Int] $Height = 0,
        [Int] $Width = 0,
        [Switch] $Checked,
        [Switch] $Disabled,
        [Switch] $AutoSize,
        [ValidateSet( 'Bottom', 'Fill', 'Left', 'None', 'Right', 'Top' )][System.Windows.Forms.DockStyle] $Dock = [System.Windows.Forms.DockStyle]::Fill
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create radio button
    $Radio              = New-Object System.Windows.Forms.RadioButton
    $Radio.AutoSize     = $AutoSize
    $Radio.Checked      = $Checked
    $Radio.Dock         = [System.Windows.Forms.DockStyle]::Fill
    $Radio.Enabled      = $Disabled
    $Radio.Height       = $Height
    $Radio.Location     = New-DrawingPoint -X $X -Y $Y
    $Radio.Text         = $Text
    $Radio.Width        = $Width

    # Return radio button
    Return $Radio
}

<#
.SYNOPSIS
Create a message box.

.DESCRIPTION
This function creates a message box.

.PARAMETER Title
Title of the message window.

.PARAMETER Message
Message to be displayed.

.PARAMETER ButtonText
Text to be displayed in the confirmation button.

.PARAMETER WindowState
State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

.PARAMETER StartPosition
Start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

.PARAMETER HideInTaskbar
Hide the icon in taskbar.

.EXAMPLE
PS C:\> New-MsgBox -Title 'Information' -Message 'Information message' -ButtonText 'Ok' -HideInTaskbar 
#>
Function New-MsgBox {
    Param (
        [String] $Title = '',
        [String] $Message = '',
        [String] $ButtonText = 'Ok',
        [ValidateSet( 'Normal', 'Maximized', 'Minimized' )][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet( 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent' )][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,
        [Switch] $HideInTaskbar
    )

    # Create form
    $Form           = New-Form -Title $Title -WindowState $WindowState -StartPosition $StartPosition -AutoSize -HideInTaskbar:$HideInTaskbar
    $Form.Padding   = 0

    # Create TableLayoutPanel
    $Panel              = New-TableLayoutPanel -AutoSize
    $Panel.GrowStyle    = [System.Windows.Forms.TableLayoutPanelGrowStyle]::AddRows
    $Panel.Dock         = [System.Windows.Forms.DockStyle]::Fill

    # Create textfield for message
    $Text           = New-TextBox -Text $Message -ReadOnly
    $Text.AutoSize  = $true
    $Text.MultiLine = $true
    $Text.Dock      = [System.Windows.Forms.DockStyle]::Fill
    $Panel.Controls.Add( $Text )

    # Create button
    $Button = New-Button -Text $ButtonText
    #$Button.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom
    $Button.Add_Click( { $this.Parent.Parent.Close()})
    $Panel.Controls.Add( $Button )
    $Form.AcceptButton = $Button

    $Form.Controls.Add($Panel)

    # Layout operations
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Percent, 100 ) ) ) > $null
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::AutoSize ) ) ) > $null

    # Return created form
    Return $Form
}

<#
.SYNOPSIS
Creates an input box.

.DESCRIPTION
This function creates an input box.

.PARAMETER Title
Title of the window.

.PARAMETER Message
Message to be displayed.

.PARAMETER ButtonText
Text to be displayed in the confirmation button.

.PARAMETER WindowState
State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

.PARAMETER StartPosition
Start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

.PARAMETER HideInTaskbar
Hides the icon in taskbar.

.EXAMPLE
PS C:\> New-InputBox -Title 'Input' -Message 'Input message' -ButtonText 'Ok' -HideInTaskbar 
#>
Function New-InputBox {
    Param (
        [String] $Title = '',
        [String] $Message = '',
        [String] $ButtonText = 'Ok',
        [ValidateSet( 'Normal', 'Maximized', 'Minimized' )][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet( 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent' )][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,
        [Switch] $HideInTaskbar
    )

    # Create form
    $Form           = New-Form -Title $Title -WindowState $WindowState -StartPosition $StartPosition -AutoSize -HideInTaskbar:$HideInTaskbar
    $Form.Padding   = 0

    # Create TableLayoutPanel
    $Panel              = New-TableLayoutPanel -AutoSize
    $Panel.GrowStyle    = [System.Windows.Forms.TableLayoutPanelGrowStyle]::AddRows

    # Create textbox for message
    $Text           = New-TextBox -Text $Message -AutoSize -ReadOnly
    $Text.MultiLine = $true
    $Text.Name      = 'Message'
    $Panel.Controls.Add( $Text) 

    # Create textfield for input
    $Input          = New-TextBox -AutoSize
    $Input.Name     = 'Input'
    $Panel.Controls.Add( $Input )

    # Create button
    $Button = New-Button -Text $ButtonText -AutoSize
    $Button.Add_Click( { $this.Parent.Controls | ForEach-Object { If ( 'Input' -eq $_.Name ) { $_.Text } }; $this.Parent.Parent.Close() } )
    $Panel.Controls.Add( $Button )
    $Form.AcceptButton = $Button

    $Form.Controls.Add( $Panel )

    # Layout operations
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Percent, 100 ) ) ) | Out-Null
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Absolute, 25 ) ) ) | Out-Null
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Absolute, 30 ) ) ) | Out-Null

    # Return created form
    Return $Form
}

<#
.SYNOPSIS
Create a choice box.

.DESCRIPTION
This function creates a choice box.

.PARAMETER Title
Title of the window.

.PARAMETER Message
Message to be displayed.

.PARAMETER ButtonConfirm
Text to be displayed in the confirmation button.

.PARAMETER ButtonDeny
Text to be displayed in the deny button.

.PARAMETER WindowState
State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

.PARAMETER StartPosition
Start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

.PARAMETER HideInTaskbar
Hides the icon in taskbar.

.EXAMPLE
PS C:\> New-ChoiceBox -Title 'Choice' -Message 'Choice message' -ButtonConfirmation 'Yes' -HideInTaskbar 
#>
Function New-ChoiceBox {
    Param (
        [String] $Title = '',
        [String] $Message = '',
        [String] $ButtonConfirm = 'Yes',
        [String] $ButtonDeny = 'No',
        [ValidateSet('Normal', 'Maximized', 'Minimized')][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet('CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent')][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,
        [Switch] $HideInTaskbar
    )

    # Create form
    $Form           = New-Form -Title $Title -WindowState $WindowState -StartPosition $StartPosition -AutoSize -HideInTaskbar:$HideInTaskbar
    $Form.Padding   = 0

    # Create TableLayoutPanel
    $Panel              = New-TableLayoutPanel -AutoSize
    $Panel.ColumnCount  = 2
    $Panel.GrowStyle    = [System.Windows.Forms.TableLayoutPanelGrowStyle]::AddRows
    $Panel.Dock         = [System.Windows.Forms.DockStyle]::Fill

    # Create textfield for message
    $Text           = New-TextBox -Text $Message -ReadOnly
    $Text.AutoSize  = $true
    $Text.MultiLine = $true
    $Panel.Controls.Add( $Text )

    # Create confirmation button
    $Confirm = New-Button -Text $ButtonConfirm
    $Confirm.Add_Click( { 'Accept'; $this.Parent.Close() } )
    $Panel.Controls.Add( $Confirm )
    $Form.AcceptButton = $Confirm

    # Create deny button
    $Deny = New-Button -Text $ButtonDeny
    $Deny.Add_Click( { $this.Parent.Close() } )
    $Panel.Controls.Add( $Deny )
    $Form.CancelButton = $Deny

    $Form.Controls.Add($Panel)

    # Layout operations
    $Panel.SetColumnSpan( $Text, 2 )
    $Panel.ColumnStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Percent, 50 ) ) ) > $null
    $Panel.ColumnStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Percent, 50 ) ) ) > $null
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::Percent, 100 ) ) ) > $null
    $Panel.RowStyles.Add( ( New-Object System.Windows.Forms.RowStyle( [System.Windows.Forms.SizeType]::AutoSize ) ) ) > $null

    # Return created form
    Return $Form
}