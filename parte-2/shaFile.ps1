function Get-FileSHA1() {
  <#  adicionamos restrição de tipo ao argumento $filePath para aumentar a
  robustez de nossa função e impedir que valores de tipo diferentes sejam usados;
  deste modo prevenimos comportamentos inesperados, que podem representar bugs e
  falhas de segurança. A robustez de restringir os tipos dos argumentos representa um benefício! #>
  param (
    [Parameter(
      ValueFromPipeline = $true,
      <# Definindo o atributo Parameter podemos mudar o valor que é obtido através do pipeline
      quando o objeto enviado possuir a propriedade nomeada em ValueFromPipelineByPropertyName,
      ou seja, esta propriedade indica que o PowerShell pode enviar a esta função apenas o valor
      da propriedade indicada, ao invés do objeto inteiro: #>
      ValueFromPipelineByPropertyName = "FullName",
      Mandatory = $true
    )]
    [string] $filePath
  )

  # Bloco de início, onde carregaremos os recursos utilizados por todos os itens recebidos pelo pipeline!
  begin {
    $sha1 = New-Object System.Security.Cryptography.SHA1Managed
    $prettyHashSB = New-Object System.Text.StringBuilder
  }

  # Bloco de processamento. Aqui serão executados os comandos a seguir para todos os itens de nosso pipeline.
  process {
    $fileContent = Get-Content $filePath
    <# Para criar uma instância de objeto .NET no PowerShell, nós devemos utilizar
    o cmdlet New-Object e usar como argumento o nome completo (nome e namespace)
    da classe: [namespace.da.classe]::objetos/propriedades #>
    $fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)

    $hash = $sha1.ComputeHash($fileBytes)

    foreach ($byte in $hash) {
      $hexNotation = $byte.toString("X2")

      <# No PowerShell, qualquer expressão que retorna um valor, caso ele não
      seja armazenado em uma variável, ele vai para a saída; para evitar isso,
      usamos o pipe para passar o valor para o cmdlet Out-Null: #>
      # $prettyHashSB.Append($hexNotation) | Out-Null  # o String Builder retorna ele mesmo a cada iteração

      <# Porém, o Out-Null possui problemas de performance, e uma forma mais
      performática e tão elegante quanto de se realizar a mesma ação é redirecionar
      a saída para um arquivo nulo, com o operador > para $null: #>
      $prettyHashSB.Append($hexNotation) > $null
    }

    $prettyHashSB.ToString()
    # para evitar append de valores anteriores e de outros arquivos:
    $prettyHashSB.Clear() > $null
  }

  # Bloco de fim, onde devemos liberar os recursos criados durante a execução de nossa função.
  # No caso, precisamos invocar o método Dispose do objeto IDisposable SHA1Managed.
  end {
    $sha1.Dispose()
  }
}

function Get-FileSHA256() {
  param(
    [Parameter(
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = "FullName",
      Mandatory = $true
    )]
    [string] $filePath
  )

  begin {
    $sha256 = New-Object System.Security.Cryptography.SHA256Managed
    $prettyHashSB = New-Object System.Text.StringBuilder
  }

  process {
    $fileContent = Get-Content $filePath
    $fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)

    $hash = $sha256.ComputeHash($fileBytes)
    foreach ($byte in $hash) {
      $hexNotation = $byte.toString("X2")
      $prettyHashSB.Append($hexNotation) > $null
    }

    $prettyHashSB.ToString()
    $prettyHashSB.Clear() > $null
  }

  end {
    $sha256.Dispose()
  }
}

function Get-FileSHA384() {
  param(
    [Parameter(
      Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName = "FullName"
    )]
    [string] $filePath
  )

  begin {
    $sha384 = New-Object System.Security.Cryptography.SHA384Managed
    $prettyHashSB = New-Object System.Text.StringBuilder
  }

  process {
    $fileContent = Get-Content $filePath
    $fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)

    $hash = $sha384.ComputeHash($fileBytes)
    foreach ($byte in $hash) {
      $hexNotation = $byte.toString("X2")
      $prettyHashSB.Append($hexNotation) > $null
    }

    $prettyHashSB.ToString()
    $prettyHashSB.Clear() > $null
  }

  end {
    $sha384.Dispose()
  }
}

function Get-FileSHA512() {
  param(
    [Parameter(
      Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName = "FullName"
    )]
    [string] $filePath
  )

  begin {
    $sha512 = New-Object System.Security.Cryptography.SHA512Managed
    $prettyHashSB = New-Object System.Text.StringBuilder
  }

  process {
    $fileContent = Get-Content $filePath
    $fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)

    $hash = $sha512.ComputeHash($fileBytes)
    foreach ($byte in $hash) {
      $hexNotation = $byte.toString("X2")
      $prettyHashSB.Append($hexNotation) > $null
    }

    $prettyHashSB.ToString()
    $prettyHashSB.Clear() > $null
  }

  end {
    $sha512.Dispose()
  }
}

$file = "..\parte-1\report.json"

$fileHashSHA1 = Get-FileSHA1 $file
$fileHashSHA256 = Get-FileSHA256 $file 
$fileHashSHA384 = Get-FileSHA384 $file
$fileHashSHA512 = Get-FileSHA512 $file 

Write-Host "Hash SHA1 do arquivo ${file}: $fileHashSHA1"
Write-Host "Hash SHA256 do arquivo ${file}: $fileHashSHA256"
Write-Host "Hash SHA384 do arquivo ${file}: $fileHashSHA384"
Write-Host "Hash SHA512 do arquivo ${file}: $fileHashSHA512"
