# declaring variables
$uri = [string](Read-Host "Enter the url")
$area = (Read-Host "Enter the area")
$year = [int](Read-Host "Enter the year")
$startDateOfYear = Get-Date @startDateParameter
$endDateOfYear = Get-Date @endDateParameter
# wrapping parameters
$urlParameter = @{
    uri = $uri
}
$areaParameter = @{
    area = $area
}
$yearParameter = @{
    year = $year
}
$startDateParameter = @{
    year  = $year
    month = 1
    day   = 1
}
$endDateParameter = @{
    year  = $year
    month = 12
    day   = 31
}
$publicHolidayParameter = @{
    uri  = $uri
    area = $area
    year = $year
}
# function to invoke the API
function Invoke-Api {
    param(
        $uri
    )
    try {
        $response = Invoke-RestMethod -Uri $uri
        return $response
    }
    catch {
        Write-Host "Error invoking API: $_"
        return $null
    }   
}
# function to get public holiday
function Get-PublicHoliday {
    param(
        $uri,
        [string]$area,
        [int]$year
    )
    $response = Invoke-Api @urlParameter
    if ($null -eq $response) {
        return $null
    }
    else {
        $holidays = $response.$area.events.date | Where-Object { $_ -like "$year-*" } 
        return $holidays
    }
}
# function to get the working days
function Get-WorkingDays {
    param(
        [int]$year
    )
    $holidays = Get-PublicHoliday @publicHolidayParameter
    $workingDays = 0
    while ($startDateOfYear -le $endDateOfYear) {
        if ($startDateOfYear.DayOfWeek -ne "Saturday" -and $startDateOfYear.DayOfWeek -ne "Sunday" -and $holidays -notcontains $startDateOfYear.ToString("yyyy-MM-dd")) {
            $workingDays++
        }
        $startDateOfYear = $startDateOfYear.AddDays(1)
    }
    return $workingDays
}
# function to get the weekends
function Get-Weekend {
    param(
        [int]$year
    )
    $weekendCount = 0
    while ($startDateOfYear -le $endDateOfYear) {
        if ($startDateOfYear.DayOfWeek -eq "Saturday" -or $startDateOfYear.DayOfWeek -eq "Sunday") {
            $weekendCount++
        }
        $startDateOfYear = $startDateOfYear.AddDays(1)
    }
    return $weekendCount
}
# function to get the weekends excluding public holiday
function Get-WeekendExcludingPublicHoliday {
    param(
        [int]$year
    )
    $weekendCount = Get-Weekend -year $year
    $holidays = Get-PublicHoliday @publicHolidayParameter
    if ($holidays -notcontains $startDateOfYear.ToString('YYYY-MM-DD')) {
        $holidayCount = $holidays.Count
    }
    $weekendCountExcludingPublicHoliday = $weekendCount - $holidayCount
    return $weekendCountExcludingPublicHoliday
}
# main script to get the deatils
try {
    $workingDays = Get-WorkingDays @yearParameter
    $weekendCount = Get-Weekend @yearParameter
    $weekendCountExcludingPublicHoliday = Get-WeekendExcludingPublicHoliday @yearParameter
    $holidays = Get-PublicHoliday @publicHolidayParameter
    $publicHolidays = $holidays.Count
    $result = [PSCustomObject]@{
        "Year"                              = $year
        "Public holidays"                   = $publicHolidays
        "Working Days"                      = $workingDays
        "Weekends"                          = $weekendCount
        "Weekends Excluding Public Holiday" = $weekendCountExcludingPublicHoliday
    }
    $result | Format-Table -AutoSize
}
catch {
    Write-Host "An error occurred: Please enter the valid year "
}