# Initialize previous content as an empty string
$previous_contentb64 = "PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KICA8aGVhZD4KICAgIDxtZXRhIGNoYXJzZXQ9InV0Zi04Ij4KICAgIDx0aXRsZT5TaG1vb0NvbiAyMDI1IFRpY2tldCBTYWxlczwvdGl0bGU+CiAgICA8bGluayBocmVmPSJodHRwOi8vZm9udHMuZ29vZ2xlYXBpcy5jb20vY3NzP2ZhbWlseT1PcGVuK1NhbnMiIHJlbD0ic3R5bGVzaGVldCIgdHlwZT0idGV4dC9jc3MiPgogICAgPGxpbmsgaHJlZj0ic3R5bGVzL3N0eWxlLmNzcyIgcmVsPSJzdHlsZXNoZWV0IiB0eXBlPSJ0ZXh0L2NzcyI+CiAgPC9oZWFkPgogIDxib2R5PgogICAgPGgxPlNobW9vQ29uIFRpY2tldHM8L2gxPgogICAgPGltZyBzcmM9IlNobW9vY29uLWxvZ28ucG5nIiBhbHQ9IlRoZSBTaG1vb0NvbiBMb2dvIj4KCiAgICA8cD5XZWxjb21lIHRvIDxhIGhyZWY9Imh0dHBzOi8vd3d3LnNobW9vY29uLm9yZy9odW1hbi1yZWdpc3RyYXRpb24vIj5TaG1vb0NvbiB0aWNrZXQgc2FsZXM8L2E+LgogICAgICBUaGUgZmlyc3Qgcm91bmQgb2YgdGlja2V0cyB3aWxsIGdvIG9uIHNhbGUgb24gTm92ZW1iZXIgMXN0IGF0IG5vb24gRURULiBZZXMsIGl0J3Mgc3RpbGwgZGF5bGlnaHQgc2F2aW5ncyB0aW1lLiBZZXMsIGl0J3MgdmVyeSBkYXJrIG91dCBpbiB0aGUgbW9ybmluZy4gV2FpdCB1bnRpbCBuZXh0IHdlZWsuIEl0IHdpbGwgYmUgYmV0dGVyLjwvcD4KCiAgICA8dWw+IDwhLS0gY2hhbmdlZCB0byBsaXN0IGluIHRoZSB0dXRvcmlhbCAtLT4KICAgICAgPGxpPjxhIGhyZWY9Imh0dHBzOi8vc2htb29jb24ub3JnLyI+U2htb29Db248L2E+PC9saT4KICAgICAgPGxpPjxhIGhyZWY9Imh0dHBzOi8vd3d3LnNobW9vY29uLm9yZy9odW1hbi1yZWdpc3RyYXRpb24vIj5UaWNrZXQgU2FsZXMgSW5mbzwvYT48L2xpPgogICAgICA8bGk+PGEgaHJlZj0iaHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS9zZWFyY2g/cT1Nb29zZStiZWluZytmdW5ueSZzY2xpZW50PWltZyI+V2hlcmUncyB0aGUgTW9vc2U/PC9hPjwvbGk+CiAgICA8L3VsPgoKICAgIDxwPklmIHlvdSdyZSBsb29raW5nIGZvciBhbGwgU2htb29Db24gYXJjaGl2ZXMsIHdlJ3ZlCiAgICAgIGdvdCA8YSBocmVmPSJodHRwczovL2FyY2hpdmUub3JnL2RldGFpbHMvc2htb29jb24yMDI0Ij50aGF0IG9ubGluZSB0b288L2E+LjwvcD4KCiAgPC9ib2R5Pgo8L2h0bWw+Cg=="
$previous_content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($previous_contentb64))
while ($true) {
    # Retrieve the current content of the webpage
    $current_content = (Invoke-WebRequest -Uri "http://landing.shmoocon.org/").Content
    
    # Compare the current content with the previous content
    if ($current_content -ne $previous_content) {
        # Content has changed
        Write-Host "Content has changed! Go GO GOOOOOO"
        # Check for the existence of Firefox or Google Chrome
        $chrome = Get-Command "C:\Program Files\Google\Chrome\Application\chrome.exe" -ErrorAction SilentlyContinue
        $firefox = Get-Command "C:\Program Files\Mozilla Firefox\firefox.exe" -ErrorAction SilentlyContinue
        if ($chrome) {
            # Google Chrome is available, launch it
            & $chrome "http://landing.shmoocon.org/"
            } elseif ($firefox) {
            # Firefox is available, launch it
            & $firefox "http://landing.shmoocon.org/"
            } else {
            # No supported browser found
            Write-Host "No supported browser found."
        }
        break
        # Update the previous content variable
        $previous_content = $current_content
    }
    
    # Wait for a short interval before checking again
#    Start-Sleep -Seconds 1
    Write-Host "no changes yet"
}
