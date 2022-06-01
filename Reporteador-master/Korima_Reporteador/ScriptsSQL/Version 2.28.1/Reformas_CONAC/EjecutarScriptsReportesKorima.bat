@echo off

echo "---Scripts para Reportes de Korima---" 
echo "-------------------------------------" 
echo "...Ejecutando scripts..." 

ECHO %USERNAME% started the batch process at %TIME% >ArchivodeResultados.txt 


for %%f in (*.sql) do ( sqlcmd.exe  -S SRV-prueba\prueba  -U sa  -P 123  -d prueba -i %%f >>ArchivodeResultados.txt ) 


echo "...Fin de ejecucion..."

pause

