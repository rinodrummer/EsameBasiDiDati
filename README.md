# PL/SQL

| Operatore | Funzione |
| :---: | ------- |
| `:=`  | Assegnazione |
| `=`  | Uguaglianza |
| `<>` | Disuguaglianza |
| `>` | Maggiore |
| `<` | Minore |
| `>=` | Maggiore o uguale |
| `<=` | Minore o uguale |
| `\|\|` | Concatenazione |
| `..` | Range di valori |
| `--` | Commento su linea singola |
| `/* */` | Commento multilinea |


| Tipo di dato |    Nome     |
| ------------ |    :---:    |
|   Numerico   |   `NUMBER`, `INTEGER`, `REAL`  |
|   Carattere  |   `CHAR`    |
|   Stringa    |  `VARCHAR2` |
|   Booleano   |  `BOOLEAN`  |
|     Data     |    `DATE`   |
|     Ora      |    `TIME`   |
|   Data/Ora   | `TIMESTAMP` |

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
Le condizioni vengono espresse con la seguente sintassi:
```
IF (cond1) THEN
    ...
ELSIF (cond2) THEN
    ...
ELSE
    ...
END IF;
```

E' anche possibile utilizzare la clausola `CASE` con la seguente sintassi, denominata simple CASE:
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

La forma alternativa è chiamata searched CASE e può essere usata anche in assegnazione ad una variabile, come nell'esempio:
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

    -- Operazioni
END;
```

### Loop
I loop rappresentano un elemento di fondamentale importanza in PL/SQL in quanto la maggior parte dei dati con cui ci si interfaccia sono "collezioni" di record.

## Definizione di elementi

### Definizione di un tipo personalizzato (subtipo)
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

Come è possibile notare, una variabile può non ricevere assegnazione alla creazione.
Essa avrà valore `NULL`.

Bisogna fare assoluta attenzione a questo caso: una variabile di questo tipo,
specialmente nel contesto numerico non può essere usata come valore incrementale.

Es.:
```
DECLARE
    counter INTEGER;   -- counter = NULL
BEGIN
    counter := counter + 1; -- counter sarà ugualmente NULL!
END;
```

E' anche possibile associare il tipo di una colonna (o di un'altra variabile) alla corrente in dichiarazione, es.:
```
x NUMBER(5) := 10;
y x%TYPE := 5;

emp_salary employees.salary%TYPE;
```

E' inoltre anche possibile dichiarare un elemento che fa riferimento alla **totale** struttura di una tabella, ovvero una variabile **_record_**:
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
