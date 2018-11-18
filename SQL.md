# SQL
**SQL** (_Structured Query Language_) è un linguaggio standardizzato per database basati sul modello relazionale (RDBMS) progettato per:

* Creare e modificare schemi di database (**DDL** - _Data Definition Language_): `CREATE`, `ALTER`, `DROP`;
* Inserire, modificare e gestire dati memorizzati (**DML** - _Data Manipulation Language_): `INSERT`, `UPDATE`, `DELETE`;
* Interrogare i dati memorizzati (**DQL** - _Data Query Language_): `SELECT`;
* Creare e gestire strumenti di controllo ed accesso ai dati (**DCL** - _Data Control Language_): `GRANT`, `REVOKE`.

_Fonte: [SQL](https://it.wikipedia.org/wiki/Structured_Query_Language) - Wikipedia._

**IMPORTANTE!** Non riassumerò la teoria presentata durante il corso, ma solamente la sintassi SQL collegata.

**N.B.:** La sintassi presentata segue lo standard **originale** e non lo standard Oracle!

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
| Numerico intero                    | `INTEGER`                    |
| Numerico decimale                  | `DECIMAL`, `REAL`, `FLOAT`   |
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
    1. [Creazione di tabelle e vincoli (`CREATE`)](#creazione-di-tabelle-e-vincoli-create):
        1. Definizione di record;
        1. Creare la tabella;
        1. Esprimere i vincoli (`CONSTRAINT`):
            * [Vincoli di integrità intrarelazionale](#vincoli-di-integrità-intrarelazionale):
                1. [Chiave primaria (`PRIMARY KEY`)](#chiave-primaria-primary-key);
                1. [Chiave univoca (`UNIQUE`)](#chiave-univoca-unique);
                1. [Vincolo di dominio (`CHECK`)](#vincolo-di-dominio-check);
            * [Vincoli di integrità interrelazionale](#vincoli-di-integrità-interrelazionale):
                * [Integrità referenziale (`FOREIGN KEY`)](#integrità-referenziale-foreign-key);
                * [Asserzioni (`ASSERTION`)](#asserzioni-assertion);
    1. [Modifica di tabelle (`ALTER`)](#modifica-di-tabelle-alter);
        1. [Modificare le colonne di una tabella](#modificare-le-colonne-di-una-tabella):
            1. [Aggiungere una nuova colonna](#aggiungere-una-nuova-colonna);
            1. [Modificare una colonna](#modificare-una-colonna);
            1. [Eliminare una colonna](#eliminare-una-colonna);
        1. [Modificare i vincoli di una tabella](#modificare-i-vincoli-di-una-tabella):
            1. [Aggiungere un vincolo](#aggiungere-un-vincolo);
            1. [Eliminare un vincolo](#eliminare-un-vincolo);
            1. [Modificare un vincolo](#modificare-un-vincolo);
    1. [Eliminazione dei metadati (`DROP`)](#eliminazione-dei-metadati-drop);
1. [Gestione dei dati (`DML`)](#gestione-dei-dati-dml):
    1. [Inserimento di un record (`INSERT`)](#inserimento-di-un-record-insert);
    1. [Modificare dei record (`UPDATE`)](#modificare-dei-record-update);
    1. [Eliminazione di record (`DELETE`)](#eliminazione-di-record-delete);
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
```sql
CREATE DOMAIN voto AS UNSIGNED INTEGER(2)
DEFAULT 18
CHECK (
    VALUE >= 0 AND VALUE <= 31 -- Il prof. Peron utilizza il nome del dominio anziche la parola chiave 'VALUE': voto >= 0 AND voto <= 31
)
```
Supponiamo che `0` sia per gli astenuti/assenti e `31` per la lode.

### Creazione di tabelle e vincoli (`CREATE`)
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


### Vincoli di integrità intrarelazionale
I vincoli più semplici e comuni sono i vincoli di **integrità intrarelazionale**.
Essi vengono definiti anche `CONSTRAINT` e la sintassi generica per dichiararne uno in una tabella è la seguente:
```
-- Dopo aver dichiarato i campi...
CONSTRAINT <nomeVincolo> <definizione> [ENABLE | DISABLE]
```

E' importante dire che il nome di un vincolo è univoco in tutto il database!

#### Chiave primaria (`PRIMARY KEY`)
Indica un campo (o un insieme di campi) che hanno lo scopo di identificare **univocamente** un record della tabella. Hanno valore su tutta la tabella.

In fase di creazione esistono i seguenti modi per dichiarare questo vincolo:
1. Vicino alla dichiarazione della campo: `<nomeCampo> <tipoCampo> PRIMARY KEY`;
1. Alla fine della dichiarazione dei campi: `PRIMARY KEY (<campo>)`;
1. Creando una `CONSTRAINT <nomeVincolo> PRIMARY KEY (<campo> [, <campo>, ...])`;


#### Chiave univoca (`UNIQUE`)
Indica un campo (o un insieme di campi) che possono avere valori unici ed univoci in tutta la tabella; vieta la possibilità di dati duplicati sui campi specificati. Hanno valore su tutta la tabella.

In fase di creazione esistono i seguenti modi per dichiarare questo vincolo:
1. Vicino alla dichiarazione della campo: `<nomeCampo> <tipoCampo> UNIQUE`;
1. Alla fine della dichiarazione dei campi: `UNIQUE (<campo>)`;
1. Creando una `CONSTRAINT <nomeVincolo> UNIQUE (<campo> [, <campo>, ...])`;


#### Vincolo di dominio (`CHECK`)
Indica un limite di valore che il campo (o un insieme di campi) può assumere.

In fase di creazione esistono i seguenti modi per dichiarare questo vincolo:
1. Vicino alla dichiarazione della campo: `<nomeCampo> <tipoCampo> CHECK (<condizione>)`;
1. Alla fine della dichiarazione dei campi: `CHECK (<condizione>)`;
1. Creando una `CONSTRAINT <nomeVincolo> CHECK (<condizione>)`;


### Vincoli di integrità interrelazionale

#### Integrità referenziale (`FOREIGN KEY`)
Esistono anche vincoli di **integrità interrelazionali**. Il più utilizzato è quello di **integrità referenziale**, definito `FOREIGN KEY`.
Una foreign key è un campo che fa riferimento ad un campo (principalmente una primary key) di un'altra tabella ed è utilizzato per rappresentare un'associazione fra le due.
Anche vincolo può essere definito in fase creazionale nelle seguenti tre forme:
1. Vicino alla dichiarazione del campo: `<nomeCampo> <tipoCampo> FOREIGN KEY REFERENCES <nomeTabella>(<campo>) [ON UPDATE <RESTICT | NO ACTION | CASCADE | SET NULL>] [ON DELETE <RESTICT | NO ACTION | CASCADE | SET NULL>]`;
1. Alla fine della dichiarazione dei campi: `FOREIGN KEY (<campo>) REFERENCES <nomeTabella>(<campo>) [ON UPDATE <RESTICT | NO ACTION | CASCADE | SET NULL>] [ON DELETE <RESTICT | NO ACTION | CASCADE | SET NULL>]`;
1. Creando una `CONSTRAINT <nomeVincolo> FOREIGN KEY (<campo>) REFERENCES <nomeTabella>(<campo>) [ON UPDATE <RESTICT | NO ACTION | CASCADE | SET NULL>] [ON DELETE <RESTICT | NO ACTION | CASCADE | SET NULL>]`;

Come definito dalla sintassi, per una foreign key è anche possibile specifare che operazione compiere in caso di modifica o perdita di informazioni.
Adesso verranno specificate le varie definizioni per le clausole `ON UPDATE` e `ON DELETE`:
* `NO ACTION` oppure `RESTRICT` (solo per MySQL): **Default**. Non compie nessuna azione, lasciando i dati invariati;
* `CASCADE`: Elimina oppure aggiorna automaticamente il valore del campo facente riferimento al dato record (consigliato per `ON UPDATE`);
* `SET NULL`: Imposta a `NULL` il valore del campo facente riferimento al dato record (consigliato per `ON DELETE`);

Es.:
Supponiamo di avere le tabelle `roles` e `employees`. Ogni dipendente ha un solo ruolo. Un ruolo piò essere svolto da più dipendenti.

L'associazione presentata è una 1 a molti, quindi la chiave primaria di `roles` viene ereditata da `employees` (vedi l'[esempio generale](#esempio-generale-ddl) di questa sezione).

Essendo la relazione definita nel seguente modo: `ON UPDATE CASCADE ON DELETE NO SET NULL`, otterremo i seguenti risultati:

* Se modificassi l'ID di un ruolo (indicato tra parentesi), per esempio `Capo Reparto (2)` &Implies; `Capo Reparto (10)`, essendoci la clausola a `ON UPDATE CASCADE`, tutti i dipendenti col ruolo di capo reparto verranno aggiornati facendo riferimento al record aggiornato;
* Se eliminassi il ruolo con ID pari a `3`, essendoci la clausola a `ON DELETE SET NULL`, tutti i dipendenti col ruolo con ID `3` verranno aggiornati avendo valore `NULL`;

Tabella `employees` originale:

| id  | name     | surname | role_id | salary |
| :-: | -------- | ------- | :-----: | ------ |
| 1   | Mario    | Rossi   | **2**   | 3000   |
| 2   | Ugo      | Bianchi | 3       | 1750   |
| 2   | Matteo   | Salvini | 5       | 800    |
| 2   | Rocco    | Lunghi  | **2**   | 3000   |
| 2   | Bruno    | Corti   | **2**   | 3000   |

Tabella `employees` aggiornata:

| id  | name     | surname | role_id    | salary |
| :-: | -------- | ------- | :--------: | ------ |
| 1   | Mario    | Rossi   | **10**     | 3000   |
| 2   | Ugo      | Bianchi | **`NULL`** | 1750   |
| 2   | Matteo   | Salvini | 5          | 800    |
| 2   | Rocco    | Lunghi  | **10**     | 3000   |
| 2   | Bruno    | Corti   | **10**     | 3000   |




#### Asserzioni (`ASSERTION`)
Spesso un campo può anche dipendere da un valore di un altro campo presente in un'altra tabella, per esprimere questa condizione è possibile definire un'**asserzione**:
```
CREATE ASSERTION <nomeAsserzione> CHECK (<condizione>)
```


### Esempio generale (`DDL`)
Esempio che racchiude tutte le nozioni appena espresse:
```sql
CREATE DATABASE company_db;

CREATE TABLE roles (
    id INTEGER(2) PRIMARY KEY.
    title VARCHAR(20) NOT NULL,
    min_salary DECIMAL(7, 2) NULL DEFAULT 250,
    max_salary DECIMAL(7, 2) NOT NULL,
    CONSTRAINT min_salary_chk CHECK (min_salary >= 250),
    CONSTRAINT max_salary_chk CHECK (max_salary >= 30000)
);

CREATE TABLE employees (
    id INTEGER(10) PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    surname VARCHAR(32) NOT NULL,
    role_id INTEGER(2),
    salary DECIMAL(7, 2) NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE ASSERTION emp_salary_chk CHECK (
    NOT EXISTS (
        SELECT *
        FROM employees AS emp
        JOIN roles AS role ON emp.role_id = role.id
        WHERE emp.salary NOT BETWEEN role.min_salary AND role.min_salary
    )
)
```

**IMPORTANTE!** Le asserzioni non sono quasi più supportate a fini effettivi, ma il prof. Peron ne ha molta considerazione.


### Modifica di tabelle (`ALTER`)
La modifica di metadati è principalmente applicata alle sole tabelle.

E' infatti possibile:
* Modificare le colonne di una tabella;
* Modificare<sup>(\*)</sup> i vincoli di una tabella;

La sintassi generica è:
```
ALTER TABLE <nomeTabella> <operazione>
```

### Modificare le colonne di una tabella

#### Aggiungere una nuova colonna
```
ALTER TABLE <nomeTabella>
ADD COLUMN <nomeCampo> <tipoCampo> [NULL | NOT NULL] [DEFAULT <valore>]
```


#### Modificare una colonna
```
ALTER TABLE <nomeTabella>
MODIFY COLUMN <nomeCampo> <tipoCampo> [NULL | NOT NULL] [DEFAULT <valore>]
```


#### Eliminare una colonna
```
ALTER TABLE <nomeTabella>
DROP COLUMN <nomeCampo>
```


### Modificare i vincoli di una tabella

#### Aggiungere un vincolo
```
ALTER TABLE <nomeTabella>
ADD CONSTRAINT <nomeConstraint> <definizione>
```


#### Eliminare un vincolo
```
ALTER TABLE <nomeTabella>
DROP CONSTRAINT <nomeConstraint>
```


#### Modificare un vincolo
Secondo lo standard del linguaggio, non è possibile modificare direttamente un vincolo, ma può essere **eliminato** e ricreato.

```sql
ALTER TABLE employees
DROP CONSTRAINT <nomeConstraint>;

ALTER TABLE employees
ADD CONSTRAINT <nomeConstraint> <definizioneAggiornato>
```


### Creazione di metadati (`CREATE`)
Il `DROP` è la funzione di eliminazione ed utilizza la seguente sintassi:
```
DROP <tipoMetadato> <nome>
```

Per esempio:
```sql
DROP TABLE employees
```

**ATTENZIONE!** E' importante far notare che all'eliminazione di un database o di una tabella, i dati in essi contenuti verrano persi!


## Gestione dei dati (`DML`)
Una volta creata la giusta struttura è giunto il momento di gestire i nostri dati.
E' ovvio dire che i dati che inseriremo/aggiorneremo/elimineremo devo rispettare i vincoli definiti!

### Inserimento di un record (`INSERT`)
Per inserire un un record in una tabella è possibile usare l'istruzione `INSERT`:
```
INSERT INTO <nomeTabella>(<campo> [, <campo>[, ...]])
VALUES (<valore> [, <valore>[, ...]])
```
La corrispondenza tra colonne indicate e valori è **posizionale**.

Es.:
```sql
INSERT INTO roles(id, title, min_salary, max_salary)
VALUES (1, 'Manager', 1500, 3500);

INSERT INTO roles(id, title, min_salary, max_salary)
VALUES (2, 'Capo Reparto', 1200, 3000);
```

E' anche possibile inserire in una tabella dati ottenuti da una `SELECT`.

Es.:
```sql
INSERT INTO roles(id, title, min_salary, max_salary)
SELECT * FROM old_roles WHERE id > 2
```

### Modificare dei record (`UPDATE`)
Lo statemente di modifica è probabilmente uno dei più pericolosi in quanto la sintassi sembra essere stata scritta per favorire la modifica di tutti i record anziche quella di uno specifico.

```
UPDATE <nomeTabella>
SET <campo> = <nuovoValore> [,
<campo> = <nuovoValore> [, ...]]
[WHERE <condizione>]
```

Es.:
```sql
UPDATE SET employees
SET salary = 3000
```
I salari di tutti i dipendenti saranno impostati a `3000`.

E' quindi **FONDAMENTALE** fare attenzione alla clausola `WHERE`:
```sql
UPDATE SET employees
SET salary = 3000
WHERE id = 3
```
Modifica del salario a `3000` del solo dipendente con ID pari a `3`.

E' anche possibile definire un aggiornamento sul vecchio valore:
```sql
UPDATE SET employees
SET salary = salary + 1000
WHERE id = 3
```


### Eliminazione di record (`DELETE`)
Lo statement di eliminazione è probabilmente il più compromettente in quanto elimina definitivamente uno o più record. Può anche eliminare tutti i record, ma la tabella rimarrà.

La sintassi è la seguente:
```
DELETE [*] FROM <nomeTabella>
[WHERE <condizione>]
```

Come per l'update, anche qui bisogna fare molta attenzione alla clausola `WHERE`!

Es.:
```sql
DELETE FROM employees
```
Elimina tutti i dipendenti.


```sql
DELETE FROM employees
WHERE id = 3
```
Elimina solo il dipendete con ID pari a `3`.


## Costruire un'interrogazione (`DQL`)
<!--- TODO descrivere SELECT, JOIN, GROUP BY -->

Un'interrogazione è basata principalmente dalla clausola `SELECT`.

La sintassi completa è la seguente:
```
SELECT [ALL | DISTINCT] <* | <campo> [AS <nuovoNome>] | <campoAggregato> [AS <nuovoNome>] [, [campo [AS <nuovoNome> ...]]>>
FROM <nomeTabella> [AS <alias>]
[[INNER | LEFT | RIGHT | FULL OUTER] JOIN <nomeTabella> [AS <alias>] ON <condizioneAssociazione>]
[[[INNER | LEFT | RIGHT | FULL OUTER] JOIN <nomeTabella> [AS <alias>] ON <condizioneAssociazione>] ...]
[WHERE <condizione | condizioneSuSubquery>]
[GROUP BY <campo> [, <campo>[, ...]]] [HAVING <condizioneRagruppamento>]
[ORDER BY <campo> [, <campo>[, ...]]] [ASC | DESC]
```

### `IS NULL`, `IS NOT NULL`
* `IS NULL`: Verifica se il campo è `NULL`;
* `IS NOT NULL`: Verifica se il campo **NON** è `NULL`;

### `EXISTS`, `NOT EXISTS`
* `EXISTS`: Verifica che la riga o il campo esistano in una tabella (indicata da subquery);
* `NOT EXISTS`: Verifica che la riga o il campo **NON** esistano in una tabella (indicata da subquery);

### `LIKE`, `NOT LIKE`
* `LIKE`: Verifica se il campo ha un valore che risponde alla stringa passata;
* `NOT LIKE`: rifica se il campo **NON** ha un valore che risponde alla stringa passata;

### `IN`, `NOT IN`
* `IN`: Verifica che il campo ha un valore presente nella lista passata;
* `NOT `: Verifica che il campo **NON** ha un valore presente nella lista passata;

### `BETWEEN`, `NOT BETWEEN`
* `BETWEEN`: Verifica che il campo ha un valore compreso nel range indicato;
* `NOT `: Verifica che il campo **NON** ha un valore compreso nel range indicatp;



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

Es.:
```sql
CREATE VIEW most_payed_emp_by_dep AS (
    SELECT emp.id, emp.name, emp.surname
    FROM empolyees AS emp
)
```
