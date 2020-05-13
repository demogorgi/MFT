# MFT Stufe 1 und Stufe 2

## Stufe 1

### Aufruf
#### Berechnung eines Szenarios
    ruby doIt.rb verzeichnis_daten_erste_stufe/dateiname_daten_erste_stufe_ohne_dateinamenerweiterung
#### Beispiel
##### Berechnung des Szenarios hs_111
    ruby doIt.rb hs_111/hs_111
#### Berechnung aller Szenarien und Kopieren der Ergebnis-pngs nach Stufe1/Tests
    ruby tests.rb

Achtung: damit tests.rb für jedes Szenario funktioniert muss die Zimpl-Datei den gleichen Namen haben wie ihr übergeordnetes Verzeichnis, also z.B. Stufe1/hs_111/hs_111.zpl

### Voraussetzungen:
[ruby](https://www.ruby-lang.org/en/), [graphviz](https://www.graphviz.org/), [scip](https://scip.zib.de/index.php#download) und [zimpl](https://zimpl.zib.de/) müssen im Pfad sein. ruby, graphviz und zimpl sind beispielsweise in den Ubuntu-Paketquellen enthalten (sudo apt install zimpl).

### Ausgabe:
Insbesondere eine png-Datei, die die Ergebnisse visualisiert.
![](example_result_step1.png)

## Stufe 2

### Aufruf
#### Berechnung eines Szenarios
    ruby doIt.rb verzeichnis_daten_stufe21/dateiname_daten_stufe21_stufe_ohne_dateinamenerweiterung verzeichnis_daten_stufe22/dateiname_daten_stufe22_stufe_ohne_dateinamenerweiterung
#### Beispiel
##### Berechnung des Szenarios "Szenario1"
    ruby doIt.rb Szenario1/ug_01_21 Szenario1/ug_01_22
    
Die Daten von Stufe 2.1 und von Stufe 2.2 unterscheiden sich nur in den Kantenkapazitäten. Für Stufe 2.2 werden bis auf die Überspeisungen zwischen den Gasbeschaffenheitszonen alle Kanten mit einer nicht restriktiven Kapazität versehen. Dies hat den regulatorischen Hintergrund, dass Engpässe innerhalb einer Gasbeschaffenheit eigentlich nicht vorkommen dürfen und falls sie es doch tun, diese nicht durch Regelenergieeinsatz behoben werden dürfen.

### Ausgabe:
Zu beschaffende Regelenergie global und gasbeschaffenheitsspezifisch und erforderliche Unterbrechungen und Kürzungen in den NBZ.

### Erläuterungen:
Die Sufe 2 arbeitet in vier Schritten:

2.1. Berechnung der globalen und der gasbeschaffenheitsspezifischen Regelenergie. Die Kapazitäten innerhalb einer Gasbeschaffenheitszone sind nicht restriktiv. Die Regelenergie wird so berechnet, dass in jedem Extremszenario die Überspeisekapazitäten zwischen den Gasbeschaffenheitszonen ausreichen, um die Bilanzen der Gasbeschaffenheitszonen auszugleichen. Das Ergebnis wird in den folgenden beiden Stufen *nicht* weiterverwendet. (Ein Extremszenario zeichnet sich dadurch aus, dass die komplette Globalmenge und auch die kompletten GBH-Mengen komplett in einem Knoten realisiert werden)

2.2. Wie Schritt 2.1, jedoch mit den tatsächlichen Kapazitäten. Die Regelenergiemengen sind dann höchstens genauso groß wie in Schritt 2.1 und zusätzlich können Restmengen in den Knoten verbleiben, die dann durch Unterbrechung und Kürzung "neutralisiert" werden. In diesem Schritt werden nur die Unterbrechungs- und Kürzungsbetragssumme ermittelt, die dann in Schritt 2.3 als Parameter verwendet werden.

2.3. In diesem Schritt werden die Kürzungs- und Unterbrechungsmengen aus Schritt 2.2 soweit möglich gleichmäßig auf weitere Knoten verteilt, die ein gemeinsames Engpassgebiet innerhalb einer Gasbeschaffenheitszone bilden.

2.4 Dieser Schritt ist noch nicht implementiert, aber er funktioniert ganz ähnlich zu Schritt 2.2. In der Gasbeschaffenheit H müssen zwei Engpasszonen modelliert werden. Die Berechnung erfolgt dann analog zu Schritt 2.2 jedoch komplett ohne den L-Gas-Teil. Das Ergebnis sind dann die Restmengen, die über marktbasierte Instrumente (MBI) abgewickelt werden.
### Rechenbeispiele
Gedanklich sollen die unten in den Bildern dargestellten Werte der Zustand NACH der Berechnung von Stufe 1 sein. Die Kapazitäten sind die Kapazitäten für Stufe 2, die sich aus den Kapazitäten und den Flüssen aus Stufe 1 ergeben. Die Planwerte und das Puffern aus Stufe 1 sind also schon verrechnet.
#### Szenario 1
Beobachtung 1: Bei B und C zusammen müssen 25 Einheiten durch Unterbrechung und Kürzung "weg", da sonst die Kapazitäten zu A in manchen Szenarien nicht ausreichen, um die Bilanz auszugleichen.

Beobachtung 2: Zwischen B und C gibt es keinen Engpass.

Beobachtugn 3: Das Unterbrechungspotenzial bei B und C ist in Summe kleiner als -25 Einheiten, nämlich -15 Einheiten. Diese werden also komplett unterbrochen. Die verbleibenden 10 Einheiten müssen also gekürzt werden. Da das Kürzungspotenzial bei beiden gleich ist, werden bei B und bei C folglich jeweils -5 Einheiten gekürzt.
![](example_result_step2_szenario1.png)

#### Szenario 2
Beobachtung 1: Es hat sich im Vergleich zu Szenario 1 lediglich das Entryunterbrechungspotenzial bei C geändert von -10 auf -50.

Beobachtugn 2: Das Unterbrechungspotenzial bei B und bei C ist nun ausreichend, um die erforderlichen 25 Einheiten darzustellen.

Beobachtung 3: Das Unterbrechungspotenzial bei C ist 10 mal höher, als das bei B. Daher wird bei C auch die 10-fache Menge unterbrochen: 2.27... * 10 = 22.72...
![](example_result_step2_szenario2.png)


