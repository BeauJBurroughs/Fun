# Specify the URL of the webpage
$webPageUrl = "http://landing.shmoocon.org"

# Specify log files
$logFile = "shmoo_log.txt"
$previousLinksFile = "previous_links.txt"

# Ensure log files exist
if (-Not (Test-Path $logFile)) { New-Item -Path $logFile -ItemType File -Force | Out-Null }
if (-Not (Test-Path $previousLinksFile)) { New-Item -Path $previousLinksFile -ItemType File -Force | Out-Null }

# Function to write logs
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $message"
    Add-Content -Path $logFile -Value $logMessage
    Write-Output $logMessage # Optional: display in the console
}

# Function to process new links
function Process-NewLink {
    param ([string]$link)

    try {
        # Open only links that match the desired pattern in Chrome
        if ($link -like "http://tix.shmoocon.org/form_*") {
            Start-Process "chrome.exe" $link
            Write-Log "Opened $link in Chrome."
        } else {
            Write-Log "Skipped opening $link as it doesn't match the pattern."
        }

        # Fetch the content of the link
        $response = Invoke-WebRequest -Uri $link -Method GET -ErrorAction Stop
        $content = $response.Content

        # Look for <form> elements with action='/hold_'
        $formActionMatch = Select-String -InputObject $content -Pattern "<form.*?action=['""](/hold_.*?)['""]" -AllMatches
        if ($formActionMatch.Matches.Count -gt 0) {
            $actionUrl = $formActionMatch.Matches[0].Groups[1].Value
            $fullActionUrl = [System.Uri]::new($response.BaseResponse.ResponseUri, $actionUrl).AbsoluteUri
            Write-Log "Found form with action URL: $fullActionUrl"

            # Find "The word you want is" followed by capital letters
            $wordMatch = Select-String -InputObject $content -Pattern "The word you want is ([A-Z]+)" -AllMatches
            if ($wordMatch.Matches.Count -gt 0) {
                $capitalLetters = $wordMatch.Matches[0].Groups[1].Value
                Write-Log "Found capital letters: $capitalLetters"

                # Send POST request with the extracted capital letters
                try {
                    $postResponse = Invoke-WebRequest -Uri $fullActionUrl -Method POST -Body @{data = $capitalLetters} -ErrorAction Stop
                    Write-Log "Sent POST to ${fullActionUrl} with data: $capitalLetters"
                    Write-Log "Response: $($postResponse.Content)"
                } catch {
                    Write-Log "Failed to send POST request to ${fullActionUrl}: $_"
                }
            } else {
                Write-Log "No capital letters found following 'The word you want is'."
            }
        } else {
            Write-Log "No form with action='/hold_' found on $link"
        }
    } catch {
        Write-Log "Failed to process link: $link - $_"
    }
}

# Function to fetch and process links
function Check-For-NewLinks {
    try {
        # Load the HTML content of the webpage
        $webContent = Invoke-WebRequest -Uri $webPageUrl -ErrorAction Stop
        Write-Log "Successfully loaded the webpage."
    } catch {
        Write-Log "Failed to load the webpage: $_"
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

    # Filter for links starting with the specified prefix
    $filteredLinks = $absoluteLinks | Where-Object { $_ -like "http://tix.shmoocon.org/form_*" }

    # Load previously logged links
    $previousLinks = @()
    if (Test-Path $previousLinksFile) {
        $previousLinks = Get-Content -Path $previousLinksFile
    }

    # Find new links
    $newLinks = $filteredLinks | Where-Object { $previousLinks -notcontains $_ }

    # Handle new links
    foreach ($link in $newLinks) {
        Write-Log "New URL: $link"
        Process-NewLink -link $link
    }

    # Update the list of known links
    $filteredLinks | Set-Content -Path $previousLinksFile
}

# Continuous monitoring loop
while ($true) {
    Write-Log "Checking for new links..."
    Check-For-NewLinks
}
