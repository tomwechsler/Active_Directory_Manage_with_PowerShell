$EmailCredential = Get-Credential

$params = @{
    To = 'tom.wechsler@outlook.com'
    From = 'tom.wechsler@outlook.com'
    Credential = $EmailCredential
    Subject = 'Email subject line'
    Body = '<h1>Body</h1><p>this is the paragraph</p>'
    BodyAsHtml = $true
    SmtpServer = 'smtp.office365.com'
    UseSSL = $true
    Port = '587'
}


foreach($user in $data){
    Set-ADUser $user.Manager.Replace -EmailAddress 'tom.wechsler@outlook.com'
}
$global:From = 'tom.wechsler@outlook.com'

Send-MailMessage @params