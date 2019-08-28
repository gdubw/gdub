


Function LookUpwards($file, $curr_path)
{
    $curr_path = if ( [string]::IsNullOrWhiteSpace($curr_path))
    {
        (Get-Location)
    }

    # Search recursively upwards for file.
    do
    {
        $isGradle = Join-Path -Path $curr_path $file
        if (Test-Path -Path $isGradle)
        {
            return $isGradle
        }
        else
        {
            $curr_path = Split-Path -Path $curr_path -Parent
        }
    } while ( [string]::IsNullOrEmpty($curr_path) )
}

Function select_build($build_gradle, $build_gradle_kts)
{
    $valid_bgk = ![string]::IsNullOrWhiteSpace($build_gradle_kts)
    $valid_bg = ![string]::IsNullOrWhiteSpace($build_gradle)

    if (!$valid_bg -and !$valid_bgk)
    {
        Write-Error "Unable to find a gradle build file named $build_gradle or $build_gradle_kts."
        exit
    }
    elseif ($valid_bg -and !$valid_bgk)
    {
        return $build_gradle
    }
    elseif (!$valid_bg -and $valid_bgk)
    {
        return $build_gradle_kts
    }
    elseif ((Test-Path -LiteralPath "$build_gradle", "$build_gradle_kts") -contains $true)
    {
        $ktsDirName = Split-Path -Path "$build_gradle_kts" -Parent
        $dirName = Split-Path -Path "$build_gradle" -Parent
        if ( $ktsDirName.Contains($dirName))
        {
            return $build_gradle_kts
        }
        else
        {
            return $build_gradle
        }
        # We got a good build file, start gradlew in its directory.
    }
    else
    {
        Write-Host  "Unable to find a gradle build file named $build_gradle or $build_gradle_kts."
        exit
    }
}

Function select_gradlew($gradlew)
{
    # Use project's gradlew if found.
    $gradlewPath = LookUpwards $gradlew
    if ( [string]::IsNullOrWhiteSpace($gradlewPath))
    {
        Write-Host "No $gradlew set up for this project; consider setting one up: ",
           "http://gradle.org/docs/current/userguide/gradle_wrapper.html"
    }
    else
    {
        return $gradlewPath
    }
}

Function select_gradle($gradle)
{
    $gradlePath = (Get-Command -Name $gradle).Path
    if ( [string]::IsNullOrWhiteSpace($gradlePath))
    {
        Write-Host "$gradle not installed or not available in your PATH: $Env:PATH"
        exit
    }
    else
    {
        return $gradlePath
    }
}

Function execute_gradle($gradlew, $gradle, $build_gradle_path, $build_args)
{
    # Say what we are gonna do, then do it.
    $build_dir = Split-Path -Path $build_gradle_path -Parent

    $valid_gradlew = ![string]::IsNullOrEmpty($gradlew)
    $valid_gradle = ![string]::IsNullOrEmpty($gradle)
    $valid_args = ![string]::IsNullOrEmpty($build_args)

    Write-Host "`$build_gradle='$build_gradle_path'"
    Write-Host "`$working_dir='$build_dir'"

    if ($valid_args) {
        Write-Host "`$args='$build_args'"
    }
    if ($valid_gradlew) {
        Write-Host "`$gradle_proc='$gradlew'"
        if ($valid_args)
        {
            Start-Process -FilePath "$gradlew" -Verb 'Open' -WorkingDirectory $build_dir -Args $build_args
        } else
        {
            Start-Process -FilePath "$gradlew" -Verb 'Open'  -WorkingDirectory $build_dir
        }
    }
    elseif ($valid_gradle)
    {
        Write-Host "`$gradle_proc='$gradle'"
        if ($valid_args)
        {
            Start-Process -FilePath $gradle -Verb 'Open'  -WorkingDirectory $build_dir -Args $build_args
        }
        else
        {
            Start-Process -FilePath $gradle -Verb 'Open' -WorkingDirectory $build_dir
        }
    }
    else {
        Write-Host "no gradle process"
    }
}

Function GradleWrapper
{
    Param(
    [string] $gradle = "gradle.exe",
    [string] $gradlew = "gradlew.bat",
    [string] $gradle_buildfile = "build.gradle",
    [string] $gradle_kts_buildfile = "build.gradle.kts",
    [string] $gradle_task = $Task
    )

    $gradleBuildPath = LookUpwards $gradle_buildfile
    $gradleBuildKtsPath = LookUpwards $gradle_kts_buildfile
    $gradleBuildSelectedPath = select_build $gradleBuildPath $gradleBuildKtsPath

    $gradlewPath = select_gradlew $gradlew
    $gradlePath = select_gradle $gradle
    Write-Host "select_gradlew ", $gradlew, " : ", $gradlewPath

    Write-Host "execute"
    execute_gradle $gradlewPath $gradlePath $gradleBuildSelectedPath $gradle_task
}

Function GDub ($task) {
    Write-Host "gdub"
    GradleWrapper -Task $task
}

Set-Alias -Name gw -Value GDub

Export-ModuleMember -Function 'GradleWrapper','GDub','LookUpwards'
Export-ModuleMember -Alias 'gw'
