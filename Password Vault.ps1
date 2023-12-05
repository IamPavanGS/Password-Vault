[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$input = @’
<Window x:Name="PasswordManager" x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Password_Manager"
        mc:Ignorable="d"
        Title="Master Password" Height="240" Width="700" WindowStyle="ToolWindow" ResizeMode="CanMinimize" >
    <Window.Resources>
    <Style TargetType="Button">
        <Setter Property="FocusVisualStyle">
            <Setter.Value>
                <Style>
                    <Setter Property="Control.Template">
                        <Setter.Value>
                            <ControlTemplate>
                                <Rectangle StrokeThickness="0"/>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Setter.Value>
        </Setter>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="#FF007892">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>

                    <ControlTemplate.Triggers>
                        <!-- Trigger for button click -->
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="border" Property="RenderTransform">
                                <Setter.Value>
                                    <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                </Setter.Value>
                            </Setter>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</Window.Resources>
    <Grid x:Name="PasswordManager" Background="#81Cae3" Margin="0,0,0,-36">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="405*"/>
            <ColumnDefinition Width="82*"/>
            <ColumnDefinition Width="195*"/>
        </Grid.ColumnDefinitions>
        <PasswordBox x:Name="Master_Password_textbox" Grid.ColumnSpan="3" HorizontalAlignment="Left" Margin="173,66,0,0" VerticalAlignment="Top" Width="389" Height="24">
    <PasswordBox.Style>
        <Style TargetType="PasswordBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="PasswordBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </PasswordBox.Style>
</PasswordBox>
        <TextBox x:Name="password_display_textbox" Grid.ColumnSpan="3" HorizontalAlignment="Left" Margin="173,66,0,0" VerticalAlignment="Top" Width="389" Height="24" Visibility="Collapsed">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <Label x:Name="Master_Password_lbl" Content="Master Password" HorizontalAlignment="Left" Margin="28,62,0,0" VerticalAlignment="Top" Width="128" FontWeight="Bold" FontSize="14"/>
        <Button x:Name="open_btn" Grid.Column="2" Content="Open" HorizontalAlignment="Left" Margin="83,170,0,0" VerticalAlignment="Top" Width="76" FontWeight="Bold"/>
        <Label x:Name="Load_file_lbl" Content="Load Password File" HorizontalAlignment="Left" Margin="28,112,0,0" VerticalAlignment="Top" Width="140" FontWeight="Bold" FontSize="14"/>
        <Button x:Name="password_btn" Grid.Column="2" Content="Browse" HorizontalAlignment="Left" Margin="83,117,0,0" VerticalAlignment="Top" Width="76" Height="22" FontWeight="Bold"/>
        <TextBox x:Name="passwordfile_txtbox" HorizontalAlignment="Left" Margin="173,116,0,0" VerticalAlignment="Top" Width="389" Grid.ColumnSpan="3" Height="24">
    <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <Menu Margin="0,0,368,213" Background="#81Cae3">
            <MenuItem Header="File" Width="51" Height="20">
                <MenuItem x:Name="menuItem_createMasterPwdFile" Header="Create Master Pwd File"/>
            </MenuItem>
        </Menu>
        <CheckBox Grid.Column="2" Content="Show Password" Name="show_password_checkbox" HorizontalAlignment="Left" Margin="83,70,0,0" VerticalAlignment="Top" FontStyle="Italic"/>
    </Grid>
</Window>
'@

$input = $input -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N' 
[xml]$xaml = $input
$xmlreader=(New-Object System.Xml.XmlNodeReader $xaml)
$xamlForm=[Windows.Markup.XamlReader]::Load( $xmlreader )

$xaml.SelectNodes("//*[@Name]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $xamlForm.FindName($_.Name)
    }


$show_password_checkbox.Add_Click({
    if ($show_password_checkbox.IsChecked) {
        $password_display_textbox.Text = $Master_Password_textbox.Password
        $Master_Password_textbox.Visibility = "Collapsed"
        $password_display_textbox.Visibility = "Visible"
    } else {
        $password_display_textbox.Visibility = "Collapsed"
        $Master_Password_textbox.Visibility = "Visible"
    }
})


$Global:Master_Password = $Master_Password_textbox.text
$Global:passwordfile = $passwordfile_txtbox.text

$password_btn.Add_click({
    $openFileDialog = New-Object Microsoft.Win32.OpenFileDialog
    $openFileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    $openFileDialog.Title = "Select a .txt file"
    
    if ($openFileDialog.ShowDialog() -eq $true) {
        $selectedFilePath = $openFileDialog.FileName
        if ($selectedFilePath -match '\.txt$') {
            $passwordfile_txtbox.Text = $selectedFilePath
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a proper .txt file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

$menuItem_createMasterPwdFile.Add_Click({
    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowserDialog.Description = "Select a folder to create the master password file"

    if ($folderBrowserDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFolderPath = $folderBrowserDialog.SelectedPath
        
$input4 = @’
<Window x:Name="Password_Manager"  x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Password_manager_mainwindow"
        mc:Ignorable="d"
        Title="Password Manager" Height="154" Width="538" WindowStyle="ToolWindow" ResizeMode="CanMinimize">
        <Window.Resources>
    <Style TargetType="Button">
        <Setter Property="FocusVisualStyle">
            <Setter.Value>
                <Style>
                    <Setter Property="Control.Template">
                        <Setter.Value>
                            <ControlTemplate>
                                <Rectangle StrokeThickness="0"/>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Setter.Value>
        </Setter>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="#FF007892">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>

                    <ControlTemplate.Triggers>
                        <!-- Trigger for button click -->
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="border" Property="RenderTransform">
                                <Setter.Value>
                                    <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                </Setter.Value>
                            </Setter>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
     <Style x:Key="CustomTextBoxStyle" TargetType="TextBox">
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TextBox">
                    <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                        <ScrollViewer x:Name="PART_ContentHost"/>
                    </Border>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</Window.Resources>
    <Grid x:Name="Password_Manager_Mainfile" Background="#81Cae3" Margin="0,0,0,-16">
        <Label x:Name="file_creation_lbl" Content="Enter the file name to create" Margin="10,42,323,33" FontWeight="Bold" FontSize="14"/>
        <TextBox x:Name="file_creation_txtbox" HorizontalAlignment="Left" Margin="250,46,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="260" Height="25" FontSize="14" Style="{StaticResource CustomTextBoxStyle}"/>
        <Button x:Name="create_masterfile_btn" Content="Ok" HorizontalAlignment="Left" Margin="470,101,0,0" VerticalAlignment="Top" Width="40"/>
    </Grid>
</Window>
'@

$input4 = $input4 -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' 
[xml]$xaml4 = $input4
$xmlreader4 = (New-Object System.Xml.XmlNodeReader $xaml4)
$xamlForm4 = [Windows.Markup.XamlReader]::Load($xmlreader4)

$xaml4.SelectNodes("//*[@Name]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $xamlForm4.FindName($_.Name)
}

$file_creation_txtbox = $xamlForm4.FindName("file_creation_txtbox")

$create_masterfile_btn.Add_Click({
    $Global:txtfile_creation = $file_creation_txtbox.Text
    $xamlForm4.Close()
})

# Show the second GUI form
$xamlForm4.ShowDialog() | Out-Null

        
            $fileName = $Global:txtfile_creation
            if (-not [string]::IsNullOrEmpty($fileName)) {
                $passwordfile_txtbox.Text = Join-Path -Path $selectedFolderPath -ChildPath "$fileName.txt"
            } else {
                [System.Windows.Forms.MessageBox]::Show("Please enter a valid file name.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
    }

        $filepath = $xamlForm.FindName("passwordfile_txtbox").Text
        $passwordBox = $xamlForm.FindName("Master_Password_textbox")
        if (Test-Path $filepath) {

            [System.Windows.Forms.MessageBox]::Show("File already exists. You can open and manage it.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            try {
                $fileContent = "This is the content of the text file."  
                New-Item -Path $filepath -ItemType File | Out-Null  
                [System.Windows.Forms.MessageBox]::Show("Text file created successfully at $filepath", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            } catch {
                [System.Windows.Forms.MessageBox]::Show("An error occurred while creating the text file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }

})




$open_btn.Add_Click({
 $filepath = $xamlForm.FindName("passwordfile_txtbox").Text
    $passwordBox = $xamlForm.FindName("Master_Password_textbox")
    if ([string]::IsNullOrEmpty($filepath) -or [string]::IsNullOrEmpty($passwordBox)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter the Master Password and select a Password File.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
   
    $password = $passwordBox.Password
    $global:filepath = $filepath
    $global:master_password = $passwordBox.password

$xamlForm.Close()

$input2 = @’
<Window x:Name="Password_Manager_Mainfile"  x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Password_Manager_1"
        mc:Ignorable="d"
              Title="Password Manager" Height="590" Width="665" ResizeMode="CanMinimize" WindowStyle="ToolWindow">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="FocusVisualStyle">
                <Setter.Value>
                    <Style>
                        <Setter Property="Control.Template">
                            <Setter.Value>
                                <ControlTemplate>
                                    <Rectangle StrokeThickness="0"/>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="Black">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>

                        <ControlTemplate.Triggers>
                            <!-- Trigger for button click -->
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid Background="#FF007892" x:Name="Password_Manager_Mainfile">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="183*"/>
            <ColumnDefinition Width="482*"/>
        </Grid.ColumnDefinitions>
        <Label x:Name="Main_windows_Lbl" Content="PASSWORD VALUT🔐" Margin="48,24,231,496" FontSize="16" FontFamily="Arial Rounded MT Bold" Foreground="White" Grid.Column="1">
            <Label.Triggers>
                <EventTrigger RoutedEvent="MouseEnter">
                    <BeginStoryboard>
                        <Storyboard>
                            <ColorAnimation Storyboard.TargetProperty="(Label.Foreground).(SolidColorBrush.Color)" To="#191b41" Duration="0:0:0.2"/>
                        </Storyboard>
                    </BeginStoryboard>
                </EventTrigger>
                <EventTrigger RoutedEvent="MouseLeave">
                    <BeginStoryboard>
                        <Storyboard>
                            <ColorAnimation Storyboard.TargetProperty="(Label.Foreground).(SolidColorBrush.Color)" To="White" Duration="0:0:0.2"/>
                        </Storyboard>
                    </BeginStoryboard>
                </EventTrigger>
            </Label.Triggers>
        </Label>
       <Button x:Name="modify_btn" Content="Modify" HorizontalAlignment="Left" Margin="377,448,0,0" VerticalAlignment="Top" FontWeight="Bold" Grid.Column="1" Width="62">
    <Button.Style>
        <Style TargetType="Button">
            <Setter Property="FocusVisualStyle">
                <Setter.Value>
                    <Style>
                        <Setter Property="Control.Template">
                            <Setter.Value>
                                <ControlTemplate>
                                    <Rectangle StrokeThickness="0"/>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="Black">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#81Cae3"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Button.Style>
    <Button.Effect>
        <DropShadowEffect/>
    </Button.Effect>
</Button>

<Button x:Name="new_btn" Content="NEW" HorizontalAlignment="Left" Margin="293,448,0,0" VerticalAlignment="Top" FontWeight="Bold" Grid.Column="1" Width="62">
    <Button.Style>
        <Style TargetType="Button">
            <Setter Property="FocusVisualStyle">
                <Setter.Value>
                    <Style>
                        <Setter Property="Control.Template">
                            <Setter.Value>
                                <ControlTemplate>
                                    <Rectangle StrokeThickness="0"/>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="Black">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#81Cae3"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Button.Style>
    <Button.Effect>
        <DropShadowEffect/>
    </Button.Effect>
</Button>
        <RichTextBox x:Name="Output_rich_txtbox" Margin="10,486,10,10" Grid.ColumnSpan="2" BorderBrush="Black" BorderThickness="2,2,2,2" IsReadOnly="True">
            <RichTextBox.Resources>
                <Style TargetType="{x:Type Paragraph}">
                    <Setter Property="LineHeight" Value="1" />
                </Style>
            </RichTextBox.Resources>
            <FlowDocument>
                <Paragraph>
                    <Run Text=""/>
                </Paragraph>
            </FlowDocument>
        </RichTextBox>
        <!-- First DataGrid -->
        <DataGrid x:Name="dataGrid1" Margin="10,128,10,135" Grid.ColumnSpan="2" AutoGenerateColumns="False" FontWeight="Bold" BorderBrush="Black" BorderThickness="2,2,2,2">
            <DataGrid.Columns>
                <DataGridTextColumn Header="IP\Application" Binding="{Binding IP}" Width="*" IsReadOnly="True" CanUserSort="False" FontWeight="Bold"/>
                <DataGridTextColumn Header="Username" Binding="{Binding Username}" Width="*" IsReadOnly="True" CanUserSort="False" FontWeight="Bold"/>
                <DataGridTemplateColumn Header="Password">
            <DataGridTemplateColumn.CellTemplate>
                <DataTemplate>
                    <TextBlock Text="*****" Margin="1">
                        <TextBlock.Effect>
                            <BlurEffect Radius="1"/> <!-- Adjust the blur radius as needed -->
                        </TextBlock.Effect>
                    </TextBlock>
                </DataTemplate>
            </DataGridTemplateColumn.CellTemplate>
        </DataGridTemplateColumn>
                <DataGridTextColumn Header="Platform" Binding="{Binding Platform}" Width="*" IsReadOnly="True" CanUserSort="True" FontWeight="Bold"/>
                <DataGridTextColumn Header="Location" Binding="{Binding Location}" Width="*" IsReadOnly="True" CanUserSort="True" FontWeight="Bold"/>
            </DataGrid.Columns>
            <DataGrid.ContextMenu>
                <ContextMenu>
                    <MenuItem Header="Copy Password" Name="copyPasswordMenuItem"/>
                    <MenuItem Header="Copy Username" Name="copyusernameMenuItem"/>
                    <MenuItem Header="Modify Data" Name="modifydataMenuItem"/>
                </ContextMenu>
            </DataGrid.ContextMenu>
        </DataGrid>
        <TextBox x:Name="search_textbox" HorizontalAlignment="Left" Margin="221,83,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="134" Height="22" Grid.Column="1">
            <TextBox.Style>
                <Style TargetType="TextBox">
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="TextBox">
                                <Border BorderThickness="1" BorderBrush="Black" Background="White" CornerRadius="5">
                                    <ScrollViewer x:Name="PART_ContentHost"/>
                                </Border>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </TextBox.Style>
        </TextBox>
        <Button x:Name="search_btn" Content="Search" HorizontalAlignment="Left" Margin="361,83,0,0" VerticalAlignment="Top" FontWeight="Bold" Grid.Column="1" Width="80">
    <Button.Style>
        <Style TargetType="Button">
            <Setter Property="FocusVisualStyle">
                <Setter.Value>
                    <Style>
                        <Setter Property="Control.Template">
                            <Setter.Value>
                                <ControlTemplate>
                                    <Rectangle StrokeThickness="0"/>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="Black">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#81Cae3"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Button.Style>
    <Button.Effect>
        <DropShadowEffect/>
    </Button.Effect>
</Button>

        <Menu Margin="0,0,133,534" Background="#FF007892" FontWeight="Bold">
    <MenuItem Header="File" Height="21" Width="51" Foreground="White">
        <MenuItem x:Name="Import" Header="Import from CSV File" Foreground="Black"/>
        <MenuItem x:Name="Import_Master" Header="Import from another Master File" Foreground="Black"/>
        <MenuItem x:Name="Export_Sample" Header="Export Sample CSV" Foreground="Black"/>
    </MenuItem>
</Menu>
<Menu Margin="42,0,92,534" Background="#FF007892" FontWeight="Bold">
    <MenuItem Header="Help" Height="21" Width="51" Foreground="White">
        <MenuItem x:Name="About_me" Header="About Me" Foreground="Black"/>
        <MenuItem x:Name="Reload_master_file" Header="Reload Master File" Foreground="Black"/>
    </MenuItem>
</Menu>
    </Grid>
</Window>
'@

$input2 = $input2 -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N' 
[xml]$xaml2 = $input2
$xmlreader2=(New-Object System.Xml.XmlNodeReader $xaml2)
$xamlForm2=[Windows.Markup.XamlReader]::Load( $xmlreader2 )

$xaml2.SelectNodes("//*[@Name]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $xamlForm.FindName($_.Name)
    }

#Password encrypt\decrypt function
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".aes"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".aes"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

#Invoke-AESEncryption -Mode Encrypt -Key $masterpassword -Text "Application\IP:$username Username:$passwordusername Password:$paswordpassword" | Out-File -LiteralPath "C:\Users\Public\Encrypted\password.txt" -Append

function data_grid {
$data = Get-Content -LiteralPath $global:filepath

$output = @()

foreach ($i in $data) {
    $data = Invoke-AESEncryption -Mode Decrypt -Key $global:master_password -Text $i
    $output += $data
}

# Split the decrypted data into individual lines
$lines = $output -split "`n"

# Define a regular expression pattern to match the desired elements
#$pattern = "IP:(\S+)\s+Username:(\S+)\s+Password:(\S+)(?:\s+Platform:(\S+))?(?:\s+Location:(\S+)|\s+Location:)"
$pattern = "IP:(.+?)\s+Username:(.+?)\s+Password:(.+?)(?:\s+Platform:(.+?))?(?:\s+Location:(.+)|\s+Location:)"

$resultArray = @()

# Iterate through each line and extract the values
foreach ($line in $lines) {
    if ($line -match $pattern) {
        $ip = $Matches[1]
        $username = $Matches[2]
        $password = $Matches[3]
        $Platform = $Matches[4]
        $Location = $Matches[5]

        # Create an object with the extracted values and add it to the result array
        $resultObject = [PSCustomObject]@{
            IP = $ip
            Username = $username
            Password = $password
            Platform = $Platform
            Location = $Location
        }

        $resultArray += $resultObject
    }
}

# Create a list to store your custom objects
$DataGridItemList = New-Object 'System.Collections.Generic.List[Object]'

# Loop through each object in $resultArray and add it to the list
foreach ($obj in $resultArray) {
    if ($obj.IP -ne "" -or $obj.Username -ne "" -or $obj.Password -ne "" -or $obj.Platform -ne "" -or $obj.Location -ne "") {
        $DataGridItemList.Add($obj)
    }
}

# Create or access the DataGrid
$dataGrid1 = $xamlForm2.FindName("dataGrid1")

# Ensure AutoGenerateColumns is set to False
$dataGrid1.AutoGenerateColumns = $false

# Define columns for the DataGrid if they don't exist
if ($dataGrid1.Columns.Count -eq 0) {
    # Define columns for the DataGrid
    $column1 = New-Object Windows.Controls.DataGridTextColumn
    $column1.Header = "IP"
    $column1.Binding = [Windows.Data.Binding]::new("IP")

    $column2 = New-Object Windows.Controls.DataGridTextColumn
    $column2.Header = "Username"
    $column2.Binding = [Windows.Data.Binding]::new("Username")

    $column3 = New-Object Windows.Controls.DataGridTextColumn
    $column3.Header = "Password"
    $column3.Binding = [Windows.Data.Binding]::new("Password")

    $column4 = New-Object Windows.Controls.DataGridTextColumn
    $column4.Header = "Platform"
    $column4.Binding = [Windows.Data.Binding]::new("Platform")

    $column5 = New-Object Windows.Controls.DataGridTextColumn
    $column5.Header = "Location"
    $column5.Binding = [Windows.Data.Binding]::new("Location")

    # Add columns to the DataGrid
    $dataGrid1.Columns.Add($column1)
    $dataGrid1.Columns.Add($column2)
    $dataGrid1.Columns.Add($column3)
    $dataGrid1.Columns.Add($column4)
    $dataGrid1.Columns.Add($column5)
}

# Set the DataGrid's ItemsSource to the list
$dataGrid1.ItemsSource = $DataGridItemList

# Set CanUserAddRows to False to prevent the extra empty row
$dataGrid1.CanUserAddRows = $false

}

$data = Get-Content -LiteralPath $global:filepath

$output = @()

foreach ($i in $data) {
    $data = Invoke-AESEncryption -Mode Decrypt -Key $global:master_password -Text $i
    $output += $data
}

# Split the decrypted data into individual lines
$lines = $output -split "`n"

# Define a regular expression pattern to match the desired elements
#$pattern = "IP:(\S+)\s+Username:(\S+)\s+Password:(\S+)(?:\s+Platform:(\S+))?(?:\s+Location:(\S+))?"
$pattern = "IP:(.+?)\s+Username:(.+?)\s+Password:(.+?)(?:\s+Platform:(.+?))?(?:\s+Location:(.+)|\s+Location:)"


$resultArray = @()

# Iterate through each line and extract the values
foreach ($line in $lines) {
    if ($line -match $pattern) {
        $ip = $Matches[1]
        $username = $Matches[2]
        $password = $Matches[3]
        $Platform = $Matches[4]
        $Location = $Matches[5]

        # Create an object with the extracted values and add it to the result array
        $resultObject = [PSCustomObject]@{
            IP = $ip
            Username = $username
            Password = $password
            Platform = $Platform
            Location = $Location
        }

        $resultArray += $resultObject
    }
}

# Create a list to store your custom objects
$DataGridItemList = New-Object 'System.Collections.Generic.List[Object]'

# Loop through each object in $resultArray and add it to the list
foreach ($obj in $resultArray) {
    if ($obj.IP -ne "" -or $obj.Username -ne "" -or $obj.Password -ne "" -or $obj.Platform -ne "" -or $obj.Location -ne "") {
        $DataGridItemList.Add($obj)
    }
}

# Create or access the DataGrid
$dataGrid1 = $xamlForm2.FindName("dataGrid1")

# Ensure AutoGenerateColumns is set to False
$dataGrid1.AutoGenerateColumns = $false

# Define columns for the DataGrid if they don't exist
if ($dataGrid1.Columns.Count -eq 0) {
    # Define columns for the DataGrid
    $column1 = New-Object Windows.Controls.DataGridTextColumn
    $column1.Header = "IP"
    $column1.Binding = [Windows.Data.Binding]::new("IP")

    $column2 = New-Object Windows.Controls.DataGridTextColumn
    $column2.Header = "Username"
    $column2.Binding = [Windows.Data.Binding]::new("Username")

    $column3 = New-Object Windows.Controls.DataGridTextColumn
    $column3.Header = "Password"
    $column3.Binding = [Windows.Data.Binding]::new("Password")

    $column4 = New-Object Windows.Controls.DataGridTextColumn
    $column4.Header = "Platform"
    $column4.Binding = [Windows.Data.Binding]::new("Platform")

    $column5 = New-Object Windows.Controls.DataGridTextColumn
    $column5.Header = "Location"
    $column5.Binding = [Windows.Data.Binding]::new("Location")

    # Add columns to the DataGrid
    $dataGrid1.Columns.Add($column1)
    $dataGrid1.Columns.Add($column2)
    $dataGrid1.Columns.Add($column3)
    $dataGrid1.Columns.Add($column4)
    $dataGrid1.Columns.Add($column5)
}

# Set the DataGrid's ItemsSource to the list
$dataGrid1.ItemsSource = $DataGridItemList

# Set CanUserAddRows to False to prevent the extra empty row
$dataGrid1.CanUserAddRows = $false

# Load your data into the DataGrid initially
#data_grid

# Store the original data in a global variable
$Global:OriginalData = $DataGridItemList

# Define a function to filter data based on search criteria
# Define a function to filter data based on search criteria
function Filter-Data {
    param (
        [string]$searchText
    )

    $filteredData = $Global:OriginalData | Where-Object {
        ($_ -ne $null) -and
        ($_ -ne '') -and
        (
            $_.IP -like "*$searchText*" -or
            $_.Username -like "*$searchText*" -or
            $_.Password -like "*$searchText*" -or
            $_.Platform -like "*$searchText*" -or
            $_.Location -like "*$searchText*"
        )
    }

    Write-Host "Filtered Data Count: $($filteredData.Count)"

    # Ensure $filteredData is always an array
    $filteredData = @($filteredData)

    $dataGrid1.ItemsSource = $filteredData
}

# Attach the event handler for the "Search" button
$search_textbox = $xamlForm2.FindName("search_textbox")
$search_btn = $xamlForm2.FindName("search_btn")
$search_btn.Add_Click({
    $searchText = $search_textbox.Text
    Write-Host "Search Button Clicked. Search Text: '$searchText'"
    Filter-Data -searchText $searchText
})

# Attach a KeyDown event handler to the search box to trigger the search on Enter key press
$search_textbox.Add_KeyDown({
    param($sender, $e)
    if ($e.Key -eq [System.Windows.Input.Key]::Enter) {
        $searchText = $search_textbox.Text
        Filter-Data -searchText $searchText
    }
})



# Define an array to store all data, including modified data
$Global:allData = @()

$modify_btn = $xamlForm2.FindName("modify_btn")
$modify_btn.Add_Click({

$input5 = @’
<Window x:Name="Password Manager"  x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Modify_data"
        mc:Ignorable="d"
        Title="MainWindow" Height="293" Width="543" WindowStyle="ToolWindow">
        <Window.Resources>
    <Style TargetType="Button">
        <Setter Property="FocusVisualStyle">
            <Setter.Value>
                <Style>
                    <Setter Property="Control.Template">
                        <Setter.Value>
                            <ControlTemplate>
                                <Rectangle StrokeThickness="0"/>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Setter.Value>
        </Setter>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="#FF007892">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>

                    <ControlTemplate.Triggers>
                        <!-- Trigger for button click -->
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="border" Property="RenderTransform">
                                <Setter.Value>
                                    <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                </Setter.Value>
                            </Setter>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</Window.Resources>
    <Grid Background="#81Cae3">
        <Button x:Name="Modify_btn1" Content="Modify" HorizontalAlignment="Left" Margin="452,221,0,0" VerticalAlignment="Top" Height="24" Width="62"/>
        <Label Content="Modify Data" HorizontalAlignment="Center" Margin="0,21,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" FontStyle="Italic"/>
        <Label Content="Application\IP" HorizontalAlignment="Left" Margin="22,54,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Username" HorizontalAlignment="Left" Margin="22,87,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Password" HorizontalAlignment="Left" Margin="22,119,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Platform" HorizontalAlignment="Left" Margin="22,151,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Location" HorizontalAlignment="Left" Margin="21,184,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <TextBox x:Name="Modify_app_txtbox" HorizontalAlignment="Left" Margin="152,58,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_usertxtbox" HorizontalAlignment="Left" Margin="152,91,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_passwordtxtbox" HorizontalAlignment="Left" Margin="152,123,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_platformtxtbox" HorizontalAlignment="Left" Margin="152,155,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_locationtxtbox" HorizontalAlignment="Left" Margin="152,188,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
    </Grid>
</Window>
'@

$input5 = $input5 -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N' 
[xml]$xaml5 = $input5
$xmlreader5=(New-Object System.Xml.XmlNodeReader $xaml5)
$xamlForm5=[Windows.Markup.XamlReader]::Load( $xmlreader5 )

$xaml5.SelectNodes("//*[@Name]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $xamlForm5.FindName($_.Name)
    }

$Modify_btn1 = $xamlForm5.FindName("Modify_btn1")
$Modify_app_txtbox = $xamlForm5.FindName("Modify_app_txtbox")
$Modify_usertxtbox = $xamlForm5.FindName("Modify_usertxtbox")
$Modify_passwordtxtbox = $xamlForm5.FindName("Modify_passwordtxtbox")
$Modify_platformtxtbox = $xamlForm5.FindName("Modify_platformtxtbox")
$Modify_locationtxtbox = $xamlForm5.FindName("Modify_locationtxtbox")

$Modify_btn1.Add_Click({
    $selectedItem = $dataGrid1.SelectedItem
    if ($selectedItem -ne $null) {
        # Capture the modified data from your user interface or input fields
        $modifiedIP = $Modify_app_txtbox.Text
        $modifiedUsername = $Modify_usertxtbox.Text
        $modifiedPassword = $Modify_passwordtxtbox.Text
        $modifiedPlatform = $Modify_platformtxtbox.Text
        $modifiedLocation = $Modify_locationtxtbox.Text

        # Check if any of the textboxes are empty, and if so, use the original values
        if ([string]::IsNullOrEmpty($modifiedIP)) {
            $modifiedIP = $selectedItem.IP
        }
        if ([string]::IsNullOrEmpty($modifiedUsername)) {
            $modifiedUsername = $selectedItem.Username
        }
        if ([string]::IsNullOrEmpty($modifiedPassword)) {
            $modifiedPassword = $selectedItem.Password
        }
        if ([string]::IsNullOrEmpty($modifiedPlatform)) {
            $modifiedPlatform = $selectedItem.Platform
        }
        if ([string]::IsNullOrEmpty($modifiedLocation)) {
            $modifiedLocation = $selectedItem.Location
        }

        # Update the selected item in $resultArray with the modified data
        $selectedItem.IP = $modifiedIP
        $selectedItem.Username = $modifiedUsername
        $selectedItem.Password = $modifiedPassword
        $selectedItem.Platform = $modifiedPlatform
        $selectedItem.Location = $modifiedLocation

        # Refresh the DataGrid with the updated data
        $dataGrid1.Items.Refresh()

        # Inform the user that the data has been updated
    } else {
        [System.Windows.MessageBox]::Show("Please select a row to modify.", "Selection Required", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }

    # Initialize an empty array to store the encrypted data
    $encryptedData = @()
    # Add this line to print out the count of items before the encryption loop
Write-Host "Total Items: $($dataGrid1.Items.Count)"
$Global:OriginalData = $DataGridItemList

# Loop through all items in the original data
$Global:OriginalData | ForEach-Object {
    $item = $_
    $textToEncrypt = "Application\IP:$($item.IP) Username:$($item.Username) Password:$($item.Password) Platform:$($item.Platform) Location:$($item.Location)"

    # Escape the '$' character to ensure it's treated as a regular character
    $textToEncrypt = $textToEncrypt -replace '\$', '$'

    # Encrypt the data and add it to the $encryptedData array
    $encryptedText = Invoke-AESEncryption -Mode Encrypt -Key $Global:Master_Password -Text $textToEncrypt
    $encryptedData += $encryptedText
    Start-Sleep -Milliseconds 20
}

# Replace the data in the file with the new encrypted data
$encryptedData | Out-File -LiteralPath $global:filepath
    [System.Windows.MessageBox]::Show("Data has been modified and updated.", "Modification Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    $xamlForm5.Close()
})


$xamlForm5.ShowDialog() | out-null

})


$modifydataMenuItem = $xamlForm2.FindName("modifydataMenuItem")
$Output_rich_txtbox = $xamlForm2.FindName("Output_rich_txtbox")
$modifydataMenuItem.Add_Click({

$input5 = @’
<Window x:Name="Password Manager"  x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Modify_data"
        mc:Ignorable="d"
        Title="MainWindow" Height="293" Width="543" WindowStyle="ToolWindow">
        <Window.Resources>
    <Style TargetType="Button">
        <Setter Property="FocusVisualStyle">
            <Setter.Value>
                <Style>
                    <Setter Property="Control.Template">
                        <Setter.Value>
                            <ControlTemplate>
                                <Rectangle StrokeThickness="0"/>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Setter.Value>
        </Setter>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="#FF007892">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>

                    <ControlTemplate.Triggers>
                        <!-- Trigger for button click -->
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="border" Property="RenderTransform">
                                <Setter.Value>
                                    <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                </Setter.Value>
                            </Setter>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</Window.Resources>
    <Grid Background="#81Cae3">
        <Button x:Name="Modify_btn1" Content="Modify" HorizontalAlignment="Left" Margin="452,221,0,0" VerticalAlignment="Top" Height="24" Width="62"/>
        <Label Content="Modify Data" HorizontalAlignment="Center" Margin="0,21,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" FontStyle="Italic"/>
        <Label Content="Application\IP" HorizontalAlignment="Left" Margin="22,54,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Username" HorizontalAlignment="Left" Margin="22,87,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Password" HorizontalAlignment="Left" Margin="22,119,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Platform" HorizontalAlignment="Left" Margin="22,151,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <Label Content="Location" HorizontalAlignment="Left" Margin="21,184,0,0" VerticalAlignment="Top" FontFamily="Arial Rounded MT Bold" FontSize="14"/>
        <TextBox x:Name="Modify_app_txtbox" HorizontalAlignment="Left" Margin="152,58,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_usertxtbox" HorizontalAlignment="Left" Margin="152,91,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_passwordtxtbox" HorizontalAlignment="Left" Margin="152,123,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_platformtxtbox" HorizontalAlignment="Left" Margin="152,155,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
        <TextBox x:Name="Modify_locationtxtbox" HorizontalAlignment="Left" Margin="152,188,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="362">
        <TextBox.Style>
        <Style TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </TextBox.Style>
</TextBox>
    </Grid>
</Window>
'@

$input5 = $input5 -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N' 
[xml]$xaml5 = $input5
$xmlreader5=(New-Object System.Xml.XmlNodeReader $xaml5)
$xamlForm5=[Windows.Markup.XamlReader]::Load( $xmlreader5 )

$xaml5.SelectNodes("//*[@Name]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $xamlForm5.FindName($_.Name)
    }

$Modify_btn1 = $xamlForm5.FindName("Modify_btn1")
$Modify_app_txtbox = $xamlForm5.FindName("Modify_app_txtbox")
$Modify_usertxtbox = $xamlForm5.FindName("Modify_usertxtbox")
$Modify_passwordtxtbox = $xamlForm5.FindName("Modify_passwordtxtbox")
$Modify_platformtxtbox = $xamlForm5.FindName("Modify_platformtxtbox")
$Modify_locationtxtbox = $xamlForm5.FindName("Modify_locationtxtbox")

$Modify_btn1.Add_Click({
    $selectedItem = $dataGrid1.SelectedItem
    if ($selectedItem -ne $null) {
        # Capture the modified data from your user interface or input fields
        $modifiedIP = $Modify_app_txtbox.Text
        $modifiedUsername = $Modify_usertxtbox.Text
        $modifiedPassword = $Modify_passwordtxtbox.Text
        $modifiedPlatform = $Modify_platformtxtbox.Text
        $modifiedLocation = $Modify_locationtxtbox.Text

        # Check if any of the textboxes are empty, and if so, use the original values
        if ([string]::IsNullOrEmpty($modifiedIP)) {
            $modifiedIP = $selectedItem.IP
        }
        if ([string]::IsNullOrEmpty($modifiedUsername)) {
            $modifiedUsername = $selectedItem.Username
        }
        if ([string]::IsNullOrEmpty($modifiedPassword)) {
            $modifiedPassword = $selectedItem.Password
        }
        if ([string]::IsNullOrEmpty($modifiedPlatform)) {
            $modifiedPlatform = $selectedItem.Platform
        }
        if ([string]::IsNullOrEmpty($modifiedLocation)) {
            $modifiedLocation = $selectedItem.Location
        }

        # Update the selected item in $resultArray with the modified data
        $selectedItem.IP = $modifiedIP
        $selectedItem.Username = $modifiedUsername
        $selectedItem.Password = $modifiedPassword
        $selectedItem.Platform = $modifiedPlatform
        $selectedItem.Location = $modifiedLocation

        # Refresh the DataGrid with the updated data
        $dataGrid1.Items.Refresh()

        # Inform the user that the data has been updated
    } else {
        [System.Windows.MessageBox]::Show("Please select a row to modify.", "Selection Required", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }

    # Initialize an empty array to store the encrypted data
    $encryptedData = @()
    # Add this line to print out the count of items before the encryption loop
Write-Host "Total Items: $($dataGrid1.Items.Count)"
$Global:OriginalData = $DataGridItemList

# Loop through all items in the original data
$Global:OriginalData | ForEach-Object {
    $item = $_
    $textToEncrypt = "Application\IP:$($item.IP) Username:$($item.Username) Password:$($item.Password) Platform:$($item.Platform) Location:$($item.Location)"

    # Escape the '$' character to ensure it's treated as a regular character
    $textToEncrypt = $textToEncrypt -replace '\$', '$'

    # Encrypt the data and add it to the $encryptedData array
    $encryptedText = Invoke-AESEncryption -Mode Encrypt -Key $Global:Master_Password -Text $textToEncrypt
    $encryptedData += $encryptedText
    Start-Sleep -Milliseconds 20
}

# Replace the data in the file with the new encrypted data
$encryptedData | Out-File -LiteralPath $global:filepath
    [System.Windows.MessageBox]::Show("Data has been modified and updated.", "Modification Complete", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    $xamlForm5.Close()
})


$xamlForm5.ShowDialog() | out-null


})


$Export_Sample = $xamlForm2.FindName("Export_Sample")
$Export_Sample.Add_Click({

$csvFilePath = "C:\Users\Public\samplefile.csv"
$headers = "IP", "Username", "Password", "Platform", "Location"
$headers -join "," | Out-File -FilePath $csvFilePath -Encoding UTF8

# Display a popup message
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show("The sample file has been saved in $csvFilePath folder.", "Sample File Saved", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)



})

$copyPasswordMenuItem = $xamlForm2.FindName("copyPasswordMenuItem")
$Output_rich_txtbox = $xamlForm2.FindName("Output_rich_txtbox")
$copyPasswordMenuItem.Add_Click({
    $selectedItem = $dataGrid1.SelectedItem
    if ($selectedItem -ne $null) {
        $selectedPassword = $selectedItem.Password
        $selectedPassworduser = $selectedItem.UserName
        
        [System.Windows.Clipboard]::SetText($selectedPassword)
        $message = "Password for the user $selectedPassworduser copied to clipboard."  + [Environment]::NewLine
        $Output_rich_txtbox.AppendText($message)
    }else{

    $message = "Please select a Password to copy." + [Environment]::NewLine
    $Output_rich_txtbox.AppendText($message)
    
    }

})

$copyusernameMenuItem = $xamlForm2.FindName("copyusernameMenuItem")
$Output_rich_txtbox = $xamlForm2.FindName("Output_rich_txtbox")
$copyusernameMenuItem.Add_Click({
 $selectedItem = $dataGrid1.SelectedItem
    if ($selectedItem -ne $null) {
        $selectedPassword = $selectedItem.UserName
       [System.Windows.Clipboard]::SetText($selectedPassword)
        $message = "Username copied to clipboard."  + [Environment]::NewLine
        $Output_rich_txtbox.AppendText($message)
    }
    else {
        $message = "Please select a Username to copy." + [Environment]::NewLine
        $Output_rich_txtbox.AppendText($message)
    }

})

$Reload_master_file = $xamlForm2.FindName("Reload_master_file")
$Reload_master_file.Add_Click({

$data = Get-Content -LiteralPath $global:filepath

$output = @()

foreach ($i in $data) {
    $data = Invoke-AESEncryption -Mode Decrypt -Key $global:master_password -Text $i
    $output += $data
}

# Split the decrypted data into individual lines
$lines = $output -split "`n"

# Define a regular expression pattern to match the desired elements
#$pattern = "IP:(\S+)\s+Username:(\S+)\s+Password:(\S+)(?:\s+Platform:(\S+))?(?:\s+Location:(\S+)|\s+Location:)"
$pattern = "IP:(.+?)\s+Username:(.+?)\s+Password:(.+?)(?:\s+Platform:(.+?))?(?:\s+Location:(.+)|\s+Location:)"

$resultArray = @()

# Iterate through each line and extract the values
foreach ($line in $lines) {
    if ($line -match $pattern) {
        $ip = $Matches[1]
        $username = $Matches[2]
        $password = $Matches[3]
        $Platform = $Matches[4]
        $Location = $Matches[5]

        # Create an object with the extracted values and add it to the result array
        $resultObject = [PSCustomObject]@{
            IP = $ip
            Username = $username
            Password = $password
            Platform = $Platform
            Location = $Location
        }

        $resultArray += $resultObject
    }
}

# Create a list to store your custom objects
$DataGridItemList = New-Object 'System.Collections.Generic.List[Object]'

# Loop through each object in $resultArray and add it to the list
foreach ($obj in $resultArray) {
    if ($obj.IP -ne "" -or $obj.Username -ne "" -or $obj.Password -ne "" -or $obj.Platform -ne "" -or $obj.Location -ne "") {
        $DataGridItemList.Add($obj)
    }
}

# Create or access the DataGrid
$dataGrid1 = $xamlForm2.FindName("dataGrid1")

# Ensure AutoGenerateColumns is set to False
$dataGrid1.AutoGenerateColumns = $false

# Define columns for the DataGrid if they don't exist
if ($dataGrid1.Columns.Count -eq 0) {
    # Define columns for the DataGrid
    $column1 = New-Object Windows.Controls.DataGridTextColumn
    $column1.Header = "IP"
    $column1.Binding = [Windows.Data.Binding]::new("IP")

    $column2 = New-Object Windows.Controls.DataGridTextColumn
    $column2.Header = "Username"
    $column2.Binding = [Windows.Data.Binding]::new("Username")

    $column3 = New-Object Windows.Controls.DataGridTextColumn
    $column3.Header = "Password"
    $column3.Binding = [Windows.Data.Binding]::new("Password")

    $column4 = New-Object Windows.Controls.DataGridTextColumn
    $column4.Header = "Platform"
    $column4.Binding = [Windows.Data.Binding]::new("Platform")

    $column5 = New-Object Windows.Controls.DataGridTextColumn
    $column5.Header = "Location"
    $column5.Binding = [Windows.Data.Binding]::new("Location")

    # Add columns to the DataGrid
    $dataGrid1.Columns.Add($column1)
    $dataGrid1.Columns.Add($column2)
    $dataGrid1.Columns.Add($column3)
    $dataGrid1.Columns.Add($column4)
    $dataGrid1.Columns.Add($column5)
}

# Set the DataGrid's ItemsSource to the list
$dataGrid1.ItemsSource = $DataGridItemList

# Set CanUserAddRows to False to prevent the extra empty row
$dataGrid1.CanUserAddRows = $false

})


$Export = $xamlForm2.FindName("Export")
<#$Export.Add_Click({
    try {
        $data = Get-Content -LiteralPath $global:filepath

        $output = @()

        foreach ($i in $data) {
            $data = Invoke-AESEncryption -Mode Decrypt -Key $global:master_password -Text $i
            $output += $data
        }

        # Split the decrypted data into individual lines
        $lines = $output -split "`n"

        $pattern = "IP:(.+?)\s+Username:(.+?)\s+Password:(.+?)(?:\s+Platform:(.+?))?(?:\s+Location:(.+)|\s+Location:)"


        $resultArray = @()

        foreach ($line in $lines) {
            if ($line -match $pattern) {
                $ip = $Matches[1]
                $username = $Matches[2]
                $password = $Matches[3]
                $Platform = $Matches[4]
                $Location = $Matches[5]

                $resultObject = [PSCustomObject]@{
                    IP = $ip
                    Username = $username
                    Password = $password
                    Platform = $Platform
                    Location = $Location
                }

                $resultArray += $resultObject
            }
        }

        $resultArray | Export-csv -Path C:\Users\Public\Password_export.csv -NoTypeInformation
        [System.Windows.MessageBox]::Show("Password CSV has been exported to Public folder", "Password Exported", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    } catch {
        $errorMessage = $_.Exception.Message
        [System.Windows.MessageBox]::Show("An error occurred: $errorMessage", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
})#>

$Import = $xamlForm2.FindName("Import")
$Import.Add_Click({

try {
    $openFileDialog = New-Object Microsoft.Win32.OpenFileDialog
    $openFileDialog.Filter = "csv Files (*.csv)|*.csv|All Files (*.*)|*.*"
    $openFileDialog.Title = "Select a .csv file"

    if ($openFileDialog.ShowDialog() -eq $true) {
        $selectedFilePath = $openFileDialog.FileName
        if ($selectedFilePath -match '\.csv$') {
            $import_file = $selectedFilePath
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a proper .csv file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return  # Exit the script if an error occurs
        }
    }

    $csvData = Import-Csv -Path $import_file

    foreach ($row in $csvData) {
        $textToEncrypt = "Application\IP:$($row.IP) Username:$($row.Username) Password:$($row.Password) Platform:$($row.Platform) Location:$($row.Location)"

        # Escape the '$' character to ensure it's treated as a regular character
        $textToEncrypt = $textToEncrypt -replace '\$', '$'
        Invoke-AESEncryption -Mode Encrypt -Key $Global:Master_Password -Text $textToEncrypt | Out-File -LiteralPath $global:filepath -Append
        Start-Sleep -Milliseconds 40
    }
    $dataGrid1.Items.Refresh()

    [System.Windows.Forms.MessageBox]::Show("Import has been successful, Kindly restart the application before doing any modification or you might loose the data.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
} catch {
    [System.Windows.Forms.MessageBox]::Show("An error occurred: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}


})

$Import_Master = $xamlForm2.FindName("Import_Master")
$Import_Master.Add_Click({
try {

$openFileDialog = New-Object Microsoft.Win32.OpenFileDialog
    $openFileDialog.Filter = "txt Files (*.txt)|*.txt|All Files (*.*)|*.*"
    $openFileDialog.Title = "Select a .txt file"

    if ($openFileDialog.ShowDialog() -eq $true) {
        $selectedFilePath = $openFileDialog.FileName
        if ($selectedFilePath -match '\.txt$') {
            $Global:import_file = $selectedFilePath
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a proper .txt file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return  # Exit the script if an error occurs
        }
    }

$input4 = @’
<Window x:Name="Master Password Prompt"  x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Master_Password_Prompt"
        mc:Ignorable="d"
        Title="Master Password" Height="175" Width="519" WindowStyle="ToolWindow">
        <Window.Resources>
    <Style TargetType="Button">
        <Setter Property="FocusVisualStyle">
            <Setter.Value>
                <Style>
                    <Setter Property="Control.Template">
                        <Setter.Value>
                            <ControlTemplate>
                                <Rectangle StrokeThickness="0"/>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Setter.Value>
        </Setter>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="#FF007892">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>

                    <ControlTemplate.Triggers>
                        <!-- Trigger for button click -->
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="border" Property="RenderTransform">
                                <Setter.Value>
                                    <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                </Setter.Value>
                            </Setter>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</Window.Resources>
    <Grid Margin="0,0,0,5" Background="#81Cae3">
        <TextBlock x:Name="Master_password_Lable1" HorizontalAlignment="Left" Margin="10,0,0,0" TextWrapping="Wrap" Text="Enter Master Password" VerticalAlignment="Center" Width="140" FontWeight="Bold" Height="26"/>
        <PasswordBox x:Name="Master_password_box1" HorizontalAlignment="Left" Margin="150,51,0,0" VerticalAlignment="Top" Width="330" Height="26">
    <PasswordBox.Style>
        <Style TargetType="PasswordBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="PasswordBox">
                        <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </PasswordBox.Style>
</PasswordBox>
        <Button x:Name="Master_password_on_btn" Content="OK" HorizontalAlignment="Left" Margin="412,107,0,0" VerticalAlignment="Top" Width="68"/>
    </Grid>
</Window>
'@

$input4 = $input4 -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N' 
[xml]$xaml4 = $input4
$xmlreader4=(New-Object System.Xml.XmlNodeReader $xaml4)
$xamlForm4=[Windows.Markup.XamlReader]::Load( $xmlreader4 )

$xaml4.SelectNodes("//*[@Name]") | ForEach-Object -Process {
    Set-Variable -Name ($_.Name) -Value $xamlForm4.FindName($_.Name)
    }
	
$Master_password_on_btn = $xamlForm4.FindName("Master_password_on_btn")
$Master_password_box1 = $xamlForm4.FindName("Master_password_box1")

$Master_password_on_btn.Add_Click({

$Global:MasterPasswordforimport = $Master_password_box1.Password
Write-Host "MasterPasswordforimport: $Global:MasterPasswordforimport"  # Debug output

$data = Get-Content -LiteralPath $Global:import_file

$output = @()

foreach ($i in $data) {
    $data = Invoke-AESEncryption -Mode Decrypt -Key $Global:MasterPasswordforimport -Text $i
    $output += $data
    Start-Sleep -Milliseconds 20
}

# Split the decrypted data into individual lines
$lines = $output -split "`n"

# Define a regular expression pattern to match the desired elements
$pattern = "IP:(.+?)\s+Username:(.+?)\s+Password:(.+?)(?:\s+Platform:(.+?))?(?:\s+Location:(.+)|\s+Location:)"


$resultArray = @()

# Iterate through each line and extract the values
foreach ($line in $lines) {
    if ($line -match $pattern) {
        $ip = $Matches[1]
        $username = $Matches[2]
        $password = $Matches[3]
        $Platform = $Matches[4]
        $Location = $Matches[5]
        $resultObject = [PSCustomObject]@{
            IP = $ip
            Username = $username
            Password = $password
            Platform = $Platform
            Location = $Location
        }

        $resultArray += $resultObject
    }
}

$resultArray | foreach-object{

$textToEncrypt = "Application\IP:$($_.IP) Username:$($_.Username) Password:$($_.Password) Platform:$($_.Platform) Location:$($_.Location)"
Invoke-AESEncryption -Mode Encrypt -Key $Global:Master_Password -Text $textToEncrypt | Out-File -LiteralPath $global:filepath -Append
Start-Sleep -Milliseconds 20

}

[System.Windows.Forms.MessageBox]::Show("Import has been successful, Kindly restart the application before doing any modification or you might loose the data.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
data_grid

$xamlForm4.Close()

})


 
} catch {
    [System.Windows.Forms.MessageBox]::Show("An error occurred: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

$xamlForm4.ShowDialog() | out-null

})


$About_me = $xamlForm2.FindName("About_me")
$About_me.Add_Click({
[System.Windows.MessageBox]::Show("Version: 1.2.0 `nAuthor : Pavan G S `nBuild Date: 21st October 2023 `nWebsite: https://pavansridhar.co.in/", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)

# After displaying the message box, get its window handle
$mbWindow = [System.Windows.Interop.HwndSource]::FromHwnd((Get-Process -Id $pid).MainWindowHandle)

# Calculate the screen dimensions
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

# Calculate the position for the message box to be in the center
$left = [math]::Round(($screen.Width - $mbWindow.RootVisual.ActualWidth) / 2)
$top = [math]::Round(($screen.Height - $mbWindow.RootVisual.ActualHeight) / 2)
})

function Refresh-DataGrid {
    # Assuming that $dataGrid1 is your DataGrid control
    $dataGrid1.ItemsSource = $resultArray
    $dataGrid1.Items.Refresh()
}

$new_btn = $xamlForm2.FindName("new_btn")
$new_btn.Add_Click({


$input3 = @’
<Window x:Name="Add_Password_mainfile"  x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Create_Master_Password"
        mc:Ignorable="d"
        Title="Add Password" Height="383" Width="546" WindowStyle="ToolWindow">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="FocusVisualStyle">
                <Setter.Value>
                    <Style>
                        <Setter Property="Control.Template">
                            <Setter.Value>
                                <ControlTemplate>
                                    <Rectangle StrokeThickness="0"/>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Setter.Value>
            </Setter>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border"
                            BorderThickness="3"
                            Width="{TemplateBinding Width}"
                            Height="{TemplateBinding Height}"
                            Background="{TemplateBinding Background}"
                            CornerRadius="6"
                            BorderBrush="#FF007892">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>

                        <ControlTemplate.Triggers>
                            <!-- Trigger for button click -->
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="RenderTransform">
                                    <Setter.Value>
                                        <ScaleTransform ScaleX="0.9" ScaleY="0.9"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
         <Style x:Key="CustomTextBoxStyle" TargetType="TextBox">
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TextBox">
                    <Border BorderThickness="1" BorderBrush="#FF007892" Background="#FFDDDDDD" CornerRadius="5">
                        <ScrollViewer x:Name="PART_ContentHost"/>
                    </Border>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    </Window.Resources>
    <Grid Background="#81Cae3">
        <Label x:Name="add_IP_lbl" Content="IP\Application:" HorizontalAlignment="Left" Margin="43,75,0,0" VerticalAlignment="Top" Width="126" FontWeight="Bold" FontStyle="Italic" FontSize="16" Height="30"/>
        <Label x:Name="add_user_lbl" Content="Username:" HorizontalAlignment="Left" Margin="43,123,0,0" VerticalAlignment="Top" Width="126" FontWeight="Bold" FontStyle="Italic" FontSize="16" Height="30"/>
        <Label x:Name="add_pass_lbl" Content="Password:" HorizontalAlignment="Left" Margin="43,169,0,0" VerticalAlignment="Top" Width="126" FontWeight="Bold" FontStyle="Italic" FontSize="16" Height="30"/>
        <Label x:Name="add_platform_lbl" Content="Platform:" HorizontalAlignment="Left" Margin="43,214,0,0" VerticalAlignment="Top" Width="126" FontWeight="Bold" FontStyle="Italic" FontSize="16" Height="30"/>
        <Label x:Name="add_location_lbl" Content="Location:" HorizontalAlignment="Left" Margin="43,262,0,0" VerticalAlignment="Top" Width="126" FontWeight="Bold" FontStyle="Italic" FontSize="16" Height="31"/>
        <Label Content="Add Credentials" HorizontalAlignment="Center" Margin="0,24,0,0" VerticalAlignment="Top" FontWeight="Bold" FontSize="24" FontFamily="Bookman Old Style"/>
        <TextBox x:Name="add_IP_txtbox" HorizontalAlignment="Left" Margin="207,79,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="289" Height="22" FontSize="14" Style="{StaticResource CustomTextBoxStyle}"/>
        <TextBox x:Name="add_user_txtbox" HorizontalAlignment="Left" Margin="207,127,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="289" Height="23" FontSize="14" Style="{StaticResource CustomTextBoxStyle}"/>
        <TextBox x:Name="add_pass_txtbox" HorizontalAlignment="Left" Margin="207,172,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="289" Height="23" FontSize="14" Style="{StaticResource CustomTextBoxStyle}"/>
        <TextBox x:Name="add_platform_txtbox" HorizontalAlignment="Left" Margin="207,218,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="289" Height="23" FontSize="14" Style="{StaticResource CustomTextBoxStyle}"/>
        <TextBox x:Name="add_location_txtbox" HorizontalAlignment="Left" Margin="207,266,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="289" Height="23" FontSize="14" Style="{StaticResource CustomTextBoxStyle}"/>
        <Button x:Name="add_cred" Content="Add" HorizontalAlignment="Left" Margin="403,310,0,0" VerticalAlignment="Top" Width="93" Height="26"/>
    </Grid>
</Window>
'@

$input3 = $input3 -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N' 
[xml]$xaml3 = $input3
$xmlreader3 = (New-Object System.Xml.XmlNodeReader $xaml3)
$xamlForm3 = [Windows.Markup.XamlReader]::Load($xmlreader3)

$add_cred = $xamlForm3.FindName("add_cred")
$add_IP_txtbox = $xamlForm3.FindName("add_IP_txtbox")
$add_user_txtbox = $xamlForm3.FindName("add_user_txtbox")
$add_pass_txtbox = $xamlForm3.FindName("add_pass_txtbox")
$add_platform_txtbox = $xamlForm3.FindName("add_platform_txtbox")
$add_location_txtbox = $xamlForm3.FindName("add_location_txtbox")




$add_cred.Add_Click({

    $textToEncrypt = "Application\IP:$($add_IP_txtbox.Text) Username:$($add_user_txtbox.Text) Password:$($add_pass_txtbox.Text) Platform:$($add_platform_txtbox.Text) Location:$($add_location_txtbox.Text)"
    
    # Escape the '$' character to ensure it's treated as a regular character
    $textToEncrypt = $textToEncrypt -replace '\$', '$'
    Invoke-AESEncryption -Mode Encrypt -Key $Global:Master_Password -Text $textToEncrypt | Out-File -LiteralPath $global:filepath -Append


    data_grid



    $xamlForm3.Close()
})

$xamlForm3.ShowDialog() | Out-Null
})

$xamlForm2.ShowDialog() | out-null
}

})


$xamlForm.ShowDialog() | out-null