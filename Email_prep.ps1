$params = @{
    To = 'email@email.com'
    From = 'email@email.com'
    Credential = $cred
    Subject = 'Email subject line'
    Body = '<h1>Body</h1><p>this is the paragraph</p>'
    BodyAsHtml = $true
    SmtpServer = 'smtp.office365.com'
    UseSSL = $true
}


foreach($user in $data){
    Set-ADUser $user.Manager.Replace(' ','.') -EmailAddress 'email@email.com'
}
$global:From = 'email@email.com'

$cred = Get-Credential