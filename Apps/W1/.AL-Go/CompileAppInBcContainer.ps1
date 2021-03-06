Param(
    [Hashtable] $parameters
)

$appFile = Compile-AppInBcContainer @parameters

if ($appFile) {
    $filename = [System.IO.Path]::GetFileName($appFile)
    if ($filename -like "Microsoft_System Application_*.*.*.*.app") {
        # System application compiled - add BaseApp and Application app from container to output
        Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock {
            $baseApp = "C:\Applications.*\Microsoft_Base Application_*.*.*.*.app"
            if (-not (Test-Path $baseApp)) {
                $baseApp = "C:\Applications\BaseApp\Source\Microsoft_Base Application.app"
            }
            Write-Host "Copying Base Application to packages path"
            Copy-Item -Path $baseApp -Destination "c:\Run\my\Microsoft_Base Application.app"

            $application = "C:\Applications.*\Microsoft_Application_*.*.*.*.app"
            if (-not (Test-Path $application)) {
                $application = "C:\Applications\Application\Source\Microsoft_Application.app"
            }
            Write-Host "Copying Application to packages path"
            Copy-Item -Path $application -Destination "c:\Run\my\Microsoft_Application.app"

            $testLibrariesApp = "C:\Applications.*\Microsoft_Tests-TestLibraries_*.*.*.*.app"
            if (-not (Test-Path $testLibrariesApp)) {
                $testLibrariesApp = "C:\Applications\BaseApp\Test\Microsoft_Tests-TestLibraries.app"
            }
            Write-Host "Copying Tests-TestLibraries to packages path"
            Copy-Item -Path $testLibrariesApp -Destination "c:\Run\my\Microsoft_Tests-TestLibraries.app"
        }
    }
}
$appFile
