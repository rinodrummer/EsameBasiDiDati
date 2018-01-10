# PL/SQL

Tutti i contenuti di questo repo fanno riferimento alla [documentazione ufficiale del linguaggio PL/SQL](https://docs.oracle.com/cloud/latest/db112/LNPLS/toc.htm).

Molti contenuti sono ripresi esattamente come trattati dalla documentazione sopra citata.
**Si sottolinea anche che la seguente può esser vista come una traduzione e un riassunto della stessa e che lo scop finale di questa repo è esclusivo a fini DIDATTICI!**

Si esorta inoltre all'utilizzo di [Live SQL](https://livesql.oracle.com/) di Oracle: strumento utilissimo per la comprensione del linguaggio.

## Leggenda:
| Simbolo   | Significato               |
| :-------: | ------------------------- |
| `[ ... ]` | Elemento opzionale        |
| `< ... >` | Elemento obbligatorio     |

## Indice
1. [Introduzione](#pl-sql):
    * [Leggenda](#leggenda);
    * [Indice](#indice);
* [Struttura di uno script](#struttura-di-uno-script);
* [Operatori](#operatori);
* [Tipi di dato](#tipi-di-dato);
* [Struttura di uno script](#struttura-di-uno-script);
* [Strutture di controllo](#strutture-di-controllo);
    1. Condizioni:
        1. [`IF-ELSIF-ELSE`](#if-elsif-else);
        * [`CASE`](#case):
            * Simple `CASE`;
            * Searched `CASE`;
    * [Loop](#loop):
        1. [Simple `LOOP`](#simple-loop):
            * Utilizzo dell'`EXIT` e dell'`EXIT WHEN`;
            * Utilizzo dell'`EXIT` con le label;
        * [`FOR LOOP`](#for-loop);
        * [`WHILE LOOP`](#while-loop) _(Mancante)_;
        * [`LOOP` con cursore](#cursor-loop) _(Mancante)_;
    * [Definizione di elementi](#definizione-di-elementi):
        * [Definizione di tipi personalizzati (subtipi)](#definizione-di-un-subtipo);
        * [Definizione di variabili e costanti](#definizione-di-variabili-e-costanti):
            * [`%TYPE` e `%ROWTYPE` (var. **record**)](#type-e-rowtype);
            * [Cursore](#cursore) _(Mancante)_;
        * [Definizione di procedure e funzioni](#definizione-di-e-procedure-funzioni);
* [Ringraziamenti](#ringraziamenti);

## Operatori
| Operatore | Funzione                  |
| :-------: | ------------------------- |
| `:=`      | Assegnazione              |
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
| Tipo di dato | Nome                         |
| ------------ | :--------------------------: |
|   Numerico   | `NUMBER`, `INTEGER`, `REAL`  |
|   Carattere  | `CHAR`                       |
|   Stringa    | `VARCHAR2`                   |
|   Booleano   | `BOOLEAN`                    |
|     Data     | `DATE`                       |
|     Ora      | `TIME`                       |
|   Data/Ora   | `TIMESTAMP`                  |

## Struttura di uno script
```
DECLARE
    -- Dichiarazione di subtipi
    -- Dichiarazione di variabili, costanti e procedure
BEGIN
    -- Corpo dello script
END;
```

## Strutture di controllo
Le strutture di controllo presenti in PL/SQL sono principalmente condizioni e loop.

### Condizioni
Le condizioni vengono espresse con le seguenti sintassi:

### IF-ELSIF-ELSE
```
IF (cond1) THEN
    ...
ELSIF (cond2) THEN
    ...
ELSE
    ...
END IF;
```

#### CASE
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

#### Simple LOOP
```
[<<label>>] LOOP
    ...
END LOOP [<<label>>];
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

#### FOR LOOP
Il `FOR LOOP` è un loop principalmente basato sui range e sull'utilizzo di un contatore.
Esso presenta la seguente sintassi:
```
[<<label>>] FOR index IN [ REVERSE ] lower_bound..upper_bound LOOP
  statements
END LOOP [ label ];
```


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

#### %TYPE e %ROWTYPE
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

**ATTENZIONE!** L'inserimento in una tabella tramite l'utilizzo di una variabile record avviene in forma canonica!

Es.:
```
INSERT INTO employees(id, name, surname, salary)
VALUES (emp.id, emp.name, emp.surname, emp.salary);
```

#### Cursore
Esiste inoltre uno speciale tipo di variabile chiamato **cursore**. Questo
<!-- FIXME Continuare la sezione dedicata ai cursori. -->


### Definizione di procedure e funzioni
E' scontato ricordare che le procedure non ritornano valore, le funzioni sì.

Per quanto riguarda le procedure, la sintassi è la seguente:
```
PROCEDURE <nomeProcedura> (
    [<nomeParametro> [IN OUT] <tipo>] [,
    [<nomeParametro> [IN OUT] <tipo>]]
) IS
    [<nomeVarLocale> <tipo>] [,
    [<nomeVarLocale> <tipo>]]
BEGIN
    ...   -- corpo della funzione
END;
```

Es.:
```
DECLARE
    emp NUMBER := 1;
    emp_salary NUMBER(5);

    PROCEDURE adjust_salary (
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
BEGIN
    SELECT salary
    INTO emp_salary
    FROM employees
    WHERE id = emp;

    adjust_salary(emp, 30, emp_salary);
END;
```

La seguente procedura aggiunge un dato valore al salario di un dipendente.
Può essere visto all'opera [qui](https://livesql.oracle.com/apex/livesql/s/f30wems22by88g8eqhi6oeus5).

---

Mentre la sintassi per dichiarare una funzione è la seguente:
<!-- TODO Continuare la sezione dedicata alle funzioni. -->

# Rigraziamenti
- Si ringrazia eternamente **Alessandro Rubino** per gli splendidi appunti.
