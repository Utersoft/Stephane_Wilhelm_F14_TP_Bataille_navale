program bataille_navale;

uses crt;

CONST
	MIN_LIGNE = 1 ;
	MAX_LIGNE = 50 ;
	MIN_COL = 1 ;
	MAX_COL = 50 ;
	NB_BATEAU = 2 ;
	MAX_CASE = 5 ;

TYPE cell = record
	ligne : integer;
	colonne : integer;
END;

TYPE bateau = record
	nCase : array[1..MAX_CASE] of cell;
	taille : integer;
END;

TYPE flotte = record
	nBateau : array[1..NB_BATEAU] of bateau;
END;

TYPE bool = (vrai, faux);

TYPE pos_bateau = (horizontal, vertical, diagonale);

TYPE etat_bateau = (touche, coule);

TYPE etat_flotte = (aFlot, aSombre);

TYPE etat_joueur = (gagne, perdu);

//Création des cases
procedure crea_case(l, c : integer ; VAR mCase : cell);
BEGIN
	mCase.ligne := l;
	mCase.colonne := c;
END;

//Comparaisons des cases
function cmpCase(mCase, tCase : cell) : bool;
BEGIN
	IF (mCase.ligne = tCase.ligne) AND (mCase.colonne = tCase.colonne) THEN
	BEGIN
		cmpCase := vrai;
	END;
END;

//Création des bateaux
function crea_bateau(nCase : cell ; taille : integer) : bateau;
var
	i, pos : integer;
	res : bateau;
	positionB : pos_bateau;

BEGIN
	pos := random(3)+ 1;
	positionB := pos_bateau(pos);
	for i := 1 to MAX_CASE do
	BEGIN
		IF (i <= taille) THEN
		BEGIN
			res.nCase[i].ligne := nCase.ligne;
			res.nCase[i].colonne := nCase.colonne;
		END
		ELSE
		BEGIN
			res.nCase[i].ligne := 0;
			res.nCase[i].colonne := 0;
		END;
		IF (positionB = horizontal) THEN
		BEGIN
			nCase.colonne := nCase.colonne + 1;
		END
		ELSE IF (positionB = vertical) THEN
		BEGIN
			nCase.ligne := nCase.ligne + 1;
		END
		ELSE IF (positionB = diagonale) THEN
		BEGIN
			nCase.ligne := nCase.ligne + 1;
			nCase.colonne := nCase.colonne + 1;
		END;
	END;
	crea_bateau := res;
END;

//Vérification des cases
function ctrl_case(mBat : bateau ; nCase : cell) : bool;
var
	i : integer;
	val_test : bool;

BEGIN
	val_test := faux;
	for i := 1 to MAX_CASE do
	BEGIN
		IF (cmpCase(mBat.nCase[i], nCase) = vrai) THEN
		BEGIN
			val_test := vrai;
		END;
	END;
	ctrl_case := val_test;
END;

//Vérification flotte
function ctrl_flotte(nFlotte : flotte; nCase : cell) : bool;
var
	i : integer;
	res : bool;
BEGIN
	res := faux;
	for i := 1 to NB_BATEAU do
	BEGIN
		IF (ctrl_case(nFlotte.nBateau[i], nCase) = vrai) THEN
		BEGIN
			res := vrai;
		END;
	END;
	ctrl_flotte := res;
END;

//création de la flotte
procedure flotte_joueur(nCase : cell ; var nFlotte : flotte);
var
	i : integer;
	valPosLigne, valPosColonne, valTailleBateau : integer;

BEGIN
	for i := 1 to NB_BATEAU do
	BEGIN
		valPosLigne := random(MAX_LIGNE)+ 1;
		valPosColonne := random(MAX_COL)+ 1;
		valTailleBateau := random(MAX_CASE)+ 1;
		crea_case(valPosLigne, valPosColonne, nCase);
		nFlotte.nBateau[i] := crea_bateau(nCase, valTailleBateau);
		nFlotte.nBateau[i].taille := valTailleBateau;
	END;
END;

function tailleBateau(nBateau : bateau) : integer;
var
	i : integer;
	cpt : integer;
begin
	cpt := 0;
	for i := 1 to MAX_CASE do
	begin
		if (nBateau.nCase[i].ligne <> 0) or (nBateau.nCase[i].colonne <> 0) then
		begin
			cpt := cpt + 1;
		end;
	end;
	tailleBateau := cpt;
end;

//Initialisation de la flotte
procedure initFlotte(var nFlotte : flotte ; nCase : cell);
var
  i, j : integer;

BEGIN
	for i := 1 to NB_BATEAU do
	BEGIN 
		flotte_joueur(nCase, nFlotte);
	END;
END;

function etatBateau(nBateau : bateau) :etat_bateau;
var
	etat : integer;

begin
	etat := tailleBateau(nBateau);
	if (etat < nBateau.taille) and (etat > 0) then 
	begin
		etatBateau := touche;
	end
	else if (etat = 0) then 
	begin
		etatBateau := coule;
	end;
end;

//Procédure d'attaque des bateaux
procedure attCase(var nFlotte : flotte);
var
	nCase : cell;
	test : bool;
	i, j : integer;
BEGIN

	repeat
		writeln('Entrez la ligne [1-50]');
		readln(nCase.ligne);
		IF (nCase.ligne < 1) or (nCase.ligne > 50) THEN
		BEGIN
			writeln('Erreur [1-50]');
		END;
	until (nCase.ligne > 0) AND (nCase.ligne <= 50);
	repeat
	BEGIN
		writeln('Entrez la colonne [1-50]');
		readln(nCase.colonne);
		IF (nCase.colonne < 1) or (nCase.colonne > 50) THEN 
		BEGIN
			writeln('erreur [1-50]');
		END;
	END;
	until (nCase.colonne > 0) AND (nCase.colonne <= 50);
	for i := 1 to NB_BATEAU do
	BEGIN
		for j := 1 to MAX_CASE do
		BEGIN
			test := faux;
			test := cmpCase(nCase,nFlotte.nBateau[i].nCase[j]);
			IF (test = vrai) THEN
			BEGIN
				writeln('Touche!');
				crea_case(0, 0, nFlotte.nBateau[i].nCase[j]);

				IF (etatBateau(nFlotte.nBateau[i])=coule) THEN
				BEGIN
					writeln('coule!');
				END;
			END;
		END;
	END;
END;

//Début du programme principal
var
	nCase : cell;
	i : integer;
	nFlotte : flotte;
	etatJ : etat_joueur;
	etatF : etat_flotte;

	
begin
	randomize;
	etatJ := perdu;
	etatF := aFlot;
	initFlotte(nFlotte, nCase);
	repeat
		IF (etatJ = perdu) THEN
		BEGIN
			writeln('Joueur : ');
			attCase(nFlotte);
		END;
		IF (ctrl_flotte(nFlotte, nCase) = faux) THEN
		BEGIN
			etatF := aSombre;
		END;
		IF (etatF = aSombre) THEN
		BEGIN
			etatJ := gagne;
		END;
	until ((etatJ = gagne) AND (etatF = aSombre));
	writeln('La partie est finie');
	readln;
END.