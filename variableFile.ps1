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