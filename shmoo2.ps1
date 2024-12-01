# Specify the URL of the webpage
$webPageUrl = "http://landing.shmoocon.org"

# Specify the log files
$logFile = "links_log.txt"
$previousLinksFile = "previous_links.txt"

# Ensure log file exists
if (-Not (Test-Path $logFile)) { New-Item -Path $logFile -ItemType File -Force | Out-Null }
if (-Not (Test-Path $previousLinksFile)) { New-Item -Path $previousLinksFile -ItemType File -Force | Out-Null }

# Function to fetch and process links
function Check-For-NewLinks {
    try {
        # Load the HTML content of the webpage
        $webContent = Invoke-WebRequest -Uri $webPageUrl -ErrorAction Stop
        Write-Output "Nothing new yet... "
    } catch {
        Write-Output "Failed to load the webpage: $_"
        return
    }

    # Parse all the links from the webpage
    $links = $webContent.Links | Where-Object { $_.href -ne $null } | Select-Object -ExpandProperty href

    # Resolve relative links to absolute URLs
    $absoluteLinks = @()
    foreach ($link in $links) {
        if ($link -notmatch "^http[s]?://") {
            $absoluteLinks += [System.Uri]::new($webContent.BaseResponse.ResponseUri, $link).AbsoluteUri
        } else {
            $absoluteLinks += $link
        }
    }

    # Load previously logged links
    $previousLinks = @()
    if (Test-Path $previousLinksFile) {
        $previousLinks = Get-Content -Path $previousLinksFile
    }

    # Find new links
    $newLinks = $absoluteLinks | Where-Object { $previousLinks -notcontains $_ }

    # Handle new links
    foreach ($link in $newLinks) {
        try {
            # Log the link
            Add-Content -Path $logFile -Value "New URL: $link"
            Add-Content -Path $logFile -Value "`n---`n" # Separator
            Write-Output "Logged new link: $link"

            # Open the link in the default web browser
            Start-Process $link
        } catch {
            Write-Output "Failed to handle link: $link"
        }
    }

    # Update the list of known links
    $absoluteLinks | Set-Content -Path $previousLinksFile
}

# Continuous monitoring loop
while ($true) {
    Check-For-NewLinks
}
