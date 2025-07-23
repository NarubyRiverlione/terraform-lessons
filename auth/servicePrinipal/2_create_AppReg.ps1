param(
    [Parameter(Mandatory=$true)]
    [string]$CertPassword
)

# Variables (customize as needed)
$TenantId          = "531da535-cb20-4ea2-8674-09c9680a001b"
$AppName           = "terraform-auth"
$CertFileName      = "client.pfx"
$ResourceGroupName = "terraform-learn"
$Location          = "WestEurope"
$ValidityYears     = 1

# Derived values
$SubscriptionId = (Get-AzContext).Subscription.Id
$CertPath       = Join-Path (Get-Location) $CertFileName
$StartDate      = Get-Date
$EndDate        = $StartDate.AddYears($ValidityYears)
$scope          = "/subscriptions/$SubscriptionId"

function Ensure-AppRegistration {
    param($AppName, $IdentifierUris, $ReplyUrls, $AvailableToOtherTenants)
    $app = Get-AzADApplication -DisplayName $AppName -ErrorAction SilentlyContinue
    if ($app) {
        Write-Host "Found existing application '$AppName'."
        return $app
    }
    Write-Host "Creating Azure AD application '$AppName'..."
    # Attempt creation, suppress expected error if URI exists
    $app = New-AzADApplication `
        -DisplayName $AppName `
        -IdentifierUris $IdentifierUris `
        -ReplyUrls $ReplyUrls `
        -AvailableToOtherTenants $AvailableToOtherTenants `
        -ErrorAction SilentlyContinue
    if (-not $app) {
        Write-Host "Application already exists; retrieving existing application."
        $app = Get-AzADApplication -DisplayName $AppName
    }
    return $app
}

function Ensure-AppCredential {
    param($AppId, $CertValue, $StartDate, $EndDate)
    $existing = Get-AzADAppCredential -ApplicationId $AppId -ErrorAction SilentlyContinue
    if ($existing | Where-Object { $_.EndDate -eq $EndDate }) {
        Write-Host "Certificate credential already present."
        return
    }
    Write-Host "Adding certificate credential..."
    New-AzADAppCredential `
        -ApplicationId $AppId `
        -CertValue     $CertValue `
        -StartDate     $StartDate `
        -EndDate       $EndDate | Out-Null
}

function Ensure-ServicePrincipal {
    param($AppId)
    $sp = Get-AzADServicePrincipal -ApplicationId $AppId -ErrorAction SilentlyContinue
    if ($sp) {
        Write-Host "Found existing Service Principal."
        return $sp
    }
    Write-Host "Creating Service Principal..."
    return New-AzADServicePrincipal -ApplicationId $AppId
}

function Ensure-CustomRole {
    param($RoleName, $RoleDefinitionJson, $Scope)
    $role = Get-AzRoleDefinition -Name $RoleName -ErrorAction SilentlyContinue
    if ($role) {
        Write-Host "Found existing custom role '$RoleName'."
        return $role
    }
    Write-Host "Creating custom role '$RoleName'..."
    return $RoleDefinitionJson | ConvertFrom-Json | New-AzRoleDefinition
}

function Ensure-RoleAssignment {
    param($RoleName, $ObjectId, $Scope)
    $assignment = Get-AzRoleAssignment `
        -ObjectId $ObjectId `
        -RoleDefinitionName $RoleName `
        -Scope $Scope `
        -ErrorAction SilentlyContinue
    if ($assignment) {
        Write-Host "Role assignment already exists."
        return
    }
    Write-Host "Assigning role '$RoleName' to object '$ObjectId'..."
    New-AzRoleAssignment `
        -RoleDefinitionName $RoleName `
        -ObjectId           $ObjectId `
        -Scope              $Scope | Out-Null
}

# 1. App Registration
$app = Ensure-AppRegistration `
    -AppName $AppName `
    -IdentifierUris "https://$AppName.naruby.link" `
    -ReplyUrls "https://$AppName" `
    -AvailableToOtherTenants $false

$AppId = $app.AppId
write-Host "Application (Client) ID: $AppId"

# 2. Load certificate and prepare credential
Write-Host "Loading certificate from '$CertPath'..."
$securePwd = ConvertTo-SecureString $CertPassword -AsPlainText -Force
$cert      = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 `
    ($CertPath, $securePwd, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$certValue = [Convert]::ToBase64String($cert.RawData)

Ensure-AppCredential `
    -AppId $AppId `
    -CertValue $certValue `
    -StartDate $StartDate `
    -EndDate $EndDate

# 3. Service Principal
$sp = Ensure-ServicePrincipal -AppId $AppId

# 4. Custom Role
$roleDefinitionJson = @"
{
  "properties": {
    "roleName": "Terraform",
    "description": "Resource Group creation + RBAC\nStorage account read",
    "assignableScopes": [
      "/subscriptions/$SubscriptionId"
    ],
    "permissions": [
      {
        "actions": [
          "Microsoft.Resources/subscriptions/resourceGroups/delete",
          "Microsoft.Resources/subscriptions/resourceGroups/write",
          "Microsoft.Resources/subscriptions/resourceGroups/read",
          "Microsoft.Resources/subscriptions/read",
          "Microsoft.Authorization/roleAssignments/read",
          "Microsoft.Authorization/roleAssignments/write",
          "Microsoft.Authorization/roleAssignments/delete",
          "Microsoft.Storage/storageAccounts/read"
        ],
        "notActions": [],
        "dataActions": [],
        "notDataActions": []
      }
    ]
  }
}
"@

$customRole = Ensure-CustomRole `
    -RoleName "Terraform" `
    -RoleDefinitionJson $roleDefinitionJson `
    -Scope $scope

# 5. Role Assignment
Ensure-RoleAssignment `
    -RoleName $customRole.Name `
    -ObjectId $sp.Id `
    -Scope $scope

# Output summary
Write-Host ""
Write-Host "========== Summary =========="
Write-Host "Tenant ID:           $TenantId"
Write-Host "Subscription ID:     $SubscriptionId"
Write-Host "Application Name:    $AppName"
Write-Host "Application (Client) ID: $AppId"
Write-Host "Service Principal Object ID: $($sp.Id)"
Write-Host "Certificate Valid From: $StartDate"
Write-Host "Certificate Valid To:   $EndDate"
Write-Host "============================="
