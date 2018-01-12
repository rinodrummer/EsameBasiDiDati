# SQL

**SQL** (_Structured Query Language_) è un linguaggio standardizzato per database basati sul modello relazionale (RDBMS) progettato per:

* Creare e modificare schemi di database (**DDL** - _Data Definition Language_);
* Inserire, modificare e gestire dati memorizzati (**DML** - _Data Manipulation Language_);
* Interrogare i dati memorizzati (**DQL** - _Data Query Language_);
* Creare e gestire strumenti di controllo ed accesso ai dati (**DCL** - _Data Control Language_).

_Fonte: [SQL](https://it.wikipedia.org/wiki/Structured_Query_Language) - Wikipedia._

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
1. [Viste (`VIEW`)](#viste-view);

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
