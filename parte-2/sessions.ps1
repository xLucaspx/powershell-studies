<# Função para a criação de ApplicationPools chamados
$ApplicationPoolName nos computadores listados em $ComputersName #>
function Add-ApplicationPool {
  param(
    [string[]] $computersName,
    [string] $ApplicationPoolName
  )

  # Faremos este trabalho de forma paralela, por isso criamos várias sessões.
  $sessions = $computersName | ForEach-Object { New-PSSession -ComputerName  $_ }
  # A fim de termos um Job, usamos o comando Invoke-Command com o switchargument -AsJob!
  $jobs = $sessions | ForEach-Object {
    Invoke-Command -Session $_ -ScriptBlock {
      # HOSTNAME.EXE
      "Accessing from $env:COMPUTERNAME"

      # Nós poderíamos escrever um ScriptBlock com a sintaxe de parâmetros necessários,
      # mas podemos usar a variável automática $args também!
      $appCmdArgs = "add apppool /name:$($args[0]) /managedRuntimeVersion:v4.0 /managedPipelineMode:Integrated"
      C:\Windows\System32\inetsrv\appcmd.exe $appCmdArgs.Split(' ')
    } -ArgumentList $ApplicationPoolName -AsJob
  }

  # Aguardamos todos os Jobs serem finalizados para, então, termos seu valor.
  $jobs | Wait-Job | Select-Object @{Expression = { Receive-Job $_ }; Label = "Resultado" }, "Name"
  $jobs | Remove-Job # É importante removermos o Job da sessão do PowerShell...
  # ... assim como as sessões também!
  $sessions | Remove-PSSession
}

<#
# Quando estivermos escrevendo um script de automação, devemos usar o
cmdlet New-PSSession em conjunto do cmdlet Invoke-Command. Para criarmos
uma sessão, utilizamos o cmdlet New-PSSession enquanto que o cmdlet Invoke-Command,
por meio do argumento -PSSession, aceita uma sessão de destino para execução do comando.

# O cmdlet Enter-PSSession deve ser usado apenas em sessões interativas do PowerShell,
ou seja, aquelas que estamos usando a interface da console. Ele não funciona fora do
contexto de uma execução interativa do PowerShell.

# Ao usarmos o cmdlet New-PSSession, devemos tomar um cuidado especial ao terminarmos
nosso trabalho. Devemos remover a sessão remota da sessão do PowerShell assim que terminarmos
de a utilizar, a fim de economizar recursos de nossa máquina, da máquina remota e da rede que
mantém a conexão entre os dois computadores.
#>
