# Frivillig prosjekt i Nettverksprogrammering 
## Gruppemedlemmer
- Andreas Gjersøe
- Frikk Balder Ormestad Larsen
- Henrik Gulbrandsen Nilsen

## Info om applikasjonen
Applikasjonen er skrevet i Verilog, enkelte biter krever System Verilog flagg satt for kompilering.
Koden inneholder en modul som utfører elementvis multiplikasjon av vektorer samt prikkprodukt. Testbench genererer et bestemt antall tilfeldige vektorer med bestemt størrelse. Resultat av utregninger kan vises vet å sette SHOW_PROGRESS = 1. Det er laget to testbenches, en for vanlig kjøring, en annen som oppretter en modul for å håndtere hvert vektorpar. Denne løsningen er ikke ment for å være optimal, men for å illustrere en måte å parallellisere programmet. En bedre måte å gjøre dette på er nok å beregne et fornuftig antall moduler som skal initialiseres, basert på antall vektorpar, og fordele de over modulene. Slik det er nå, blir kjøring av mange moduler samtidig svært tungt. 
Uavhengig av dette, slik vi forstår det, skal for-løkken i modulen syntetiseres slik at den vil kunne foregå i parallell.

Beregning av prikkprodukt kunne også blitt utført i en egen always block som kjører parallellt med blocken som multipliserer. Da hadde prikkproduktet utført samme operasjon som multiplikasjonen, og oppdatert verdien sin. Denne tilnærmingen kan være mer parallellisert, men mer ressurskrevende for applikasjonen.

For å kompilere programmet kan man laste ned kompilatoren Icarus Verilog.
## Last ned kompilator
```sh
sudo apt install iverilog
```

## Kompiler programmet/filene
```sh
iverilog -g2012 -o sim vector_multiplier.v vector_multiplier_tb.v
```
Kan eventuelt prøve ut enkelt forslag til parallellisert applikasjon
```
iverilog -g2012 -o sim vector_multiplier.v parallel_multiplier_tb.v
```

## Kjør programmet
```sh
vvp sim
```
