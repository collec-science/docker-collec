<?php
/** Fichier cree le 4 mai 07 par quinton
 * Renommez le fichier en param.inc.php
 * ajustez les parametres a votre implementation
 * conservez une sauvegarde de ces parametres pour ne pas les perdre 
 * lors de la mise en place d'une nouvelle version
 * tous les parametres presents dans param.default.inc.php peuvent etre utilises
 */
 /*
  * Affichage des erreurs et des messages
  */
$APPLI_modeDeveloppement = true;
$_ERROR_display = 0;
$ERROR_level = E_ERROR ;
$OBJETBDD_debugmode = 1;

/*
 * code de l'application dans la gestion des droits
 */
$GACL_aco = "col";
/*
 * Code de l'application - impression sur les etiquettes
 */
$APPLI_code = 'laboXX';
/*
 * titre de l'application affiche en haut d'ecran
 */
$APPLI_titre = "Collec";

/*
 * Mode d'identification
 * BDD : uniquement a partir des comptes internes
 * LDAP : uniquement a partir des comptes de l'annuaires LDAP
 * LDAP-BDD : essai avec le compte LDAP, sinon avec le compte interne
 * CAS : identification auprès d'un serveur CAS
 */
$ident_type = "BDD";
 /*
  * Adresse du serveur CAS
  */
// $CAS_address = "http://localhost/CAS";
/*
 * Parametres concernant la base de donnees
 */
$BDD_login = "collec";
$BDD_passwd = "collec";
$BDD_dsn = "pgsql:host=postgiscollec;dbname=collec";
$BDD_schema = "col,gacl,public";

/*
 * Rights management, logins and logs records database
 */
$GACL_dblogin = "collec";
$GACL_dbpasswd = "collec";
$GACL_aco = "col";
$GACL_dsn = "pgsql:host=postgiscollec;dbname=collec";
$GACL_schema = "gacl";

/*
 * Lien vers le site d'assistance
 */
//$APPLI_assist_address = "https://github.com/Irstea/collec/issues/new";
/*
 * Adresse d'acces a l'application (figure dans les mails envoyes)
 */
$APPLI_address = "https://collec.adressecomplete.com";
/*
 * Adresse mail figurant dans le champ expediteur, lors de l'envoi de mails
 */
$APPLI_mail = "nepasrepondre@collec.adressecomplete.com";
/*
 * Activer l'envoi de mails
 */
//$MAIL_enabled = 1;
/*
 * Activer la fonction de reinitialisation d'un mot de passe perdu
 * identification de type BDD ou LDAP-BDD pour les comptes declares localement
 * necessite que l'envoi de mails soit possible ($MAIL_enabled = 1)
 */
$APPLI_lostPassword = 1;
/*
 * Configuration LDAP
 */
$LDAP ["address" ] = "localhost";
/*
 * pour une identification en LDAPS :
 * port = 636
 * tls = true;
 */
$LDAP ["port" ] = 636;
$LDAP [ "tls"] = true;
/*
 * chemin d'accès a l'identification
 */
$LDAP [ "basedn"] = "ou=people,ou=example,o=societe,c=fr";
$LDAP [ "user_attrib" ] = "uid";

/*
 * Recherche des groupes dans l'annuaire LDAP
 * Decommenter la premiere ligne pour activer la fonction
 */
 //$LDAP [ "groupSupport" ] = true;
$LDAP [ "groupAttrib" ] = "supannentiteaffectation";
$LDAP [ "commonNameAttrib" ] = "displayname";
$LDAP [ "mailAttrib" ] = "mail";
$LDAP [ 'attributgroupname' ] = "cn";
$LDAP [ 'attributloginname' ] = "memberuid";
$LDAP [ 'basedngroup' ] = 'ou=group,ou=example,o=societe,c=fr';

/*
 * Chemin d'acces au fichier param.ini
 * Consultez la documentation pour plus d'informations
 */
$paramIniFile = "./param.ini";
/*
 * Traitement de param.ini dans un contexte multi-bases (cf. documentation)
 */
//$chemin = substr($_SERVER["DOCUMENT_ROOT"],0, strpos($_SERVER["DOCUMENT_ROOT"],"/bin"));
//$paramIniFile = "$chemin/param.ini";
/*
 * Si l'application n'est pas configuree avec un DNS unique 
 * (chemin de type : https://serveur/collec-science/)
 */
 //$SMARTY_variables["display"] = "display";
 //$SMARTY_variables["favicon"] = "favicon.png";
 //$APPLI_isFullDns = false;

/*
 * Parametres SMARTY complementaires, charges systematiquement
 * Ne pas modifier !
 */
$SMARTY_variables["melappli"] = $APPLI_mail;
$SMARTY_variables["ident_type"] = $ident_type;
$SMARTY_variables["appliAssist"] = $APPLI_assist_address;
$SMARTY_variables["display"] = "display";
$SMARTY_variables["favicon"] = "favicon.png";

?>

