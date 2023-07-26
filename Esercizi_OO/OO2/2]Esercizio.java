public class Impiegato {
	String nome;
	String cognome;
	float stipendio;
	Dipartimento dipartimento;

	String toString();
}

public class Amministrativo extends Impiegato{
	String ruolo;
}

public class AddettoConsegne extends Impiegato{
	String tipoPatente;
	ArrayList<Veicolo> veicoli;
}

public class Veicolo{
	String Targa;
	String tipo;
	ArrayList<AddettoConsegne> addetti;
}

public class Dipartimento{
	String nome;
}