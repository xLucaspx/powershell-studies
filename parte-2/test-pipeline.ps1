function Test-Pipeline {
  param(
    [Parameter(ValueFromPipeline)] $numero
  )

  begin {
    Write-Host "begin"
  }
  process {
    Write-Host $numero
  }
  end {
    Write-Host "end"
  }
}

1..5 | Test-Pipeline
<# begin 1 2 3 4 5 end

Sempre que invocamos uma função, a engine do PowerShell atualiza
o valor da variável automática $input com os valores dos argumentos! #>
