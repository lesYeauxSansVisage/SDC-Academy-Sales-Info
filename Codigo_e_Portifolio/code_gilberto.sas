*Importação das de todas as abas do arquivo DadosACADEMY.xlsx;

proc import datafile="/sasdata/sdcacademy/gilberto/DadosACADEMY.xlsx" 
		out=gilberto.VENDAS dbms=XLSX replace;
	sheet="Vendas";
run;

proc import datafile="/sasdata/sdcacademy/gilberto/DadosACADEMY.xlsx" 
		out=gilberto.vendedores dbms=xlsx replace;
	sheet="Vendedor";
run;

proc import datafile="/sasdata/sdcacademy/gilberto/DadosACADEMY.xlsx" 
		out=gilberto.produtos dbms=xlsx replace;
	SHEET="Produtos";
run;

proc import datafile="/sasdata/sdcacademy/gilberto/DadosACADEMY.xlsx" 
		out=gilberto.grupos dbms=xlsx replace;
	SHEET="Grupos";
run;

proc import datafile="/sasdata/sdcacademy/gilberto/DadosACADEMY.xlsx" 
		out=gilberto.regioes dbms=xlsx replace;
	SHEET="Regioes";
run;

proc import datafile="/sasdata/sdcacademy/gilberto/DadosACADEMY.xlsx" 
		out=gilberto.tamanhos dbms=xlsx replace;
	SHEET="Tamanhos";
run;

*Importação dos dados do arquivo Cores.txt;

proc import datafile="/sasdata/sdcacademy/gilberto/Cores.txt" 
		out=gilberto.cores dbms=tab replace;
	delimiter="|";
run;

*Importação do arquivo Texto_transpose.txt;

proc import datafile="/sasdata/sdcacademy/gilberto/Texto_transpose.txt" 
		out=gilberto.texto_transpose dbms=tab replace;
	delimiter=";";
run;

*Executando os comandos proc contents, proc means e proc freq na tabela vendas;

proc contents data=gilberto.vendas;
run;

proc means data=gilberto.vendas;
run;

proc freq data=gilberto.vendas;
run;

*Executando os comandos proc contents, proc means e proc freq na tabela vendedor;

proc contents data=gilberto.vendedores;
run;

proc means data=gilberto.vendedores;
run;

proc freq data=gilberto.vendedores;
run;

*Executando os comandos proc contents, proc means e proc freq na tabela produtos;

proc contents data=gilberto.produtos;
run;

proc means data=gilberto.produtos;
run;

proc freq data=gilberto.produtos;
run;

*Executando os comandos proc contents, proc means e proc freq na tabela grupos;

proc contents data=gilberto.grupos;
run;

proc means data=gilberto.grupos;
run;

proc freq data=gilberto.grupos;
run;

*Executando os comandos proc contents, proc means e proc freq na tabela tamanhos;

proc contents data=gilberto.tamanhos;
run;

proc means data=gilberto.tamanhos;
run;

proc freq data=gilberto.tamanhos;
run;

*Executando os comandos proc contents, proc means e proc freq na tabelas regiões;

proc contents data=gilberto.regioes;
run;

proc means data=gilberto.regioes;
run;

proc freq data=gilberto.regioes;
run;

*Executando os comandos proc contents, proc means e proc freq na tabela cores;

proc contents data=gilberto.cores;
run;

proc means data=gilberto.cores;
run;

proc freq data=gilberto.cores;
run;

*Usando proc transpose para fazer pivot dos dados;

proc transpose data=gilberto.texto_transpose out=work.transposed(rename=(_name_=Data col1=Quantidade));
	by nome;
run;

*Limpando a coluna transposed de valores ausentes;
data texto_transpose_limpo;
	set work.transposed;
	if not missing(Quantidade) then output;
run;

*Usando um data step para modificar os dados da tabela vendas;

*Rename para mudar o nome das tabela corrigidas;
data gilberto.vendas_limpo(rename=(Vendedor_num=Vendedor QtdeVendida_num=QtdeVendida));
	set gilberto.vendas;
	*Usando where para selecionar apenas linhas que não tenham nenhum valor ausente;
	where not missing(CodProduto) 
	and not missing(CodCor) 
	and not missing(CodTamanho) 
	and not missing(CodEstado)
	and not missing(DataVenda) 
	and not missing(Vendedor) 
	and not missing(QtdeVendida);
	*Criando colunas com valores númericos para a coluna Vendedores e QtdeVendida;
	Vendedor_Num=input(Vendedor, 8.);
	QtdeVendida_Num=input(QtdeVendida, 8.);
	/*Verificando se foi possível a conversão de char para num, caso não seja possível
	isso significa que o código de vendedor é inválido, portanto também o removemos do
	dataset */
	if not missing(Vendedor_Num) then output;
	*Removendo as tabelas Vendedor e QtdeVendida;
	drop Vendedor QtdeVendida;
run;

proc means data=gilberto.vendas_limpo;
run;

proc freq data=gilberto.vendas_limpo;
run;

*Adicionando uma região a tabela Regioes;

proc sql;
	*Inserindo o código de região 5 e o nome sul a tabela regioes;
    insert into gilberto.regioes
        values(5, "Sul");
quit;

*Ajustando um código de grupo incorreto;

data gilberto.grupos_corrigido;
	set gilberto.grupos;
	if Descricao="Grupo 11" then CodGrupo=11;
run;

proc freq data=gilberto.grupos_corrigido;
run;
	

