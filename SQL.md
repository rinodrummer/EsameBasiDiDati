# SQL
**SQL** (_Structured Query Language_) è un linguaggio standardizzato per database basati sul modello relazionale (RDBMS) progettato per:

* Creare e modificare schemi di database (**DDL** - _Data Definition Language_): `CREATE`, `ALTER`, `DROP`;
* Inserire, modificare e gestire dati memorizzati (**DML** - _Data Manipulation Language_): `INSERT`, `UPDATE`, `DELETE`;
* Interrogare i dati memorizzati (**DQL** - _Data Query Language_): `SELECT`;
* Creare e gestire strumenti di controllo ed accesso ai dati (**DCL** - _Data Control Language_): `GRANT`, `REVOKE`.

_Fonte: [SQL](https://it.wikipedia.org/wiki/Structured_Query_Language) - Wikipedia._

**IMPORTANTE!** Non riassumerò la teoria presentata durante il corso, ma solamente la sintassi SQL collegata.

## Legenda:
| Simbolo   | Significato                   |
| :-------: | ----------------------------- |
| `[ ... ]` | Elemento opzionale            |
| `< ... >` | Elemento obbligatorio         |
| `/`       | Fine file/Terminazione script |


## Operatori
| Operatore | Funzione                  |
| :-------: | ------------------------- |
| `=`       | Uguaglianza               |
| `<>`      | Disuguaglianza            |
| `>`       | Maggiore                  |
| `<`       | Minore                    |
| `>=`      | Maggiore o uguale         |
| `<=`      | Minore o uguale           |
| `..`      | Range di valori           |
| `--`      | Commento su linea singola |
| `/* */`   | Commento multilinea       |


## Tipi di dato
| Tipo di dato                       | Nome                         |
| ---------------------------------- | :--------------------------: |
| Numerico                           | `INTEGER`, `FLOAT`, `DOUBLE` |
| Carattere, Stringa fissa           | `CHAR`                       |
| Stringa variabile                  | `VARCHAR`                    |
| Data                               | `DATE`                       |
| Ora                                | `TIME`                       |
| Data/Ora                           | `TIMESTAMP`, `DATETIME`      |

## Indice
1. [Introduzione](#sql):
    * [Legenda](#legenda);
    * [Operatori](#operatori);
    * [Tipi di dato](#tipi-di-dato);
    * [Indice](#indice);
1. [Definizione dei metadati (`DDL`)](#definizione-dei-metadati-ddl);
    1. [Creazione di un database](#creazione-di-un-database);
    1. [Domini: tpi personalizzati](#domini-tipi-personalizzati);
    1. [Creazione di tabelle](#creazione-di-tabelle);
1. [Costruire un'iterrogazione (`DQL`)](#costruire-un-interrogazione-dql);
1. [Viste (`VIEW`)](#viste-view);

## Definizione dei metadati (`DDL`)
La prima operazione utile per interagire con un DBMS è creare un database. Il database conterrà tutte le nostre tabelle che a loro volta conterranno record di dati.

### Creazione di un database
```
CREATE DATABASE <nomeDatabase>;
```

### Domini: tipi personalizzati
E' anche possibile definire dei tipi personalizzati basati su tipi primitivi:
```
CREATE DOMAIN <nomeDominio> AS <TipoPrimitivo>
[DEFAULT <valore>]
[CHECK <expressione booleana | CONSTRAINT>]
```

Es.:
```
CREATE DOMAIN voto AS UNSIGNED INTEGER(2)
DEFAULT 18
CHECK (
    VALUE >= 0 AND VALUE <= 31   -- Il prof. Peron utilizza il nome del dominio anziche la parola chiave 'VALUE': voto >= 0 AND voto <= 31
)
```
Supponiamo che `0` sia per gli astenuti/assenti e `31` per la lode.

### Creazione di tabelle
Un altro elemento fondamentale per la creazione della propria base di dati sono le tabelle.
Esse conterranno i record di dati.

Un record (di dati) è una struttura organizzata di informazioni, ovvero un insieme di informazioni con caratteristiche comuni e con un dato ordine.

Un esempio **generico** di record può essere:
```
<ID> <nome> <cognome> <dataDiNascita>
```

Ora, tutti i record facenti parte di questa **collezione** (_collection_) seguiranno l'ordine sopra presentato.
Es.:
```
1 Mario Rossi 01/01/1980
2 John Doe 12/03/1974
...
```

In SQL, la sintassi per definire quindi la struttura di contenimento, ovvero la tabella, è la seguente:
```
CREATE TABLE <nomeTabella> (
    <nomeCampo> <tipoCampo> [NULL | NOT NULL] [DEFAULT <valore>] [PRIMARY KEY | UNIQUE] [,
    <nomeCampo> <tipoCampo> [NULL | NOT NULL] [DEFAULT <valore>] [PRIMARY KEY | UNIQUE] [,
    ...
    ]] [,
    CONSTRAINT ...
    ]
)
```

Oppure è possibile creare una tabella utilizzando una query di selezione:
```
CREATE TABLE <nomeNuovaTabella> AS (SELECT ...)
```
**ATTENZIONE!** Oltre a selezionare la struttura, questa forma seleziona anche i dati che rispondono ad essa, per ovviare a questo problema è possibile indicare la clausola `WHERE 1 = 0` oppure eseguire un `TRUNCATE TABLE <nomeNuovaTabella>` per eliminare i dati presenti.

E' inoltre possibile definire dei **vincoli** sulla seguente tabella.
Un vincolo è una condizione che il campo deve rispettare per poter essere considerato valido.

I vincoli più semplici e comuni sono i vincoli di integrità intrarelazionale.
Essi vengono definiti anche `CONSTRAINT` e la sintassi generica per dichiararne uno in una tabella è la seguente:
```
-- Dopo aver dichiarato i campi...
CONSTRAINT <nomeVincolo> <definizione>
```

E' importante dire che il nome di un vincolo è univoco in tutto il database!

* **Chiave primaria**: indica un campo (o un insieme di campi) che hanno lo scopo di identificare **univocamente** un record della tabella. Hanno valore su tutta la tabella.

In fase di creazione esistono i seguenti modi per dichiarare questo vincolo:
    1. Vicino alla dichiarazione della campo: `<nomeCampo> <tipoCampo> PRIMARY KEY`;
    3. Alla fine della dichiarazione dei campi: `PRIMARY KEY (<campo>)`;
    2. Creando una `CONSTRAINT <nomeVincolo> PRIMARY KEY (<campo> [, <campo>, ...])`;

* **Chiave univoca**: indica un campo (o un insieme di campi) che possono avere valori unici ed univoci in tutta la tabella; vieta la possibilità di dati duplicati sui campi specificati. Hanno valore su tutta la tabella.

* **Vincolo di tupla**: indica un limite di valore che il campo può assumere. Hanno valore solo sul campo dichiarato, inoltre la condizione di veridicità può solo essere verificata sul campo stesso e non su altri della tabella.

<!-- TODO CONSTRAINT, ASSERTION e vincoli -->


## Costruire un'interrogazione (`DQL`)
<!--- TODO descrivere SELECT, JOIN, GROUP BY -->


## Viste (VIEW)
Le viste sono selezioni a cui viene associato un nome, inoltre esse sono principalmente virtuali, possono anche essere memorizzate (ciò comporta solo vantaggi di efficienza).

Su una vista possono essere eseguite solo `SELECT`.
Quindi non possono essere utilizzate le seguenti operazioni: `INSERT`, `UPDATE` e `DELETE`.

E' quindi anche possibile: creare (`CREATE`), eliminare (`DROP`).

La sintassi per la creazione di una vista è la seguente:
```
CREATE VIEW <nomeVista>[(<col1>[, <col2>, ...])] AS
    SELECT ...;
```

La corrispondenza tra colonne della vista e colonne della query di selezione è **posizionale**.
