//BUT : Le jeu de la bataille Navale
//ENTREE :  les coordonnées
//SORTIE : affiche si les coordonnées touche un bateau, combien de fois il faut encore
//le toucher et s'il est coulé
program Bataille_navale;

uses crt;

CONST
	MAX=10;
	MAXNAVIRE=5;
	MAXTAILLENAVIRE=6;

//Debut type
Type
	caseB = record
		ligne : integer;
		colonne : integer;
	end;
	
Type
	navire = record
		n : caseB;
		taille : integer;
		nom : string;
	end;
	
Type
	flotte = record
		n1 : navire;
	end;
	
Type
	marge = record
		x : integer;
		y : integer;
	end;

Type
	TcaseB=array [1..100] of caseB;
	Tbateau=array[1..100] of navire;
	TFlotte=array[1..MAXNAVIRE, 1..100] of flotte;
	Tnom=array[1..8] of string;
	T=array[1..20] of integer;

// FIN type

procedure InitcaseB(Var PoscaseB, caseBTouche : TcaseB);
var
	i : integer;
begin
	for i := 1 to MAX do
	begin
		PoscaseB[i].colonne := 0;
		PoscaseB[i].ligne := 0;
		caseBTouche[i].colonne := 0;
		caseBTouche[i].ligne := 0;
	end;
end;
//cette procédure initialise le plateau



procedure InitFlotte(var Bateau : Tbateau; var Ensemble : TFlotte);
var
	i, j : integer;
begin
	for i := 1 to MAX do
	begin
		Bateau[i].n.colonne := 0;
		Bateau[i].n.ligne := 0;
		for j := 1 to MAXNAVIRE do
		begin
			Ensemble[j, i].n1.n.colonne := 0;
			Ensemble[j, i].n1.n.ligne := 0;
		end;
	end;
end;
//cette procedure initialise la flotte
	
	
procedure AfficheMap();
var
	cpt, i, j : integer;

begin
		cpt := 7;
	for i := 1 to MAX do		//Afficher 1 - 10 horizontal
	begin
		write(i);
	end;
	for i := 1 to MAX do		//Affiche 1 - 10 vertical
	begin
		for j := 1 to MAX*3 do
		begin
			write(Chr(i + 64));
		end;
	end;
end;



procedure AfficherFlotte(Bateau  :  Tbateau ; tailleB  :  T);
var
	i, cpt : integer;
begin
	for i := 1 to MAXNAVIRE do
	begin		
		if tailleB[i]<0 then
		begin
			writeln(Bateau[i].nom, ' : ', 'X');
		end
		else
		begin
			writeln(Bateau[i].nom, ' : ', tailleB[i], ' ');
		end;	
	end;
end;


function TestCaseLigne(Bateau : Tbateau;PoscaseB : TcaseB;x, y, i : integer) : boolean;
var
	j : integer;
	test, test2 : boolean;
begin
	test := false;
	test2 := true;
	for j := 1 to Bateau[i].taille do
	begin
		if (Bateau[j].n.colonne <> PoscaseB[y].colonne) AND (Bateau[j].n.ligne<>PoscaseB[(x + (j - 1))].ligne) then
		begin
			test := true;	
		end;
		if test=false then
		begin
			test2 := false;
		end;
	end;
	if test2=false then
	begin
		test := false;
	end;
	TestCaseLigne := test;
end;
//test des bateaux horizontal


function TestCaseColonne(Bateau : Tbateau;PoscaseB : TcaseB;x, y, i : integer) : boolean;
var
	j : integer;
	test, test2 : boolean;
begin

	test := false;	
	for j := 1 to Bateau[i].taille do
	begin
		if (Bateau[j].n.colonne<>PoscaseB[(y + (j - 1))].colonne) AND (Bateau[j].n.ligne<>PoscaseB[x].ligne) then
		begin
			test := true;	
		end;
		if test=false then
		begin
			test2 := false;
		end;
	end;
	if test2=false then
	begin
		test := false;
	end;
	TestCaseColonne := test;
end;
//test bateaux vertical


function TestCase(Bateau : Tbateau; Ensemble : TFlotte) : boolean;
var
	i, j, l, k : integer;
	test : boolean;
begin
	test := true;
	
	for i := 1 to MAXNAVIRE do
	begin
		for j := 1 to MAXNAVIRE do
		begin
			for k := 1 to Bateau[i].taille do
			begin
				for l := 1 to Bateau[i].taille do
				begin
					if (Ensemble[i, k].n1.n.ligne=Ensemble[j, l].n1.n.ligne) AND (Ensemble[i, k].n1.n.colonne=Ensemble[j, l].n1.n.colonne) AND (j<>i) then
					begin
						test := false;
					end;
				end;
			end;
		end;
	end;
	TestCase := test;
end;
//test pour vérifier qu'une case n'est pas déjà remplie


function stringToInt(car : string) : integer; 

begin
	if (length(car) = 1) then
	begin
		if(ord(car[1]) >= 48) AND (ord(car[1]) <= 57) then
		begin
			stringToInt := ord(car[1]) - 48
		end
		else
		begin
			stringToInt := 0;
		end;
	end
	else
	begin
		if length(car)=2 then
		begin	
			if (ord(car[1])=49) AND (ord(car[2])=48)then
			begin
				stringToInt := 10
			end
			else
			begin
				stringToInt := 0;
			end;
		end;
	end;	
end;


function charactereToInt(car : char) : integer;
begin
	if(ord(car)>=97) AND (ord(car)<97 + MAX) then
	begin	
		charactereToInt := ord(car) - 96
	end
	else
	begin
		charactereToInt := 11;
	end;
end;


function trouver(Ensemble : TFlotte;Bateau : Tbateau;PoscaseB : TcaseB;x, y : integer;var nbr : integer) : boolean;
var
	i, j : integer;
	test : boolean;
begin
	test := false;
	for i := 1 to MAXNAVIRE do
	begin
		for j := 1 to Bateau[i].taille do
		begin
			if (Ensemble[i, j].n1.n.colonne=PoscaseB[y].colonne) AND (Ensemble[i, j].n1.n.ligne=PoscaseB[x].ligne) then
			begin
				test := true;
				nbr := i;
			end;
		end;
	end;
	trouver := test;
end;
//test si la position existe


function victoire(Nb : T) : boolean;
var
	i, cpt  :  integer;
	test  :  boolean;
begin
	test := false;
	cpt := 0;
	for i := 1 to MAXNAVIRE do
	begin
		if Nb[i]<1 then
		begin
			cpt := cpt + 1;
			if cpt=MAXNAVIRE then
			begin
				test := true;
			end;
		end;
	end;
	victoire := test;
end;
//test condition de victoire


procedure CreatecaseB(Var PoscaseB : TcaseB);
var
	cpt, i : integer;
begin	
	cpt := 7;
	for i := 1 to MAX do	//Valeur des cases y
	begin
		PoscaseB[i].ligne := cpt;
		cpt := cpt + 4;
	end;
	cpt := 8;
	for i := 1 to MAX do	//Valeur des cases x
	begin
		PoscaseB[i].colonne := cpt;
		cpt := cpt + 3;
	end;
end;
//affecte les valeurs de x et y à pos


procedure CreateNavire (PoscaseB : TcaseB;var Bateau : Tbateau;i : integer);
var
	j, x, y, randdirection : integer;
	test : boolean;
begin
	repeat
	begin
	Randomize;
	RandDirection := Random(2) + 1;//Pour choisir le placement au hasard
	case RandDirection of
		1 : begin		//placement bateau vertical
				repeat
				begin
					x := Random(MAX) + 1;
					y := Random(MAX) + 1;
				end;
				until (y<=MAX - Bateau[i].taille);
				test := TestCaseColonne(Bateau, PoscaseB, x, y, i);
				if test=true then
				begin
					for j := 1 to Bateau[i].taille do
					begin
						Bateau[j].n.colonne := PoscaseB[(y + j) - 1].colonne;
						Bateau[j].n.ligne := PoscaseB[x].ligne;
					end;
				end;	
			end;
		2 : begin//placement horizontal
				repeat
				begin
					x := Random(MAX) + 1;
					y := Random(MAX) + 1;
				end;
				until (x <= MAX - Bateau[i].taille);	
				test := TestCaseLigne(Bateau, PoscaseB, x, y, i);
				if test = true then
				begin
					for j := 1 to Bateau[i].taille do
					begin
						Bateau[j].n.colonne := PoscaseB[y].colonne;
						Bateau[j].n.ligne := PoscaseB[(x + j) - 1].ligne;
					end;
				end;
			end;
		end;
	end;
	until (test=true);
end;
//place les bateaux de façon aléatoire


procedure TailleBateau(Var Bateau : Tbateau;var tailleB : T);
var
	i, nbr : integer;
begin
	Randomize;
	for i := 1 to MAXNAVIRE do
	begin
		repeat
			nbr := Random(MAXTAILLENAVIRE) + 1;
		until nbr>1;
		
		Bateau[i].taille := nbr;
		tailleB[i] := Bateau[i].taille;
	end;

end;
//Taille des bateaux


procedure NomBateau (Var Nom : Tnom;Var Bateau : Tbateau);
var
  i : integer;
begin
	Nom[1] := 'Torpilleur';
	Nom[2] := 'Sous - Marin';
	Nom[3] := 'Contre - Torpilleur';
	Nom[4] := 'Croiseur';
	Nom[5] := 'Porte - Avions';
	Nom[6] := 'Corvette';
	Nom[7] := 'Cuirasse';
	Nom[8] := 'Destroyeur';
	for i := 1 to MAXNAVIRE do
	begin
		Bateau[i].nom := Nom[i];
	end;
end;
//donne le nom des bateaux


procedure CreateFlotte (Bateau : Tbateau; PoscaseB : TcaseB; Var Ensemble : TFlotte);
var
	i, j : integer;
	test : boolean;
begin
	repeat
	begin
		InitFlotte(Bateau, Ensemble);	
		for i := 1 to MAXNAVIRE do
		begin
			CreateNavire(PoscaseB, Bateau, i);
			for j := 1 to Bateau[i].taille do
			begin	
				Ensemble[i, j].n1.n.ligne := Bateau[j].n.ligne;
				Ensemble[i, j].n1.n.colonne := Bateau[j].n.colonne;
			end;
		end;
		test := TestCase(Bateau, Ensemble);
	end;
	until (test=true);
end;
//Création de la flotte 

var
	PoscaseB, caseBTouche : TcaseB;
	bateau : Tbateau;
	Nom : Tnom;
	tailleB : T;
	margin : marge;
	Ensemble : TFlotte;
	x1, y1, i, k, j, nbr : integer;
	y : char;
	x, joueur : string;
	test : boolean;
	
BEGIN
	clrscr;
	IniTcaseB(PoscaseB, caseBTouche);
	CreatecaseB(PoscaseB);
	TailleBateau(Bateau, tailleB);
	NomBateau(Nom, Bateau);
	CreateFlotte(Bateau, PoscaseB, Ensemble);
	writeln('Veuillez entrez votre nom.' );
	readln(joueur);
	AfficherFlotte(Bateau, tailleB);
	repeat
	begin
		repeat//boucle coord x
		begin
			writeln('Numero de ligne selectionnee ? (entre 1 et 10)');
			readln(x);
			x1 := stringToInt(x);
		end;
		until (x1 <> 0) AND (x <> '');;
		repeat//boucle coord y
		begin
			writeln('numero de colonne selectionnee ? (entre a et j)');
			readln(y);
			y := LowerCase(y);
			y1 := charactereToInt(y);
		end;
		until (y1 <> 11);
		test := trouver(Ensemble, Bateau, PoscaseB, x1, y1, nbr);
		if test=true then
		begin
			if (caseBTouche[nbr].ligne <> PoscaseB[x1].ligne) OR (caseBTouche[nbr].colonne <> PoscaseB[y1].colonne) then
			begin	
				if (tailleB[nbr] > 0) then
				begin
				caseBTouche[nbr].ligne := PoscaseB[x1].ligne;
				caseBTouche[nbr].colonne := PoscaseB[y1].colonne;
				writeln(Nom[nbr], ' touche !');
				tailleB[nbr] := tailleB[nbr] - 1;
				end;
				if (tailleB[nbr] <= 0) then
				begin
					writeln(Nom[nbr], ' a ete coule !');
					tailleB[nbr] :=  - 1;
				end;
			end
		end
		else
		begin
			writeln('Raté');
		end;
		AfficherFlotte(Bateau, tailleB);
		test := victoire(tailleB);// test si tout les bateau detruit
	end;
	until test=true;//fin du jeu
	write('Fin de la partie !');
	readln;
END.