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

Function New-Color {
    <#
    .SYNOPSIS
    This function creates a new drawing point.

    .DESCRIPTION
    This function creates a new drawing point.

    .PARAMETER X
    The x-coordinate (horizontal position).

    .PARAMETER Y
    The y-coordinate (vertical position).

    .EXAMPLE
    PS C:\> New-DrawingPoint -X 5 -Y 5
    #>

    Param (
        [Parameter(Mandatory=$true)][System.Object[]] $RGB
    )

    # Create and return color
    If ($null -eq $RGB) {Return [System.Drawing.Color]::FromArgb(255,$RGB[0],$RGB[1],$RGB[2])}
    Else {Return [System.Drawing.Color]::Empty}
}

Function New-DrawingPoint {
    <#
    .SYNOPSIS
    This function creates a new drawing point.

    .DESCRIPTION
    This function creates a new drawing point.

    .PARAMETER X
    The x-coordinate (horizontal position).

    .PARAMETER Y
    The y-coordinate (vertical position).

    .EXAMPLE
    PS C:\> New-DrawingPoint -X 5 -Y 5
    #>

    Param (
        [Parameter(Mandatory=$true)][ValidateNotNull()][Int] $X,
        [Parameter(Mandatory=$true)][ValidateNotNull()][Int] $Y
    )

    # Create and return a system drawing point
    Return New-Object System.Drawing.Point($X,$Y)
}

Function New-Form {
    <#
    .SYNOPSIS
    This function creates a new form.

    .DESCRIPTION
    This function creates a new form.

    .PARAMETER Title
    Sets the desired title of the window.

    .PARAMETER WindowState
    State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

    .PARAMETER StartPosition
    Sets the start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

    .PARAMETER HideInTaskbar
    Wether to hide the icon in taskbar.

    .PARAMETER height
    The height of the window.

    .PARAMETER Width
    The width of the window.

    .PARAMETER AutoSize
    Wether the window should automatically resize depending on its content.

    .PARAMETER Font
    Set the default font for all later components in the window.

    .PARAMETER FrontColor
    Set the default foreground color for all later components in the window.

    .EXAMPLE
    PS C:\> New-Form -Title 'Form' -WindowState 'Normal' -StartPosition 'CenterScreen' -Height 200 -Width 400 -AutoSize -Font (New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Regular))
    #>

    Param (
        [ValidateNotNull()][String] $Title = '',
        [ValidateSet('Normal', 'Maximized', 'Minimized')][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet('CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent')][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen,
        [Switch] $HideInTaskbar,
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][Int] $Width,
        [Switch] $AutoSize,
        [ValidateNotNull()][System.MarshalByRefObject] $Font = (New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Regular)),
        [ValidateNotNull()][String] $FrontColor = 'BLACK'
    )

    # Invert booleans
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

Function New-Panel {
    <#
    .SYNOPSIS
    This function creates a new panel.

    .DESCRIPTION
    This function creates a new panel.

    .PARAMETER X
    The x-coordinate (horizontal position) of the panel.

    .PARAMETER Y
    The y-coordinate (vertical position) of the panel.

    .PARAMETER Height
    The height of the panel.

    .PARAMETER Width
    The width of the panel.

    .PARAMETER AutoSizeMode
    Defines how the panel should grow when AutoSize is enabled. Can be 'GrowAndShrink' or 'GrowOnly'

    .PARAMETER AutoSize
    Wether or not the panel should automatically change size depending on its content.

    .PARAMETER AutoScroll
    Wether to always show the scrollbar in the panel.

    .PARAMETER TableLayout
    Wether to create a TableLayoutPanel or a "normal" Panel

    .EXAMPLE
    PS C:\> New-Panel -X 5 -Y 5 -Height 100 -Width 150 -AutoSizeMode 'GrowOnly' -AutoSize
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][int] $Y,
        [Parameter(Mandatory=$false, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Height = 0,
        [Parameter(Mandatory=$false, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Width = 0,
        [ValidateNotNull()][Int] $Padding = 0,
        [ValidateSet('GrowAndShrink', 'GrowOnly')][System.Windows.Forms.AutoSizeMode] $AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink,
        [Switch] $AutoSize,
        [Switch] $AutoScroll,
        [Parameter(Mandatory=$true, ParameterSetName='TableLayout')][Switch] $TableLayout
    )

    # Create panel, but differ depending on the parameter set specified
    Switch ($PSCmdlet.ParameterSetName) {
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
    }

    # Set panel properties that always apply
    $Panel.AutoScroll   = $AutoScroll
    $Panel.AutoSize     = $AutoSize
    $Panel.AutoSizeMode = $AutoSizeMode
    $Panel.BorderStyle  = 'FixedSingle'
    $Panel.Padding      = $Padding

    # Return created panel
    Return $Panel
}

Function New-Label {
    <#
    .SYNOPSIS
    This function creates a new label.

    .DESCRIPTION
    This function creates a new label.

    .PARAMETER X
    The x-coordinate (horizontal position) of the label.

    .PARAMETER Y
    The y-coordinate (vertical position) of the label.

    .PARAMETER Text
    The text to be displayed as the label.

    .PARAMETER Height
    The height of the label.

    .PARAMETER Width
    The width of the label.

    .PARAMETER FrontColor
    The foreground color of the label.

    .PARAMETER BackColor
    The background color of the label.

    .PARAMETER Align
    Where to align the labels content. Can be 'Top', 'Middle' or 'Bottom' directly followed by 'Left', 'Center' or 'Right'. First defines vertical position, second defines horizontal.

    .EXAMPLE
    PS C:\> New-Label -X 5 -Y 5 -Text 'Label' -Height 20 -Width 100 -FrontColor 'BLACK' -Align 'MiddleLeft'
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Y,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$true, ParameterSetName='TableLayout')][ValidateNotNull()][String] $Text,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Width,
        [String] $FrontColor = $null,
        [String] $BackColor = $null,
        [ValidateSet('TopLeft','TopCenter','TopRight','MiddleLeft','MiddleCenter','MiddleRight','BottomLeft','BottomCenter','BottomRight')][System.Drawing.ContentAlignment] $Align = [System.Drawing.ContentAlignment]::MiddleLeft
    )

    # Create label
    $Label              = New-Object System.Windows.Forms.Label
    $Label.Text         = $Text
    $Label.ForeColor    = $FrontColor
    $Label.BackColor    = $BackColor
    $Label.TextAlign    = $Align

    # If in "Manual" parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $Label.Location     = New-DrawingPoint -X $X -Y $Y
            $Label.Height       = $Height
            $Label.Width        = $Width
        }

        'TableLayout' {
            $Label.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }

    # Return created label
    Return $Label
}

Function New-TextBox {
    <#
    .SYNOPSIS
    This function creates a new textbox.

    .DESCRIPTION
    This function creates a new textbox.

    .PARAMETER X
    The x-coordinate (horizontal position) of the textbox.

    .PARAMETER Y
    The y-coordinate (vertical position) of the textbox.

    .PARAMETER Text
    The text to be displayed in the textbox.

    .PARAMETER Height
    The height of the textbox.

    .PARAMETER Width
    The width of the textbox.

    .PARAMETER FrontColor
    The foreground color of the textbox.

    .PARAMETER BackColor
    The background color of the textbox.

    .PARAMETER Align
    Where to align the textboxes content. Can be 'Top', 'Middle' or 'Bottom' directly followed by 'Left', 'Center' or 'Right'. First defines vertical position, second defines horizontal.

    .PARAMETER Disabled
    Wether to disable the textbox upon creation.

    .EXAMPLE
    PS C:\> New-TextBox -X 5 -Y 5 -Height 20 -Width 150 -FrontColor 'BLACK' -Align 'MiddleLeft'
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Y,
        [String] $Text = '',
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Width,
        [ValidateNotNull()][String] $FrontColor = $null,
        [String] $BackColor = $null,
        [ValidateSet('TopLeft','TopCenter','TopRight','MiddleLeft','MiddleCenter','MiddleRight','BottomLeft','BottomCenter','BottomRight')][System.Windows.Forms.HorizontalAlignment] $Align = [System.Windows.Forms.HorizontalAlignment]::Left,
        [Switch] $Disabled,
        [Switch] $ReadOnly
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create textbox
    $Textbox            = New-Object System.Windows.Forms.TextBox
    $Textbox.Text       = $Text
    $Textbox.ForeColor  = $FrontColor
    $Textbox.BackColor  = $BackColor
    $Textbox.TextAlign  = $Align
    $Textbox.Enabled    = $Disabled
    $Textbox.ReadOnly   = $ReadOnly

    # Depending on the parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $Textbox.Location   = New-DrawingPoint -X $X -Y $Y
            $Textbox.Height     = $Height
            $Textbox.Width      = $Width
        }

        'TableLayout' {
            $Textbox.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }
    
    # Return created textbox
    Return $Textbox
}

Function New-Button {
    <#
    .SYNOPSIS
    This function creates a new button.

    .DESCRIPTION
    This function creates a new button.

    .PARAMETER X
    The x-coordinate (horizontal position) of the button.

    .PARAMETER Y
    The y-coordinate (vertical position) of the button.

    .PARAMETER Text
    The text to be displayed in the button.

    .PARAMETER Height
    The height of the button.

    .PARAMETER Width
    The width of the button.

    .PARAMETER Disabled
    Wether the button should be disabled upon creation.
    
    .EXAMPLE
    PS C:\> New-Button -X 5 -Y 5 -Text 'Button' -Height 20 -Width 100
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Y,
        [String] $Text = '',
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Width,
        [Switch] $Disabled
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create the button
    $Button             = New-Object System.Windows.Forms.Button
    $Button.Text        = $Text
    $Button.Enabled     = $Disabled

    # Depending on the parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $Button.Location    = New-DrawingPoint -X $X -Y $Y
            $Button.Height      = $Height
            $Button.Width       = $Width
        }

        'TableLayout' {
            $Button.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }
    
    # Return the button
    Return $Button
}

Function New-ListBox {
    <#
    .SYNOPSIS
    This function creates a new listbox.

    .DESCRIPTION
    This function creates a new listbox.

    .PARAMETER X
    The x-coordinate (horizontal position) of the listbox.

    .PARAMETER Y
    The y-coordinate (vertical position) of the listbox.

    .PARAMETER Height
    The height of the listbox.

    .PARAMETER Width
    The width of the listbox.

    .PARAMETER ColWidth
    The width of the displayed column(s).

    .PARAMETER SelectionMode
    The mode of selection. Can be 'MultiExtended' (multiple may be selected, modifier keys CTRL & SHIFT may be used), 'MultiSimple' (multiple may be selected), 'None' (nothing can be selected) or 'One' (one item may be selected)

    .PARAMETER Disabled
    Wether to disable the listbox upon creation.

    .PARAMETER AutoSize
    Wether to automatically adjust the listboxes size depending on its content.

    .PARAMETER Sorted
    Wether to sort the listbox.

    .PARAMETER MultiCol
    Wether to allow multiple columns.

    .EXAMPLE
    PS C:\> New-ListBox -X 5 -Y 5 -Height 300 -Width 200 -ColWidth 100 -SelectionMode 'One' -AutoSize -Sorted -MultiCol
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Y,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Width,
        [ValidateNotNull()][Int] $ColWidth = $Width,
        [ValidateSet('MultiExtended','MultiSimple','None','One')][System.Windows.Forms.SelectionMode] $SelectionMode = [System.Windows.Forms.SelectionMode]::One,
        [Switch] $Disabled,
        [Switch] $AutoSize,
        [Switch] $Sorted,
        [Switch] $MultiCol,
        [Parameter(Mandatory=$false, ParameterSetName='TableLayout')][Switch] $TableLayout
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create listbox
    $ListBox                = New-Object System.Windows.Forms.ListBox
    $ListBox.AutoSize       = $AutoSize
    $ListBox.ColumnWidth    = $ColWidth
    $ListBox.Enabled        = $Disabled
    $ListBox.MultiColumn    = $MultiCol
    $ListBox.SelectionMode  = $SelectionMode
    $ListBox.Sorted         = $Sorted

    # Depending on the parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $ListBox.Location       = New-DrawingPoint -X $X -Y $Y
            $ListBox.Height         = $Height
            $ListBox.Width          = $Width
        }

        'TableLayout' {
            $ListBox.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }

    # Return created listbox
    Return $ListBox
}

Function New-Dropdown {
    <#
    .SYNOPSIS
    This function creates a new dropdown.

    .DESCRIPTION
    This function creates a new dropdown.

    .PARAMETER X
    The x-coordinate (horizontal position) of the dropdown.

    .PARAMETER Y
    The y-coordinate (vertical position) of the dropdown.

    .PARAMETER Height
    The height of the dropdown.

    .PARAMETER Width
    The width of the dropdown.

    .PARAMETER DropHeight
    The height of the dropdown list.

    .PARAMETER DropWidth
    The width of the dropdown list.

    .PARAMETER ItemHeight
    The height of the items in the dropdown list.

    .PARAMETER MaxDropItems
    The amount of items to display when dropped down.

    .PARAMETER AutoSize
    Wether to automatically adjust the dropdowns size depending on its content.

    .PARAMETER Disabled
    Wether to disable the created dropdown upon creation.

    .PARAMETER Sorted
    Wether to sort the dropdown items.

    .EXAMPLE
    PS C:\> New-Dropdown -X 5 -Y 5 -Height 20 -Width 200 -DropHeight 100 -DropWidth 300 -ItemHeight 20 -MaxDropItems 10 -Sorted
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Y,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][Parameter(Mandatory=$false, ParameterSetName='TableLayout')][ValidateNotNullOrEmpty()][Int] $Width,
        [ValidateNotNull()][Int] $MaxDropItems = 10,
        [Switch] $AutoSize,
        [Switch] $Disabled,
        [Switch] $Sorted,
        [Parameter(Mandatory=$true, ParameterSetName='TableLayout')][Switch] $TableLayout
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create dropdown
    $Dropdown                   = New-Object System.Windows.Forms.ComboBox
    $Dropdown.AutoSize          = $AutoSize
    $Dropdown.Enabled           = $Disabled
    $Dropdown.MaxDropDownItems  = $MaxDropItems
    $Dropdown.Sorted            = $Sorted
    
    # Depending on the parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $Dropdown.Location  = New-DrawingPoint -X $X -Y $Y
            $Dropdown.Height    = $Height
            $Dropdown.Width     = $Width
        }

        'TableLayout' {
            $Dropdown.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }

    # Return created dropdown
    Return $Dropdown
}

Function New-Checkbox {
    <#
    .SYNOPSIS
    This function creates a new checkbox.

    .DESCRIPTION
    This function creates a new checkbox.

    .PARAMETER X
    The x-coordinate (horizontal position) of the radio button.

    .PARAMETER Y
    The y-coordinate (vertical position) of the radio button.

    .PARAMETER Text
    The text to be displayed behind the radio button.

    .PARAMETER Height
    The height of the radio button.

    .PARAMETER Width
    The width of the radio button.

    .PARAMETER Checked
    Wether the checkbox should initially be checked.

    .EXAMPLE
    PS C:\> New-Checkbox -X 5 -Y 5 -Text 'Box' -Height 20 -Width 200 -Checked
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Y,
        [Parameter(ParameterSetName='Manual')][Parameter(ParameterSetName='TableLayout')][String] $Text = '',
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Width,
        [Switch] $Checked

    )

    # Create checkbox
    $Checkbox           = New-Object System.Windows.Forms.CheckBox
    $Checkbox.Checked   = $Checked
    $Checkbox.Text      = $Text
    
    # Depending on the parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $Checkbox.Location  = New-DrawingPoint -X $X -Y $Y
            $Checkbox.Height    = $Height
            $Checkbox.Width     = $Width
        }

        'TableLayout' {
            $Checkbox.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }

    # Return checkbox
    Return $Checkbox
}

Function New-RadioButton {
    <#
    .SYNOPSIS
    This function creates a new radio button.

    .DESCRIPTION
    This function creates a new radio button.

    .PARAMETER X
    The x-coordinate (horizontal position) of the radio button.

    .PARAMETER Y
    The y-coordinate (vertical position) of the radio button.

    .PARAMETER Text
    The text to be displayed behind the radio button.

    .PARAMETER Height
    The height of the radio button.

    .PARAMETER Width
    The width of the radio button.

    .PARAMETER Checked
    Wether or not the radio button should initally be checked.

    .PARAMETER Disabled
    Wether or not the radio button should be disabled on creation.

    .PARAMETER AutoSize
    Wether the radio button should automatically adjust its size depending on the content.

    .EXAMPLE
    PS C:\> New-RadioButton -X 5 -Y 5 -Text 'Button' -Height 20 -Width 200 -Checked -AutoSize
    #>

    Param (
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $X,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Y,
        [Parameter(ParameterSetName='Manual')][Parameter(ParameterSetName='TableLayout')][String] $Text = '',
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Height,
        [Parameter(Mandatory=$true, ParameterSetName='Manual')][ValidateNotNullOrEmpty()][Int] $Width,
        [Switch] $Checked,
        [Switch] $Disabled,
        [Switch] $AutoSize
    )

    # Invert booleans
    $Disabled = -not $Disabled

    # Create radio button
    $Radio              = New-Object System.Windows.Forms.RadioButton
    $Radio.AutoSize     = $AutoSize
    $Radio.Checked      = $Checked
    $Radio.Enabled      = $Disabled
    $Radio.Text         = $Text
    
    # Depending on the parameter set, also set these properties
    Switch ($PSCmdlet.ParameterSetName) {
        'Manual' {
            $Radio.Location     = New-DrawingPoint -X $X -Y $Y
            $Radio.Height       = $Height
            $Radio.Width        = $Width
        }

        'TableLayout' {
            $Radio.Dock = [System.Windows.Forms.DockStyle]::Fill
        }
    }

    # Return radio button
    Return $Radio
}

Function New-MsgBox {
    <#
    .SYNOPSIS
    This function creates a message box.

    .DESCRIPTION
    This function creates a message box.

    .PARAMETER Title
    Title of the message window.

    .PARAMETER Message
    The message to be displayed.

    .PARAMETER ButtonText
    The text to be displayed in the confirmation button.

    .PARAMETER WindowState
    State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

    .PARAMETER StartPosition
    Sets the start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

    .PARAMETER HideInTaskbar
    Wether to hide the icon in taskbar.

    .EXAMPLE
    PS C:\> New-MsgBox -Title 'Information' -Message 'Information message' -ButtonText 'Ok' -HideInTaskbar 
    #>

    Param (
        [String] $Title = '',
        [String] $Message = '',
        [String] $ButtonText = 'Ok',
        [ValidateSet('Normal', 'Maximized', 'Minimized')][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet('CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent')][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,
        [Switch] $HideInTaskbar
    )

    # Create form
    $Form = New-Form -Title $Title -WindowState $WindowState -StartPosition $StartPosition -Height 50 -Width 200 -AutoSize -HideInTaskbar:$HideInTaskbar
    $Form.Padding = 0

    # Create TableLayoutPanel
    $Panel = New-Panel -TableLayout -AutoSize
    $Panel.GrowStyle = [System.Windows.Forms.TableLayoutPanelGrowStyle]::AddRows
    $Panel.Dock = [System.Windows.Forms.DockStyle]::Fill

    # Create textfield for message
    $Text = New-TextBox -Text $Message -ReadOnly
    $Text.AutoSize = $true
    $Text.MultiLine = $true
    $Text.Dock = [System.Windows.Forms.DockStyle]::Fill
    $Panel.Controls.Add($Text)

    # Create button
    $Ok = New-Button -Text $ButtonText
    $Ok.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom
    $Ok.Add_Click({$this.Parent.Parent.Close()})
    $Panel.Controls.Add($Ok)
    $Form.AcceptButton = $Ok

    $Form.Controls.Add($Panel)

    # Layout operations
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100))) > $null
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) > $null

    # Return created form
    Return $Form
}

Function New-InputBox {
    <#
    .SYNOPSIS
    This function creates an input box.

    .DESCRIPTION
    This function creates an input box.

    .PARAMETER Title
    Title of the window.

    .PARAMETER Message
    The message to be displayed.

    .PARAMETER ButtonText
    The text to be displayed in the confirmation button.

    .PARAMETER WindowState
    State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

    .PARAMETER StartPosition
    Sets the start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

    .PARAMETER HideInTaskbar
    Wether to hide the icon in taskbar.

    .EXAMPLE
    PS C:\> New-InputBox -Title 'Input' -Message 'Input message' -ButtonText 'Ok' -HideInTaskbar 
    #>

    Param (
        [String] $Title = '',
        [String] $Message = '',
        [String] $ButtonText = 'Ok',
        [ValidateSet('Normal', 'Maximized', 'Minimized')][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet('CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent')][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,
        [Switch] $HideInTaskbar
    )

    # Create form
    $Form = New-Form -Title $Title -WindowState $WindowState -StartPosition $StartPosition -Height 50 -Width 200 -AutoSize -HideInTaskbar:$HideInTaskbar
    $Form.Padding = 0

    # Create TableLayoutPanel
    $Panel = New-Panel -TableLayout -AutoSize
    $Panel.GrowStyle = [System.Windows.Forms.TableLayoutPanelGrowStyle]::AddRows
    $Panel.Dock = [System.Windows.Forms.DockStyle]::Fill

    # Create textbox for message
    $Text = New-TextBox -Text $Message
    $Text.AutoSize = $true
    $Text.Name = 'Message'
    $Panel.Controls.Add($Text)

    # Create textfield for input
    $Input = New-TextBox
    $Input.AutoSize = $true
    $Input.Name = 'Input'
    $Panel.Controls.Add($Input)

    # Create button
    $Button = New-Button -Text $ButtonText
    $Button.Add_Click({$this.Parent.Controls | ForEach-Object {If ('Input' -eq $_.AccessibilityObject.Name) {$_.AccessibilityObject.Value}}; $this.Parent.Close() > $null})
    $Panel.Controls.Add($Button)
    $Form.AcceptButton = $Button

    $Form.Controls.Add($Panel)

    # Layout operations
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100))) > $null
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) > $null
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) > $null

    # Return created form
    Return $Form
}

Function New-ChoiceBox {
    <#
    .SYNOPSIS
    This function creates a choice box.

    .DESCRIPTION
    This function creates a choice box.

    .PARAMETER Title
    Title of the window.

    .PARAMETER Message
    The message to be displayed.

    .PARAMETER ButtonConfirm
    The text to be displayed in the confirmation button.

    .PARAMETER ButtonDeny
    The text to be displayed in the deny button.

    .PARAMETER WindowState
    State of the created window. Can be 'Normal', 'Maximized' or 'Minimized'.

    .PARAMETER StartPosition
    Sets the start position of the created window. Can be 'CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds' or 'CenterParent'.

    .PARAMETER HideInTaskbar
    Wether to hide the icon in taskbar.

    .EXAMPLE
    PS C:\> New-ChoiceBox -Title 'Choice' -Message 'Choice message' -ButtonConfirmation 'Yes' -HideInTaskbar 
    #>
    param (
        [String] $Title = '',
        [String] $Message = '',
        [String] $ButtonConfirm = 'Yes',
        [String] $ButtonDeny = 'No',
        [ValidateSet('Normal', 'Maximized', 'Minimized')][System.Windows.Forms.FormWindowState] $WindowState = [System.Windows.Forms.FormWindowState]::Normal,
        [ValidateSet('CenterScreen', 'Manual', 'WindowsDefaultLocation', 'WindowsDefaultBounds', 'CenterParent')][System.Windows.Forms.FormStartPosition] $StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,
        [Switch] $HideInTaskbar
    )

    # Create form
    $Form = New-Form -Title $Title -WindowState $WindowState -StartPosition $StartPosition -Height 50 -Width 300 -AutoSize -HideInTaskbar:$HideInTaskbar
    $Form.Padding = 0

    # Create TableLayoutPanel
    $Panel = New-Panel -TableLayout -AutoSize
    $Panel.ColumnCount = 2
    $Panel.GrowStyle = [System.Windows.Forms.TableLayoutPanelGrowStyle]::AddRows
    $Panel.Dock = [System.Windows.Forms.DockStyle]::Fill

    # Create textfield for message
    $Text = New-TextBox -Text $Message -ReadOnly
    $Text.AutoSize = $true
    $Text.MultiLine = $true
    $Panel.Controls.Add($Text)

    # Create confirmation button
    $Confirm = New-Button -Text $ButtonConfirm
    $Confirm.Add_Click({'Accept'; $this.Parent.Close()})
    $Panel.Controls.Add($Confirm)
    $Form.AcceptButton = $Confirm

    # Create deny button
    $Deny = New-Button -Text $ButtonDeny
    $Deny.Add_Click({$this.Parent.Close()})
    $Panel.Controls.Add($Deny)
    $Form.CancelButton = $Deny

    $Form.Controls.Add($Panel)

    # Layout operations
    $Panel.SetColumnSpan($Text, 2)
    $Panel.ColumnStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50))) > $null
    $Panel.ColumnStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50))) > $null
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100))) > $null
    $Panel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) > $null

    # Return created form
    Return $Form
}