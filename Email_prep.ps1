$cred = Get-Credential

$params = @{
    To = 'email@email.com'
    From = 'email@email.com'
    Credential = $cred
    Subject = 'Email subject line'
    Body = '<h1>Body</h1><p>this is the paragraph</p>'
    BodyAsHtml = $true
    SmtpServer = 'smtp.office365.com'
    Port = 587
    UseSSL = $true
}


$global:From = 'email@email.com'
$global:To = 'email@email.com'