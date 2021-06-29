resource "azuread_user" "aksdev" {
  user_principal_name = "aksdev@damirovamiroutlook.onmicrosoft.com"
  display_name        = "aksdev"
  mail_nickname       = "aksdev"
  password            = "SecretP@sswd99!"
  job_title           = "developer"
}

resource "azuread_user" "akssre" {
  user_principal_name = "akssre@damirovamiroutlook.onmicrosoft.com"
  display_name        = "akssre"
  mail_nickname       = "akssre"
  password            = "SecretP@sswd99!"
  job_title           = "sreengineer"
}



resource "azuread_group" "appdev" {
  display_name = "appdev"
  members = [
    azuread_user.aksdev.object_id,
    /* more users */
  ]
}

resource "azuread_group" "opssre" {
  display_name = "opssre"
  members = [
    azuread_user.akssre.object_id,
    /* more users */
  ]
}