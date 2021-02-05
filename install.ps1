
$ProfileRoot = (Split-Path -Parent $Profile)
New-Item -Path $ProfileRoot\Modules\GradleWrapper -ItemType directory
Copy-Item -Path .\bin\GradleWrapper.psm1 -Destination $ProfileRoot\Modules\GradleWrapper\GradleWrapper.psm1 -Force
Copy-Item -Path .\bin\GradleWrapper.psd1 -Destination $ProfileRoot\Modules\GradleWrapper\GradleWrapper.psd1 -Force

