# PL/SQL

Tutti i contenuti di questo documento fanno riferimento alla [documentazione ufficiale del linguaggio PL/SQL](https://docs.oracle.com/cloud/latest/db112/LNPLS/toc.htm).

Molti contenuti sono ripresi esattamente come trattati dalla documentazione sopra citata.
**Si sottolinea anche che la seguente può esser vista come una traduzione e un riassunto della stessa e che lo scopo finale di questa repo è esclusivo a fini DIDATTICI!**

Si esorta inoltre all'utilizzo di [Live SQL](https://livesql.oracle.com/) di Oracle: strumento utilissimo per la comprensione del linguaggio.

**IMPORTANTE!** Clicca [qui](/SQL.md#viste-view) per leggere di più riguardo le viste (`VIEW`)!

## Legenda:
| Simbolo   | Significato                   |
| :-------: | ----------------------------- |
| `[ ... ]` | Elemento opzionale            |
| `< ... >` | Elemento obbligatorio         |
| `/`       | Fine file/Terminazione script |

## Indice
1. [Introduzione](#pl-sql):
    * [Legenda](#legenda);
    * [Indice](#indice);
1. [Operatori](#operatori);
1. [Tipi di dato](#tipi-di-dato);
1. [Struttura di uno script](#struttura-di-uno-script);
1. [Strutture di controllo](#strutture-di-controllo);
    1. [Condizioni](#condizioni):
        1. [`IF-ELSIF-ELSE`](#if-elsif-else);
        1. [`CASE-WHEN`](#case-when):
            * Simple `CASE`;
            * Searched `CASE`;
    1. [Loop](#loop):
        1. [Simple `LOOP`](#simple-loop):
            * Utilizzo dell'`EXIT` e dell'`EXIT WHEN`;
            * Utilizzo dell'`EXIT` con le label;
        1. [`FOR LOOP`](#for-loop);
        1. [`WHILE LOOP`](#while-loop);
        1. [`LOOP` con cursori](#loop-con-cursori);
1. [Definizione di elementi](#definizione-di-elementi):
    1. [Definizione di tipi personalizzati (subtipi)](#definizione-di-un-subtipo);
    1. [Definizione di variabili e costanti](#definizione-di-variabili-e-costanti):
        * [`%TYPE` e `%ROWTYPE` (var. **record**)](#type-e-rowtype);
        * [Cursori](#cursori);
    1. [Definizione di procedure e funzioni](#definizione-di-e-procedure-funzioni);
1. [Sequenze](#sequenze);
1. [Trigger](#trigger);
    * [Ovviare il mutating table](#ovviare-il-mutating-table);
1. [SQL dinamico](#sql-dinamico);
1. [Funzioni e istruzioni utili](#funzioni-e-istruzioni-utili);
    * [`LENGTH`](#length);
    * [`INSTR`](#instr);
    * [`SUBSTR`](#substr);
    * [`UPPER`](#upper);
    * [`LOWER`](#lower);
    * [`INITCAP`](#initcap);
    * [`REPLACE`](#replace);
    * [`TRANSLATE`](#translate);


## Operatori
| Operatore | Funzione                  |
| :-------: | ------------------------- |
| `:=`      | Assegnazione              |
| `=>`      | Associazione              |
| `=`       | Uguaglianza               |
| `<>`      | Disuguaglianza            |
| `>`       | Maggiore                  |
| `<`       | Minore                    |
| `>=`      | Maggiore o uguale         |
| `<=`      | Minore o uguale           |
| `\|\|`    | Concatenazione            |
| `<<`      | Inizio label              |
| `>>`      | Fine label                |
| `..`      | Range di valori           |
| `--`      | Commento su linea singola |
| `/* */`   | Commento multilinea       |

## Tipi di dato
| Tipo di dato                       | Nome                         |
| ---------------------------------- | :--------------------------: |
| Numerico                           | `NUMBER`, `INTEGER`, `REAL`  |
| Carattere                          | `CHAR`                       |
| Stringa                            | `VARCHAR2`                   |
| Booleano (solo var., cost. e fun.) | `BOOLEAN`                    |
| Data                               | `DATE`                       |
| Ora                                | `TIME`                       |
| Data/Ora                           | `TIMESTAMP`                  |

## Struttura di uno script
```
-- Funzioni e procedure vanno create con uno statement dedicato.
/ -- Fine file

-- Operazioni (statiche) sui dati e i metadati (creaione di tabelle, etc.);

DECLARE
    -- Dichiarazione di subtipi;
    -- Dichiarazione di variabili, costanti e procedure;
BEGIN
    -- Corpo dello script;
END;
```

## Strutture di controllo
Le strutture di controllo presenti in PL/SQL sono principalmente condizioni e loop.

### Condizioni
Le condizioni vengono espresse con le seguenti sintassi:

### `IF-ELSIF-ELSE`
```
IF (cond1) THEN
    ...
ELSIF (cond2) THEN
    ...
ELSE
    ...
END IF;
```

### `CASE-WHEN`
E' anche possibile utilizzare la clausola `CASE` con la seguente sintassi, denominata **simple CASE**:
```
CASE grade
  WHEN 'A' THEN 'Excellent'
  WHEN 'B' THEN 'Very Good'
  WHEN 'C' THEN 'Good'
  WHEN 'D' THEN 'Fair'
  WHEN 'F' THEN 'Poor'
  ELSE 'No such grade'
END CASE;
```
**ATTENZIONE!** In questa forma, non è possibile controllare il caso in cui la variabile è `NULL`!

L'`ELSE` può essere anche sostituito con la seguente forma:
```
EXCEPTION
    WHEN CASE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No such grade');
```

La forma alternativa è chiamata **searched CASE** e può essere usata anche in assegnazione ad una variabile, come nell'esempio:
```
DECLARE
  grade CHAR(1); -- NULL by default
  appraisal VARCHAR2(20);
BEGIN
    appraisal := CASE
        WHEN grade IS NULL THEN 'No grade assigned'
        WHEN grade = 'A' THEN 'Excellent'
        WHEN grade = 'B' THEN 'Very Good'
        WHEN grade = 'C' THEN 'Good'
        WHEN grade = 'D' THEN 'Fair'
        WHEN grade = 'F' THEN 'Poor'
        ELSE 'No such grade'
    END;

    DBMS_OUTPUT.PUT_LINE(appraisal);
END;
```

### Loop
I loop rappresentano un elemento di fondamentale importanza in PL/SQL in quanto la maggior parte dei dati con cui ci si interfaccia sono "collezioni" di record.

Vi sono diverse varianti di loop.

#### Simple `LOOP`
```
[<<label>>] LOOP
    ...
END LOOP [label];
```

Esempio di loop con direttiva `EXIT`:
```
DECLARE
    x NUMBER := 0;
BEGIN
    LOOP
        x := x + 1;
        DBMS_OUTPUT.PUT_LINE ('Inside loop:  x = ' || TO_CHAR(x));

        IF x > 3 THEN
            EXIT;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(' After loop:  x = ' || TO_CHAR(x));
END;
```

Esempio dello stesso loop con direttiva `EXIT WHEN`:
```
DECLARE
    x NUMBER := 0;
BEGIN
    LOOP
        x := x + 1;
        DBMS_OUTPUT.PUT_LINE ('Inside loop:  x = ' || TO_CHAR(x));

        EXIT WHEN x > 3;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(' After loop:  x = ' || TO_CHAR(x));
END;
```

Come visto dal codice presentante la sintassi, è possibile definire una label per il loop.
Ciò può essere molto utile quando si presenta la neccessità di terminare loop più esterni rispetto al corrente o per casi di chiusura veloce.

Es.:
```
DECLARE
    x NUMBER := 0;
    y NUMBER := 0;

BEGIN
    <<loop_esterno>> LOOP
        x := x + 2;
        y := 0;
        <<loop_interno>> LOOP
            y := y + 4;

            -- debug output:
            DBMS_OUTPUT.PUT_LINE('x: ' || TO_CHAR(x) || '; y: ' || TO_CHAR(y) || '; sum: ' || TO_CHAR(x + y) || '; prod: ' || TO_CHAR(x * (x * y)));

            EXIT loop_interno WHEN (x + y) >= 15;
            EXIT loop_esterno WHEN (x * (x * y)) >= 350;
        END LOOP loop_interno;
    END LOOP loop_esterno;
END;
```
**ATTENZIONE!** E' importante controllare la corretta chiusura dei loop e/o la posizione della direttiva `EXIT WHEN` in quanto potrebbe causare loop fuori controllo.

<!-- TODO Descrivere CONTINUE -->

#### `FOR LOOP`
Il `FOR LOOP` è un loop principalmente basato sull'utilizzo di un contatore e sui range.
Esso presenta la seguente sintassi:
```
[<<label>>] FOR <indice> IN [REVERSE] <min..max> LOOP
  ...
END LOOP [label];
```

La clausola `REVERSE` consente di iterare il range in maniera inversa.
Es.:
```
BEGIN
    FOR i IN REVERSE 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;

    FOR i IN 3..1 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
```
I due loop produrranno lo stesso risultato.

L'`indice` ha uno scope definito solo all'interno del loop.

E' importante notare che se vi è una variabile con lo stesso nome, ma con scope **superiore**, questa non viene sovrascritta.
Es.:
```
DECLARE
  i NUMBER := 5;
  first NUMBER := 1;
  last NUMBER := 3;
BEGIN
    FOR i IN first..last LOOP
        DBMS_OUTPUT.PUT_LINE('Inside loop, i is ' || TO_CHAR(i)); -- 1, 2, 3
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Outside loop, i is ' || TO_CHAR(i)); -- 5
END;
```
E' possibile accedere a variabili omonime di altri scope grazie alle label con una sintassi C-like (struct).
Per variabili di scope superiore estremo (appartenenti al `DECLARE`) è possibile usare la label `main`.
Es.: `main.i`.


#### `WHILE LOOP`
Il `WHILE LOOP` è indicato per l'utilizzo di condizioni a guardia del loop.
La sintassi è la seguente:

```
[<<label>>] WHILE <condizione> LOOP
  ...
END LOOP [label];
```

#### `LOOP` con cursori
Un cursore è un particolare tipo di variabile che permette di iterare dei record di una tabella _([vedi qui](#cursore))_.
Es.:
**FOR LOOP con cursore**:
```
DECLARE
    v_employees employees%ROWTYPE;
    CURSOR c1 IS
        SELECT *
        FROM employees;
BEGIN
    OPEN c1;

    -- Fetch entire row into v_employees record:
    FOR i IN 1..10 LOOP
        FETCH c1 INTO v_employees;
        EXIT WHEN c1%NOTFOUND;
        -- Process data here
    END LOOP;

    CLOSE c1;
END;
```
Il codice precedente verrà eseguito un massimo di 10 volte oppure fino a quando il fetching del cursore non ritornerà NULL.

E' inoltre possibile iterare un cursore con l'utilizzo di una [**variabile record**](#type-e-rowtype):
```
DECLARE
    CURSOR c1 IS
        SELECT id, name
        FROM employees
        WHERE surname = 'Landolfi';
BEGIN
    FOR emp IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || emp.id || ', Nome: ' || emp.name);
  END LOOP;
END;
```

Oppure è altrettanto possibile iterare il risultato di una clausola `SELECT`:
```
BEGIN
    FOR emp IN (
        SELECT name || ' ' || surname AS full_name, salary * 10 AS dream_salary
        FROM employees
        WHERE ROWNUM <= 5
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(emp.full_name || ' dreams of making ' || emp.dream_salary);
  END LOOP;
END;
```
Ovviamente la cosa può comportare limitazioni rispetto l'utilizzo di cursori.

Altri contenuti riguardanti le iterazioni di cursori possono essere trovati proseguendo.

## Definizione di elementi

### Definizione di un subtipo
Un subtipo è un tipo di dato personalizzato basato su un tipo primitivo.
```
SUBTYPE Word IS CHAR(6);
SUBTYPE Text IS VARCHAR2(15);
```

La sintassi di dichiaraione è la seguente:
```
SUBTYPE <nomeSubtipo> IS [<tipoBase>(dim) | RANGE <basso>..<alto>] [NOT NULL];
```

### Definizione di variabili e costanti
Nella sezione di dichiarazione è possibile dichiare variabili, costanti,
procedure e funzioni.
Le variabili e le costanti vengono dichiarate con la seguente sintassi:
```
<nome> [CONSTANT] <tipo>(dim) [:= <valore>];
```

Es.:
```
x NUMBER := 10;
y NUMBER := 5;
max NUMBER;

pi CONSTANT REAL := 3.14159;
```

Come è possibile notare, una variabile può non ricevere assegnazione alla creazione. Essa avrà valore `NULL`.

Bisogna fare assoluta attenzione a questo caso: una variabile di questo tipo, specialmente nel contesto numerico non può essere usata come valore incrementale.

Es.:
```
DECLARE
    counter INTEGER;   -- counter = NULL
BEGIN
    counter := counter + 1; -- counter sarà ugualmente NULL!
END;
```

#### `%TYPE` e `%ROWTYPE`
E' anche possibile associare il tipo di una colonna (o di un'altra variabile) alla corrente in dichiarazione, es.:
```
x NUMBER(5) := 10;
y x%TYPE := 5;

emp_salary employees.salary%TYPE;
```

E' inoltre anche possibile dichiarare un elemento che fa riferimento alla **totale** struttura di una tabella, ovvero una **variabile _record_**:
```
DECLARE
    emp employees%ROWTYPE;
BEGIN
    emp.id := 4;
    emp.name := 'Salvatore';
    emp.surname := 'Lavezzi';
    emp.salary := 700;
END;
```
Come è possibile notare, è possibile accedere al campo della variabile record col simbolo `.`, con una sintassi C-like (struct).

E' anche possibile definire una variabile record su una struttura personalizzata (che utilizzerà la sintassi per la creazione di una tabella) con la seguente sintassi:
```
<nomeVarRecord> IS RECORD (
    ...   -- Codice SQL per definire definire la tabella
);
```

E' anche possibile utilizzare `%TYPE` per indicare il tipo di un campo facente riferimento ad una tabella già esistente.

**ATTENZIONE!** L'inserimento in una tabella tramite l'utilizzo di una variabile record avviene in forma canonica!

Es.:
```
INSERT INTO employees(id, name, surname, salary)
VALUES (emp.id, emp.name, emp.surname, emp.salary);
```

#### Cursori
Esiste uno speciale tipo di variabile chiamato **cursore**. Questo permette di iterare più righe di una tabella.

Questo tipo di variabile è molto utilizzato.

Principalmente vi sono due tipi di dichiarazione di cursori:
```
CURSOR <nome> IS <SELECT ...>;
```

Questa dichiarazione viene utilizzata principalmente in contesti _statici_ e si può interagire con cursori dichiarati in questo modo diretto tramite un'iterazione dello stesso. Es.:
```
DECLARE
    CURSOR c1 IS
        SELECT id, name
        FROM employees
        WHERE surname = 'Landolfi';
BEGIN
    FOR emp IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || emp.id || ', Nome: ' || emp.name);
  END LOOP;
END;
```

Oppure con le clausole `OPEN-FETCH-CLOSE`:
```
DECLARE
    emp employees%ROWTYPE;

    CURSOR c1 IS
        SELECT *
        FROM employees;
BEGIN
    OPEN c1;
        FETCH c1 INTO emp;

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(emp.name));
    CLOSE c1;
END;
```
E' importante notare che in questa forma, è necessario iterare il fetching per ottenere più risultati.

N.B.: Per un corretto funzionamento di un fetching iterato in maniera indefinita, l'approccio migliore è il seguente:
```
DECLARE
    emp employees%ROWTYPE;

    CURSOR c1 IS
        SELECT *
        FROM employees;
BEGIN
    OPEN c1;
        LOOP
            EXIT WHEN c1%NOTFOUND;

            FETCH c1 INTO emp;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(emp.name));

        END LOOP;
    CLOSE c1;
END;
```

Mentre per contesti _dinamici_ è possibile utilizzare i `REF CURSOR`, ovvero cursori in cui verranno selezionati elementi in posizioni diverse dalla dichiarazione di questo:
```
DECLARE
    emp employees%ROWTYPE;

    c1 SYS_REFCURSOR;   -- Il Prof. Peron utilizza la sintassi 'c1 REF CURSOR;'
BEGIN
    OPEN c1 FOR   -- E' importante notare che questo FOR ha la stessa funzione di un IS!
        SELECT *
        FROM employees;

    -- Questa clausola LOOP non ha connessione col FOR dello statement precedente!
    LOOP
        EXIT WHEN c1%NOTFOUND;

        FETCH c1 INTO emp;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(emp.name));
    END LOOP;

    CLOSE c1;
END;
```


### Definizione di procedure e funzioni
E' scontato ricordare che le procedure non ritornano valore **direttamente**, le funzioni sì.
**ATTENZIONE!** E' importante dire che le procedure e le funzioni devono essere dichiarate con una query dedicata! Si sconsiglia di definire altri blocchi oltre alla funzione/procedura!

Per quanto riguarda le procedure, la sintassi è la seguente:
```
CREATE [OR REPLACE] PROCEDURE <nomeProcedura> (
    [<nomeParametro> [IN | OUT | IN OUT] <tipo> [:= NULL | <valore>]] [,
    [<nomeParametro> [IN | OUT | IN OUT] <tipo> [:= NULL | <valore>]]]
) IS   --- Può anche essere usato AS
    [<nomeVarLocale> <tipo>;]
    [<nomeVarLocale> <tipo>;]
BEGIN
    ...   -- corpo della funzione
    [RETURN;]
END [nomeProcedura];
```
Una procedura può utilizzare la parola chiave `RETURN` per terminare la sua esecuzione, ma non può essere accompagnata da nessun valore.

E' importante far notare che una procedura può **indirettamente** ritornare un valore se una variabile viene passata come paramentro `OUT` o `IN OUT`.

**ATTENZIONE!** il tipo dei parametri non deve definire la dimensione, ma quello delle variabili sì!

Es.:
```
CREATE PROCEDURE adjust_salary (
    emp_id NUMBER,
    adj NUMBER,
    sal IN OUT NUMBER
) IS
BEGIN
    sal := sal + adj;

    UPDATE employees
    SET salary = sal
    WHERE id = emp_id;

    DBMS_OUTPUT.PUT_LINE('Updated salary is: ' || sal);
END;
/

DECLARE
    emp NUMBER := 1;
    emp_salary NUMBER(5);
BEGIN
    SELECT salary
    INTO emp_salary
    FROM employees
    WHERE id = emp;

    adjust_salary(emp, 30, emp_salary);
END;
```
La seguente procedura aggiunge un dato valore al salario di un dipendente.
Può essere vista all'opera [qui](https://livesql.oracle.com/apex/livesql/s/f30wems22by88g8eqhi6oeus5).

Mentre la sintassi per dichiarare una funzione è la seguente:
```
CREATE [OR REPLACE] FUNCTION <nomeFunzione> (
    [<nomeParametro> [IN | OUT | IN OUT] <tipo> [:= NULL | <valore>]] [,
    [<nomeParametro> [IN | OUT | IN OUT] <tipo> [:= NULL | <valore>]]]
)
RETURN <tipo>
AS   --- Può anche essere usato IS
    [<nomeVarLocale> <tipo>;]
    [<nomeVarLocale> <tipo>;]
BEGIN
    -- Operazioni
    RETURN <varLocale>;
END [nomeFunzione];
```

I parametri normalmente vengono passati in ordine **posizionale**, ma possono anche essere indicati con una **coppia chiave/valore**.

Es.:
```
CREATE OR REPLACE FUNCTION test_keyval (
    name VARCHAR2,
    role VARCHAR2 := NULL,
    salary NUMBER
)
RETURN VARCHAR2
AS
BEGIN
    IF role IS NULL THEN
        RETURN name || ' has a salary of ' || salary;
    ELSE
        RETURN name || ' (' || role || ') has a salary of ' || salary;
    END IF;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(test_keyval(
        salary => 300,
        name => 'Test'
    ));
END;
```

## Sequenze
Un elemento molto semplice, ma parecchio utile che PL/SQL offre sono le **sequenze** (`SEQUENCE`).

Una sequenza è semplicemente un contatore.

La sintassi è la seguente:
```
-- Quando un attributo è seguito dal simbolo di assegnazione (:=), si intende il suo valore di default, anche in omissione del campo stesso.

CREATE SEQUENCE <nomeSequenza>
    [START WITH <valore := 0>]
    [INCREMENT BY <valore := 1>]   -- Può anche essere negativo;
    [NOMINVALUE | MINVALUE <valore>]   -- Valore minimo possibile: -10<sup>26</sup>;
    [NOMAXVALUE | MAXVALUE <valore>]   -- Valore massimo possibile: 10<sup>27</sup>;
    [CYCLE | NOCYCLE]   -- Ricomincia dal valore indicato dallo START WITH quando si supera il massimo o il minimo;
    [NOCACHE | CACHE <qauntità>]    -- Quantità di valori valori da salvare in cache;
    [NOORDER | ORDER]   --- ORDER utile solo se la sequenza ha fini di timestamping. Inutile per le primary key;
```

Es.:
```
CREARE SEQUENCE users_id_autoinc;
```

E' inoltre è sempre possibile accedere al valore successivo (es.: `users_id_autoinc.NEXTVAL`), ma al corrente (es.: `users_id_autoinc.CURRVAL`) **SOLO** dopo una chiamata al successivo (essendo questo il nuovo corrente).

Es.:
```
-- Errato:
BEGIN
    DBMS_OUTPUT.PUT_LINE(users_id_autoinc.NEXTVAL);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(users_id_autoinc.CURRVAL);   -- Errore: sequenza users_id_autoinc.CURRVAL non è ancora definita in questa sessione
END;
/

-- Corretto:
BEGIN
    DBMS_OUTPUT.PUT_LINE(users_id_autoinc.NEXTVAL);
    DBMS_OUTPUT.PUT_LINE(users_id_autoinc.CURRVAL);
END;
```

Per accedere al precedente è necessario sottrarre il valore di incremento (default: 1) aD `users_id_autoinc.NEXTVAL` oppure a `users_id_autoinc.CURRVAL.`.

Es.:
```
BEGIN
    -- Entrambi ritorneranno il valore loro precedente
    DBMS_OUTPUT.PUT_LINE(users_id_autoinc.NEXTVAL - 1);
    DBMS_OUTPUT.PUT_LINE(users_id_autoinc.CURRVAL - 1);
END;
```

## Trigger
Il problema del SQL dinamico è la mancanza di una definizione temporale precisa. Per operare quindi sugli eventi sono stati introdotti i **trigger**.

Un trigger può essere avviato sia da eventi `DDL` (`CREATE`, `ALTER`, `DROP` - definito anche **system `TRIGGER`**) che da eventi `DML` (`INSERT`, `UPDATE`, `DELETE` - definito anche **DML `TRIGGER`**), ovviamente solo se **attivato**.

Inoltre, per quanto un trigger possa sembrare simile ad un vincolo (`CONSTRAINT`), la differenza sostanziale sta nel fatto che il trigger viene avviato **solo** alla **creazione di nuove informazioni**, mentre il vincolo puoi aggire sia sulla **creazione di nuove informazioni** che sui **dati già esistenti**.

I vincoli sono molto più semplici da definire ma hanno ovvi limiti: possono operare solo sul proprio campo e sono sprovvisti di logiche complesse, limiti che ovviamente il trigger non ha, a discapito della semplicità.

Un trigger può ovviamente partire solo **prima di uno statement** (`BEFORE`) o **dopo uno statement** (`AFTER`).
La cosa può sembrare limitante, ma in combinazione con gli eventi con cui opera, esso è molto versatile.

E' anche importante dire che un trigger può anche essere avviato a causa di **più di eventi**.

Esistono inoltre due tipi di trigger: i **simple `TRIGGER`** (a cui potrei riferirmi più avanti come **trigger semplice**) e i **`COMPOUND TRIGGER`** (a cui potrei riferirmi più avanti come **trigger composto**).

La sintassi per creare un simple trigger è la seguente:
```
CREATE TRIGGER <nome>
    <BEFORE | AFTER>
        <evento> [OF [<colonna> [, <colonna>]] OR
        [<evento> [OF [<colonna> [, <colonna>]] [OR ...]]]
    ON <tabella>
    [REFERENCING
        OLD AS <nuovoNomeOld>
        NEW AS <nuovoNomeNew>
    ]
    [FOR EACH ROW]
    [WHEN (<condizione>)]   -- Se la condizione è specificata su `OLD` e `NEW`, non devono essere preceduti da `:`;
[DECLARE
    [<nomeVarLocale> <tipo>;]
]
BEGIN
    -- Corpo del trigger

    -- Operazioni
END;
```
**ATTENZIONE!** E' importante notare che la clausola `OF <colonna> [, <colonna>]` è validata **SOLO** se l'evento in questione è un `UPDATE` **INOLTRE** un trigger **NON** può operare **direttamente** sulla sua stessa tabella (_trigger ricorsivo_, ritorna l'errore **mutating table**)!

All'interno del trigger è possibile specificare se alcune operazione devono essere eseguite in base all'avvenimento di un dato evento (utile se gli eventi sono molteplici).

Esse possono essere analizzate come condizione sia dalla clausola `IF-ELSIF-ELSE` che dalla clausola `CASE-WHEN`.

Es.:
```
CREATE OR REPLACE TRIGGER print_emp_operation
    BEFORE
        INSERT OR
        UPDATE OF salary OR
        DELETE
    ON employees
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('Inserting');
    ELSIF UPDATING('salary') THEN
        DBMS_OUTPUT.PUT_LINE('Updating salary');
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Deleting');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER print_emp_operation
    BEFORE
        INSERT OR
        UPDATE OF salary OR
        DELETE
    ON employees
BEGIN
    CASE
        WHEN INSERTING THEN
            DBMS_OUTPUT.PUT_LINE('Inserting');
        WHEN UPDATING('salary') THEN
            DBMS_OUTPUT.PUT_LINE('Updating salary');
        WHEN DELETING THEN
            DBMS_OUTPUT.PUT_LINE('Deleting');
    END CASE;
END;
```
Entrambi i codici sono perfettamente equivalenti.

Inoltre, in un trigger si ha accesso anche particolari variabili, definite **pseudorecord**: esse rappresentano un record _prima_ dell'esecuzione del trigger (`OLD`) e un record _dopo_ l'esecuzione del trigger (`NEW`).

**N.B.:** Esiste inoltre uno pseudorecord definito `PARENT`, ma non ho ben capito il suo utilizzo.

Ecco la tabella dei valori che assumeranno in base all'evento:

| Evento   | `OLD`            | `NEW`             |
| :------: | ---------------- | ----------------- |
| `INSERT` | `NULL`           | Nuovo record      |
| `UPDATE` | Record originale | Record aggiornato |
| `INSERT` | Vecchio record   | `NULL`            |

E' inoltre possibile cambiare il nome di questi pseudorecord usando la direttiva `REFERENCING`. Vi si può accedere al valore in esso contenuti nella clausola `WHEN` del trigger (senza essere preceduti da `:`) o all'interno del corpo del trigger (essendo preceduti da `:`). E' possibile cambiare **solo** il valore di `NEW` quando il trigger è di tipo `BEFORE`.

### Ovviare il mutating table
L'errore **mutating table** si presenta quando un trigger è **ricorsivo**, ovvero quando opera sulla stessa tabella oppure quando un un trigger prova ad accedere ad informazioni che vengono modificate da un altro trigger.

Per ovviare il mutating table è possibile utilizzare i trigger composti.

A differenza dei simple trigger, questi permettono di eseguire più statement temporali.

_[Da continuare]_

<!-- Es.:
> **Problema**: in una tabella `employees` abbiamo una lista di dipendenti. Supponiamo di voler aggiungere il simbolo '\*' al nome ogni volta che il salario di un dipendente aumenta.

**Soluzione**: Supponiamo di avere le seguenti tabelle:
```
CREATE TABLE employees (
    id NUMBER(5) DEFAULT emp_id_autoinc.NEXTVAL CONSTRAINT emp_id_pk PRIMARY KEY,
    name VARCHAR2(32) NOT NULL,
    surname VARCHAR2(32) NOT NULL,
    salary NUMBER(8, 2) DEFAULT ON NULL 300.00 CONSTRAINT emp_salary_chk CHECK (salary >= 250 AND salary < 30000)
);
```

```
CREATE TABLE emp_salary_logs (
    emp_id NUMBER(5) NOT NULL,
    salary_increase NUMBER(8, 2) NOT NULL,
    increased_at TIMESTAMP DEFAULT ON NULL CURRENT_TIMESTAMP,
    CONSTRAINT emp_fk FOREIGN KEY (emp_id) REFERENCES employees(id)
);
```

Trigger di `employees`:
```
CREATE OR REPLACE TRIGGER emp_salary_increase
BEFORE
    UPDATE OF salary ON employees
    REFERENCING
        NEW AS rich
        OLD AS poor
    FOR EACH ROW
WHEN (rich.salary > poor.salary)
BEGIN
    INSERT INTO emp_salary_logs(emp_id, salary_increase, increased_at)
    VALUES (:rich.id, (:rich.salary - :poor.salary), CURRENT_TIMESTAMP);
END;
``` -->


## SQL Dinamico
La parte precedentemente vista è definita come **statica** in quanto interagisce solo con elementi già definiti.
La potenzialità di PL/SQL sta nel fatto che possiamo costruire informazioni da far successivamente eseguire.

La sinstassi per l'esecuzione di query dinamicamente è la seguente:
```
EXECUTE IMMEDIATE <query | variabile | blocco anonimo>
    [[RETURNING | BULK COLLECT] INTO <varContenitore>]
    [USING [IN | OUT | IN OUT] <varPlaceholder> [, [IN | OUT | IN OUT] <varPlaceholder> ...]];
```

Il comando, in quanto molto complesso verrà esplicato da quanto segue:

1. `EXECUTE IMMEDIATE`: dichiara l'inizio di un'esecuzione dinamica;
1. `<query | variabile | blocco anonimo>`:
    1. `query`: query SQL che può contenere placeholder. **Non deve** terminare con il simbolo `;`;
    1. `variabile`: variabile di tipo `VARCHAR2` o `CHAR` di qualsivoglia natura (dichiarazione diretta o ricevuta da query). Può contenere un blocco anonimo.
    1. `blocco anonimo`: blocco di codice in PL/SQL. Deve essere inscritto in una clausola `BEGIN ... END;` (deve terminare con punto e virgola), es.: `BEGIN DMBS_OUTPUT.PUT_LINE('Hello world!') END;`.
1. `[[RETURNING | BULK COLLECT] INTO <varContenitore>]`: le clausole indicate hanno scopi diversi, ma quasi mai coesistenti:
    1. `RETURNING INTO <varContenitore>`: utilizzabile per una qualsiasi query DML escluso il `SELECT` (quindi `UPDATE`, `DELETE`, `INSERT`). Conterrà una collection degli elementi interessati dalla query appena eseguita. Sostituibile con una clausola `USING`;
    1. `BULK COLLECT INTO <varContenitore>`: da utilizzare quando una query `SELECT` ritorna più righe;
    1. `INTO <varContenitore>`: da utilizzare quando una query `SELECT` ritorna una sola riga;
1. `USING [IN | OUT | IN OUT] <varPlaceholder>`: vengono assegnati i valori di placeholder che possono essere usati come `IN`, `OUT` oppure `IN OUT`.

Nella descrizione precedente vi si è potuto leggere spesso il termine **placeholder**, questo rappresenta una stringa che verrà sostituita con un valore indicato nella clausola `USING` (questa operazione di sostituzione è chiamata **binging**).
La corrispondenza tra placeholder e variabile 'bindata' è **posizionale**.
_Secondo la documentazione, in contesti come il `RETURNING INTO` e il `BULK COLLECT INTO` è possibile specificare più output binding._

**ATTENZIONE!** Se un elemento viene creato dinamicamente, nella stessa sessione si consiglia di interagire con esso sempre in maniera dinamica.

Ecco un esercizio esempio:
Supponiamo che diamo la possibilità di definire una tabella ad un utente (caso da considerarsi **solo** a livello **didattico**!), quindi supponiamo di avere la seguente tabella:

```
CREATE SEQUENCE user_id_autoinc;   -- Gestisce l'incremento automatico dell'ID;
CREATE TABLE users (
    id NUMBER(5) DEFAULT user_id_autoinc.NEXTVAL CONSTRAINT users_id_pk PRIMARY KEY,
    username VARCHAR2(32) NOT NULL CONSTRAINT users_username_uq UNIQUE,
    is_admin NUMBER(1) DEFAULT 0 CONSTRAINT users_admin_chk CHECK (is_admin IN (0, 1)),   -- BOOLEAN
    custom_table VARCHAR2(1000) NULL
);
```
Al momento ignoriamo la possibilità di popolare `custom_table` solo se `is_admin` è `TRUE` (1), ma verrà verificata in runtime la possibilità di poter create la tabella.

```
DECLARE
    CURSOR usr_cursor IS SELECT * FROM users;
    usr users%ROWTYPE;
BEGIN
    FOR usr IN usr_cursor LOOP
        IF usr.is_admin = 1 THEN
            EXECUTE IMMEDIATE usr.custom_table;

            -- Se volessimo eseguire un INSERT nella tabella appena creata, dovremmo avviare la query tramite un EXECUTE IMMEDIATE.

            DBMS_OUTPUT.PUT_LINE(usr.username || '''s table should have been created.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(usr.username || ' is not an admin.');
        END IF;
    END LOOP;
END;
```
E' possibile vedere lo script in azione [qui](https://livesql.oracle.com/apex/livesql/s/f4em324mzj360xawduk8kzi33).


## Funzioni e istruzioni utili
**IMPORTANTE!** Trovo scontato dire che ovviamente le funzioni possono accettare anche variabili anzichè valori diretti, quindi lo preciso a monte.

### `LENGTH`
Restituisce la lunghezza della stringa passata come argomento oppure `NULL` se la stringa non ha lunghezza (`''`) o se ha un valore pari a `NULL`.

Sintassi:
```
LENGTH(stringa);
```

Esempi:
```
LENGTH('stringa');   -- Ris.: 7;

LENGTH(' ')   -- Ris.: 1;

LENGTH('')   -- Ris.: NULL;

LENGTH()   -- Ris.: NULL;
```


### `INSTR`
Restituisce la posizione di una sottostringa (`ago`) in una stringa passata (`pagliaio`) oppure `0` se la sottostringa non esiste.

E' possibile specificare da che posizione della stringa partire (`posizione_iniziale`, default: 1) e il numero dell'occorenza di cui restituire la posizione (`num_occorenza`, default: 1).

`posizione_iniziale` può essere anche un valore negativo, in questo caso, il controllo avverà dalla fine della stringa fino all'inizio. Il valore minimo utile e `lunghezza`

Sintassi:
```
INSTR(pagliaio, ago [, posizione_iniziale := 1 [, num_occorrenza := 1]]);
```

Esempi:
```
INSTR('loreM ipsuM', 'M');   -- Ris.: 5;

INSTR('loreM ipsuM', 'M', 1, 1);   -- Ris.: 5; Equivalente al primo esempio;

INSTR('loreM ipsuM', 'M', 6, 1);   -- Ris.: 11; Inizia a contare dallo spazio;

INSTR('loreM ipsuM', 'M', 1, 2);   -- Ris.: 11 (seconda occorenza di 'M');

INSTR('loreM ipsuM', 'M', -1, 1);   -- Ris.: 11 (prima occorenza di 'M' dalla fine);

INSTR('loreM ipsuM', 'M', -1, 2);   -- Ris.: 5 (seconda occorenza di 'M' dalla fine);

INSTR('loreM ipsuM', 'b');   -- Ris.: 0;
```


### `SUBSTR`
Restituisce una sottostringa estratta dalla stringa passata a partire dalla posizione specificata (`posizione_iniziale`) includendo questa, oppure `NULL` se la lunghezza (`lunghezza`, default: `0`) indicata è negativa.

Se `posizione_iniziale` è `0`, viene trattato come `1`.
Se `posizione_iniziale` è un valore negativo, la sottostringa verrà ricavata dalla fine della stringa, inoltre `lunghezza` verrà ignorato.

Sintassi:
```
SUBSTR(stringa, posizione_iniziale [, lunghezza := 0]);
```

Esempi:
```
SUBSTR('Lorem ipsum', 1);   -- Ris.: 'Lorem ipsum';

SUBSTR('Lorem ipsum', 3);   -- Ris.: 'rem ipsum';

SUBSTR('Lorem ipsum', 1, 5);   -- Ris.: 'Lorem';

SUBSTR('Lorem ipsum', 0, 5);   -- Ris.: 'Lorem';   -- Equivalente alla precedente;

SUBSTR('Lorem ipsum', 3, 5);   -- Ris.: 'rem';

SUBSTR('Lorem ipsum', -1);   -- Ris.: 'm';

SUBSTR('Lorem ipsum', -5);   -- Ris.: 'ipsum';

SUBSTR('Lorem ipsum', -1, 5);   -- Ris.: 'm';    -- La lunghezza viene ignorata;

SUBSTR('Lorem ipsum', -5, 5);   -- Ris.: 'ipsum';    -- La lunghezza viene ignorata;
```


### `UPPER`
Restituisce la stringa passata in maiuscolo.

Sintassi:
```
UPPER(stringa);
```

Esempi:
```
UPPER('lorem ipsum');   -- Ris.: 'LOREM IPSUM';

UPPER('LOREM IPSUM');   -- Ris.: 'LOREM IPSUM';

UPPER('Lorem Ipsum');   -- Ris.: 'LOREM IPSUM';
```

### `LOWER`
Restituisce la stringa passata in minuscolo.

Sintassi:
```
LOWER(stringa);
```

Esempi:
```
LOWER('lorem ipsum');   -- Ris.: 'lorem ipsum';

LOWER('LOREM IPSUM');   -- Ris.: 'lorem ipsum';

LOWER('Lorem Ipsum');   -- Ris.: 'lorem ipsum';
```


### `INITCAP`
Restituisce la stringa passata in minuscolo, ma con ogni iniziale in maiuscolo.

Sintassi:
```
INITCAP(stringa);
```

Esempi:
```
INITCAP('lorem ipsum');   -- Ris.: 'Lorem Ipsum';

INITCAP('LOREM IPSUM');   -- Ris.: 'Lorem Ipsum';

INITCAP('Lorem Ipsum');   -- Ris.: 'Lorem Ipsum';
```


### `REPLACE`
Restituisce la stringa passata (`pagliaio`) sostituendo ogni occorenza di una sottostringa (`ago`) con una stringa di sostituzione passata (`sostituto`) oppure semplcemente le rimuove se questa è vuota.

Sintassi:
```
REPLACE(pagliaio, ago[, sostituto]);
```

Esempi:
```
REPLACE('0Lorem0Ipsum0', '0');   -- Ris.: 'LoremIpsum';

REPLACE('0Lorem0Ipsum0', '0', '');   -- Ris.: 'LoremIpsum';   -- Equivalente alla prima;

REPLACE('0Lorem0Ipsum0', '0', NULL);   -- Ris.: 'LoremIpsum';   -- Equivalente alla prima;

REPLACE('0Lorem0Ipsum0', '0', '1');   -- Ris.: '1Lorem1Ipsum1';
```


### `TRANSLATE`
Restituisce la stringa passata (`pagliaio`) sostituendo ogni occorenza di un carattere di una sottostringa (`ago`) con un carattere posizionalmente corrispondente ad esso indicato in una stringa di sostituzione passata (`sostituto`).

Sintassi:
```
TRANSLATE(pagliaio, ago, sostituto);
```

Esempi:
```
TRANSLATE('1lorem ipsum02', '012', 'ABC');   -- Ris.: 'Blorem ipsumAC';
```
