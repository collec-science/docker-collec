# Installation de l'imprimante Zebra en USB sur Raspberry Pi

## Branchement de l'imprimante

Pour commencer, il faut brancher la Zebra en USB sur le Pi.

Afin de voir les périphériques connectés en USB au Pi, il faut utiliser la commande :

```
lsusb
Bus 001 Device 004: ID 0930:6545 Toshiba Corp. Kingston DataTraveler 102 Flash Drive / HEMA Flash Drive 2 GB / PNY Attache 4GB Stick
Bus 001 Device 005: ID 0a5f:008e Zebra
Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp. SMSC9512/9514 Fast Ethernet Adapter
Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

On voit que la Zebra (2ième ligne est directement reconnue par le Pi)

## Installation/configuration de CUPS sur le Pi pour la gestion des imprimantes

Source:[http://www.sky-future.net/2013/12/05/comment-installer-une-imprimante-sur-le-raspberry-pi/](http://www.sky-future.net/2013/12/05/comment-installer-une-imprimante-sur-le-raspberry-pi/)

Source : https://www.howtogeek.com/169679/how-to-add-a-printer-to-your-raspberry-pi-or-other-linux-computer/

Les commandes pour l'installation :
```
sudo apt-get update
sudo apt-get install cups
```

Il faut ensuite ajouter notre user (pi) dans le groupe "lpadmin" créé par CUPS pour avoir accès aux imprimantes

```
sudo usermod -a -G lpadmin pi
```
ou 
```
sudo adduser $USER lpadmin
```

Ensuite il faut éditer le fichier conf

```
sudo vi /etc/cups/cupsd.conf
```

Il faut commenter la ligne `Listen localhost:631` sous `# Only listen for connections from the local machine.` et ajouter à la suite la ligne `Port 631`.

Rechercher aussi dans le fichier :
```
# Restrict access to the server...
# Restrict access to the server...
<Location />
  Order allow,deny
</Location>

# Restrict access to the admin pages...
<Location /admin>
  Order allow,deny
</Location>

# Restrict access to configuration files...
<Location /admin/conf>
  AuthType Default
  Require user @SYSTEM
  Order allow,deny
</Location>
```
et modifier ce paragraphe comme suit :
```
# Restrict access to the server...
<Location />
  Order allow,deny
  Allow @local
</Location>

# Restrict access to the admin pages...
<Location /admin>
  Order allow,deny
  Allow @local
</Location>

# Restrict access to configuration files...
<Location /admin/conf>
  AuthType Default
  Require user @SYSTEM
  Order allow,deny
  Allow @local
</Location>

```

Une fois le fichier de conf modifié il faut redémarre CUPS : `sudo /etc/init.d/cups restart`

A partir de là on peut se rendre sur l'interface web de CUPS à l'adresse <ip>:631 (depuis le Pi ou depuis un ordinateur distant).

De là il faut cliquer sur `Administration` -> `Ajouter une imprimante`. Il faut sélectionner l'imprimante `Zebra Technologies Zebra (Zebra Technologies Zebra)`, ensuite prendre le driver `Zebra ZPL Label Printer (en)`

Ensuite dans un terminal :
```
echo "test" > test.txt
lpr -P Zebra_Technologies_Zebra test.txt
```

Ceci imprime bien le test, à noter que Zebra_Technologies_Zebra est le nom par défaut donné dans CUPS.

### Configuration de l'imprimante en Raw Queue pour imprimer directement du ZPL

La configuration en Raw Queue se fait au moment de la sélection du driver. Au lieu de garder le choix par défaut pour l'option `Make` : `Zebra`. Il faut cliquer sur `Select Another Make/Manufacturer`. Dans le menu déroulant il faut choisir `Raw`, puis le driver `Raw Queue (en)`. Pour plus de faciliter pour la suite l'imprimante à été nommé simplement `Zebra`.

Il faut d'abord calibrer les étiquettes avant d'imprimer, cela se fait avec ce code ZPL :

```
vi calibrate.zpl
```

```
~jc^xa^jus^xz
```

On imprime ensuite ce code qui va sortir 6 étiquettes vierge mais qui va calibrer l'imprimante

```
lpr -P Zebra calibrate.zpl
```

L'imprimante est prête pour imprimer une étiquette en ZPL

```
vi demo.zpl
```

```
^XA
^FO100,50^ADN,36,20^FDxxx^FS
^XZ
```

```
lpr -P Zebra demo.zpl
```

Un exemple de code ZPL pour du QRCode :

```
^XA^FO100,50^BQN,2,6^FDTest d'un QR code depuis le raspberry pi^FS^XZ
```

- La commande `FO` positionne le QR code sur l'étiquette
- La commande `^BQN` permet de choisir le model Enhanced (`2`) et la taille entre 1-10 du QR code (`6`)

# Installation de l'imprimante Zebra en bluetooth sur Raspberry Pi

## Configuration du bluetooth sur le Pi

Le bluetooth est configuré par défaut sur le Pi 3
sudo apt-get install bluez
sudo rfkill unblock all

https://doc.ubuntu-fr.org/bluetooth

pi@raspberrypi:~/GIT/docker-collec $ hcitool dev
Devices:
        hci0    B8:27:EB:FE:97:8E
pi@raspberrypi:~/GIT/docker-collec $ hciconfig -a
hci0:   Type: Primary  Bus: UART
        BD Address: B8:27:EB:FE:97:8E  ACL MTU: 1021:8  SCO MTU: 64:1
        UP RUNNING PSCAN
        RX bytes:1483 acl:0 sco:0 events:91 errors:0
        TX bytes:4003 acl:0 sco:0 commands:91 errors:0
        Features: 0xbf 0xfe 0xcf 0xfe 0xdb 0xff 0x7b 0x87
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH SNIFF
        Link mode: SLAVE ACCEPT
        Name: 'raspberrypi'
        Class: 0x000000
        Service Classes: Unspecified
        Device Class: Miscellaneous,
        HCI Version: 4.1 (0x7)  Revision: 0xb6
        LMP Version: 4.1 (0x7)  Subversion: 0x2209
        Manufacturer: Broadcom Corporation (15)


## Voir la zebra depuis le Pi

Il faut appareiller les 2 équipements :

```
sudo bluetoothctl
[bluetooth]# agent KeyboardOnly
Agent registered
[bluetooth]# default-agent
Default agent request successful
[bluetooth]# devices
Device AC:3F:A4:1F:2D:E8 ZebraZebra01
[bluetooth]#pair AC:3F:A4:1F:2D:E8
Attempting to pair with AC:3F:A4:1F:2D:E8
[CHG] Device AC:3F:A4:1F:2D:E8 Connected: yes
[CHG] Device AC:3F:A4:1F:2D:E8 Connected: no
[CHG] Device AC:3F:A4:1F:2D:E8 Connected: yes
Request PIN code
[agent] Enter PIN code: 1234
[CHG] Device AC:3F:A4:1F:2D:E8 UUIDs:
        00001101-0000-1000-8000-00805f9b34fb
[CHG] Device AC:3F:A4:1F:2D:E8 Paired: yes
Pairing successful
[CHG] Device AC:3F:A4:1F:2D:E8 Connected: no
```

Ensuite il faut installer le backend bluetooth pour CUPS (il faut que CUPS soit installé voir la partie installation CUPS au-dessus :

```
sudo apt-get install bluez-cups
```

Ensuite il faut aller sur l'interface web de CUPS à l'adresse <ip>:631 (depuis le Pi ou depuis un ordinateur distant) et configurer l'imprimante en bluetooth :

Il faut cliquer sur `Administration` -> `Ajouter une imprimante` -> `Hôte ou imprimante LPD/LPR `.

Dans connexion il faut ajouter : `bluetooth://AC3FA41F2DE8` (c'est la Mac address de l'imprimante sans les ':' qu'on récupère ci-dessus lors de l'appareillage). 

- Pour imprimer des PDF: 
Dans `Marque` il faut choisir `Zebra`. Pour plus de faciliter pour la suite l'imprimante à été nommé simplement `Zebra`.

- Pour imprimer en ZPL : 
Ensuite il faut donner un nom à son imprimante et la configurer en Raw Queue pour pouvoir imprimer du ZPL.
Dans `Marque` il faut choisir `Raw` (et non pas Zebra), puis le driver `Raw Queue (en)`. Pour plus de faciliter pour la suite l'imprimante à été nommé simplement `Zebra`.

L'impression se fait ensuite avec la commande lpr 
`lpr -P Zebra -o fit-to-page /path/to/Etiquettes/etiquette_test_2x1.25in.pdf`




