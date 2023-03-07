function Install-WindowsFeatureInServers {
  param(
    [string[]] $computers,
    [string] $featureName
  )

  <# ScriptBlock a ser executado por cada Job! Note que com o PowerShell, podemos guardar
  uma variável de ScriptBlock com dependência de parâmetros, como fazemos a seguir: #>   
  $jobScriptBlock = {
    param(
      [string] $computerName,
      [string] $featureName
    )
    # Chamada ao cmdlet do módulo Remote Server Administration Tools (RSAT)
    Install-WindowsFeature -ComputerName $computerName -Name $featureName
  }

  $computers | ForEach-Object {
    <# Iniciamos o Job com a função $jobScriptBlock passando por argumento
    a variável de iteração representando um computador e o nome da Feature #>
    Start-Job -Name "Job_$_" -ScriptBlock $jobScriptBlock -ArgumentList ($_, $featureName)
  }
}

# quando há uma tarefa que será realizada de forma paralela e independente em várias máquinas, uma boa forma de realizá-la é um Job.

<# O cmdlet Receive-Job, a fim de economizar recursos da máquina, exclui o
resultado obtido de um Job após a primeira vez que o recuperamos. Alternativas
para mantermos o valor do Job em nossa sessão do PowerShell: #>
# Receive-Job Job1 -Keep
# $resultado = Receive-Job Job1

<#
# O cmdlet Receive-Job recupera o resultado de um Job, enquanto que o cmdlet Get-Job
apenas retorna informações sobre o Job. Representar o estado de um Job por meio de seu
nome, status de execução, comando, etc. é diferente da representação de seu valor retornado.
Para a representação do estado de um Job utilizamos o cmdlet Get-Job enquanto que para recebermos
seu valor retornado, usamos o cmdlet Receive-Job.

# O resultado do cmdlet Receive-Job não é do tipo original gerado pelo Job. Ele é, na verdade, um
valor deserializado. Por conta do isolamento que existe entre nossa sessão e a sessão criada para
um Job, é exigido a serialização do valor pelo PowerShell para se recuperar o valor de um job!

# O cmdlet Receive-Job retorna somente uma vez o resultado de um Job, a não ser que usemos o switch
argument -Keep, para economizar recursos da máquina. Este comportamento é esperado justamente para
economizar recursos da máquina.
#>