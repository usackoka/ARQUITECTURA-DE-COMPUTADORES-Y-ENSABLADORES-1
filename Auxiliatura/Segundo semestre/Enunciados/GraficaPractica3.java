digraph grafica{
rankdir=TB;
node [shape = record, style=filled, fillcolor=seashell2];
	label="Operacion1"
	nododiez [label="10"];
	nodoNueve [label="9"];
	nodoDos [label="2"];
	nodoCinco [label="5"];
	nodoCuarenta [label="43"];
	nodoCincoFac [label="5!"];

	nodoMul [label="<C0>|*|<C1>"];
	nodoMul:C0 ->nododiez;
	nodoMul:C1 ->nodoNueve;

	nodoPot [label="<C0>|**|<C1>"];
	nodoPot:C1 ->nodoDos;
	nodoPot:C2 ->nodoCinco;

	nodoDiv [label="<C0>|/|<C1>"];
	nodoDiv:C0 ->nodoMul;
	nodoDiv:C1 ->nodoPot;

	nodoMas [label="<C0>|+|<C1>"];
	nodoMas:C0 ->nodoDiv;
	nodoMas:C1 ->nodoCuarenta;

	nodoMenos [label="<C0>|-|<C1>"];
	nodoMenos:C0 ->nodoMas;
	nodoMenos:C1 ->nodoCincoFac;
}