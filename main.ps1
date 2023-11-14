. 'C:/Users/shardi/Desktop/VS Code/Scripting/Basic-Training-PowerShell/restAPI/UK_Public_Holiday_RESTApi.ps1'
# main script to get the deatils
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