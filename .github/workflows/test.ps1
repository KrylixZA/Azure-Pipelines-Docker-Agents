$buildNumber = "1.0.0.1";
$branchName = "master";
$branchName = $branchName -replace ".*/";
$buildId = "$buildNumber-$branchName";
if ($branchName -eq "master") {
    $buildId = $buildNumber;
}
Write-Host $buildNumber;
Write-Host $branchName;
Write-Host $buildId;