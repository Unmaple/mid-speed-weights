$ErrorActionPreference='Stop'
$root='E:\MasterStudy\AdVance ComPact\experiments\compact_delta\prefix-throughput-20261026'
foreach($d in @('shared-ar-v9','shared-ar-v8','shared-ar-v7')){
  $base=Join-Path $root $d
  if(Test-Path -LiteralPath $base){
    Get-ChildItem -LiteralPath $base -File | Sort-Object Name | ForEach-Object {
      $h=(Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLower()
      Write-Output ($h + ' | ' + $_.Length + ' | ' + $d + '/' + $_.Name)
    }
  } else { Write-Output ('MISSING | 0 | ' + $d) }
}
