Param(
    [Hashtable]$parameters
)

Publish-BcContainerApp @parameters

$filename = [System.IO.Path]::GetFileName($parameters.appFile)
if ($filename -like "Microsoft_System Application_*.*.*.*.app") {
    $packagesFolder = Join-Path ([System.IO.Path]::GetDirectoryName($parameters.appFile)) "..\.packages" -Resolve

    Write-Host "Publishing Base Application"
    $parameters.appFile = Join-Path $packagesFolder "Microsoft_Base Application.app"
    Publish-BcContainerApp @parameters

    Write-Host "Publishing Application"
    $parameters.appFile = Join-Path $packagesFolder "Microsoft_Application.app"
    Publish-BcContainerApp @parameters
}
elseif ($filename -like "Microsoft_System Application Test_*.*.*.*.app") {
    $packagesFolder = Join-Path ([System.IO.Path]::GetDirectoryName($parameters.appFile)) "..\.packages" -Resolve

    Write-Host "Publishing Tests-TestLibraries"
    $parameters.appFile = Join-Path $packagesFolder "Microsoft_Tests-TestLibraries.app"
    Publish-BcContainerApp @parameters
}
