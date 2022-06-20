<?php
	$unControleur->setTable("viewAppareil");
	/**************************************************Rechercher****************************************/
	if (isset($_POST['Rechercher']))
	{
		$tab = array("idproduit","img", "nom", "quantite", "prix", "formatPellicule", "nbPoses", "focale", "alimentation", "dimension"); 
		$mot = $_POST['mot']; 
		$lesAppareils = $unControleur->selectSearch($tab, $mot); 
	}
	else
	{
		$lesAppareils = $unControleur->selectAll();
	}
	/**************************************************Fin Rechercher****************************************/
	/**************************************************Ajouter au panier****************************************/
	if (isset($_POST['AjouterAuPanier']))
	{
		$idProduit = $_POST['idproduit']; 
		 
		if (isset($_SESSION['idpanier']))
		{
			//appeler une mise à jour de la quantite dans contenir ou creer une quantite dans contenir si le produit est commandé pour la premiere fois. 
			$unControleur->updateContenir($idProduit, $_SESSION['idpanier'], "+1");
		}else
		{
		$tab = array("idproduit"=>$idProduit);
		$unControleur->insertProc("insertPanier", $tab); 
		$where = array("idproduit"=>$idProduit); 
		$unControleur->setTable("contenir"); 
		$idpanier = $unControleur->selectWhere ($where)["idpanier"];
		//recuperer l'id du panier et le mettre dans la session 
		$_SESSION['idpanier'] =  $idpanier; 
		}
	}
	/**************************************************Fin Ajouter au panier****************************************/
	require_once ("view/view_liste_appareils.php");
?>