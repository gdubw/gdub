# DEFAULTS may be overridden by calling environment.
Param(
    [string] $gradle = "${GRADLE:-gradle}",
    [string] $gradlew = "${GRADLEW:-gradlew}",
    [string] $gradle_buildfile = "${GRADLE_BUILDFILE:-build.gradle}",
    [string] $gradle_kts_buildfile = "${GRADLE_KTS_BUILDFILE:-build.gradle.kts}"
)

Function err
{
    Write-Error "$args"
}

Function lookup($file, $curr_path)
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
            $curr_path = Split-Path -Path $curr_path -parent
        }
    } while ( [string]::IsNullOrEmpty($curr_path) )
}

Function select_gradle($dir)
{
    # Use project's gradlew if found.
    $gradlew = lookup ($gradlew, $dir)
    if ( [string]::IsNullOrWhiteSpace($gradlew))
    {
        Write-Error "No $GRADLEW set up for this project; consider setting one up:"
        Write-Error "http://gradle.org/docs/current/userguide/gradle_wrapper.html\n"
    }
    else
    {
        return $gradlew
    }

    # Deal with a missing wrapper by defaulting to system gradle.
    $gradle = which "$GRADLE"
    if ( [string]::IsNullOrWhiteSpace($gradle))
    {
        Write-Error "$GRADLE not installed or not available in your PATH:"
        Write-Error "$PATH"
    }
    else
    {
        return $gradle
    }
}

Function execute_gradle($build_gradle, $build_gradle_kts, $build_args)
{
    $build_gradle = lookup $build_gradle
    $build_gradle_kts = lookup $build_gradle_kts
    $gradle = select_gradle (Get-Location)

    if (Test-Path -Path $build_gradle or Test-Path -Path $build_gradle_kts)
    {
        $ktsDirName = Split-Path -Path $build_gradle_kts -parent
        $dirName = Split-Path -Path $build_gradle -parent
        if ( $ktsDirName.Contains($dirName))
        {
            $dirName = $ktsDirName
            $build_gradle = $build_gradle_kts
        }
        # We got a good build file, start gradlew there.
    }
    else
    {
        Write-Error  "Unable to find a gradle build file named $GRADLE_BUILDFILE or $GRADLE_KTS_BUILDFILE."
    }

    # Say what we are gonna do, then do it.
    Write-Error "Using gradle at '${gradle}' to run buildfile '${build_gradle}':\n"
    if ([string]::IsNullOrEmpty($build_args)) {
        Start-Process -FilePath $gradle -WorkingDirectory $dirName -Args $build_args
    } else {
        $gradle
    }
}

# gw may be sourced from other scripts as a library to select / run gradle(w).
execute_gradle((lookup $gradle_buildfile), (lookup $gradle_kts_buildfile), (select_gradle (Get-Location)), $args)

